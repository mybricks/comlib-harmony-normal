import { util, buffer } from '@kit.ArkTS';
import { fileIo, ReadOptions } from '@kit.CoreFileKit';
import { AVInnerRecord } from 'libavinnerrecord';
import { Constants } from './common/Constants';

interface AudioInnerConstructorParams {
  uiContext: UIContext;
  minHeight: number;
  maxHeight: number;
}
interface getFileBufferCallback {
  arrayBuffer: ArrayBuffer,
  buffer: buffer.Buffer
}

function getFileBuffer (filePath?: string): getFileBufferCallback | undefined {
  if (!filePath) return undefined
  const file = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY)
  const stat = fileIo.statSync(filePath);
  const fileSize = stat.size
  const arrayBuffer = new ArrayBuffer(fileSize);
  const readOptions: ReadOptions = {
    offset: 0,
    length: arrayBuffer.byteLength
  };
  let readLen = fileIo.readSync(file.fd, arrayBuffer, readOptions)
  fileIo.closeSync(file)
  const buf = buffer.from(arrayBuffer, 0, readLen);
  return {
    buffer: buf,
    arrayBuffer
  }
}

function concatBuffers(buffers: ArrayBuffer[]) {
  const totalLength = buffers.reduce((acc, buffer) => acc + buffer.byteLength, 0);
  const result = new ArrayBuffer(totalLength);
  const resultView = new Uint8Array(result);

  let offset = 0;
  buffers.forEach(buffer => {
    resultView.set(new Uint8Array(buffer), offset);
    offset += buffer.byteLength;
  });

  return result;
}

let fileWatcherTimer:number|undefined

export class AudioInner {
  private isInit = false
  private avInnerRecord = AVInnerRecord;
  private uiContext?: UIContext;
  // 最小高度
  private minHeight: number = 0;
  // 最大高度
  private maxHeight: number = 0;
  // 统计样本数量，确保计算的平均值准确
  private sampleValCnt: number = 0;
  // 累积样本能量的平方和，用于音量强度计算
  private sampleValSum: number = 0;
  // 录制存储文件路径
  private filePath?: string
  private bufferSize: number = 0;
  // 事件监听
  private eventListener: Map<string, Set<(value: ESObject) => void>> = new Map();

  constructor(params: AudioInnerConstructorParams) {
    this.uiContext = params.uiContext;
    this.minHeight = params.minHeight;
    this.maxHeight = params.maxHeight;
  }

  async init() {
    return new Promise<void>((resolve)=> {
      const hostContext = this.uiContext!.getHostContext();
      const path = hostContext!.cacheDir;
      this.filePath = `${path}/${util.generateRandomUUID()}.wav`
      this.avInnerRecord.init(this.filePath);
      this.isInit = true

      this.avInnerRecord.registerStateChangeCallback((state: number) => {
        this.eventListener.get('stateChange')?.forEach((listener) => {
          listener(state);
        });
      })

      this.avInnerRecord.off('readData')

      setTimeout(() => {
        resolve()
      }, 300)
    })
  }

  // 开始录制
  async start() {
    if (!this.isInit) {
      await this.init()
    }
    this.avInnerRecord.start();

    let buffers: ArrayBuffer[] = [];
    this.avInnerRecord.on('readData', (buffer) => {
      buffers.push(buffer)
      if (buffers.length === 2) {

        this.eventListener.get('readData')?.forEach((listener) => {
          listener(concatBuffers(buffers));
        });
        buffers = []

        this.eventListener.get('amplitudeChange')?.forEach((listener) => {
          listener(this.calculateDecibelHeight());
        });

        this.eventListener.get('durationChange')?.forEach((listener) => {
          listener(this.getDuration());
        });
      }

      this.bufferSize += buffer.byteLength;

      let samples = new Int16Array(buffer);
      for (let i = 0; i < samples.length; i++) {
        let val = samples[i] / Constants.VOLUME_MAX;
        this.sampleValSum += val * val;
        this.sampleValCnt += 1;
      }
    })
  }

  // 停止录制
  stop() {
    clearInterval(fileWatcherTimer)
    fileWatcherTimer = undefined
    this.avInnerRecord.stop();
  }

  // 销毁
  async destroy() {
    this.stop();
    this.isInit = false
    this.sampleValCnt = 0;
    this.sampleValSum = 0;
    this.bufferSize = 0;
    this.eventListener = new Map();
    const bufRes = getFileBuffer(this.filePath)
    if (!!bufRes) {
      return bufRes.buffer
    } else {
      return false
    }
  }

  // 重置
  async reset() {
    this.stop();
    this.isInit = false
    this.sampleValCnt = 0;
    this.sampleValSum = 0;
    this.bufferSize = 0;
    const bufRes = getFileBuffer(this.filePath)
    if (!!bufRes) {
      return bufRes.buffer
    } else {
      return false
    }
  }

  // 计算分贝
  calculateDecibelHeight(): number {
    if (this.sampleValCnt === 0) {
      return this.minHeight;
    }
    const rms = this.sampleValSum / this.sampleValCnt;
    const db = Math.max(Constants.MIN_DB, Math.min(0, 20 * Math.log10(rms)));
    this.sampleValCnt = 0;
    this.sampleValSum = 0;

    return Math.max(this.minHeight, (db + Math.abs(Constants.MIN_DB)) / Math.abs(Constants.MIN_DB) * this.maxHeight)
  }

  // 计算音频时长
  getDuration(): number {
    const BYTES_PER_SAMPLE = 2
    const SAMPLE_RATE = 16000
    const CHANNELS = 1
    const durationSec = this.bufferSize / (SAMPLE_RATE * CHANNELS * BYTES_PER_SAMPLE)
    return Math.floor(durationSec * 1000);
  }

  // 注册事件监听
  addEventListener(key: string, listener: (value: ESObject) => void) {
    if (!this.eventListener.get(key)) {
      this.eventListener.set(key, new Set());
    }
    this.eventListener.get(key)!.add(listener);
  }

}
