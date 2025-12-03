import { util, buffer } from '@kit.ArkTS';
import { audio } from '@kit.AudioKit';
import { common } from '@kit.AbilityKit';
import { fileIo, ReadOptions } from '@kit.CoreFileKit';
import { Constants } from './common/Constants';
import { PermissionUtil } from './common/utils/PermissionUtil';
import { BusinessError } from '@kit.BasicServicesKit';

interface AudioCapturerConstructorParams {
  uiContext: UIContext;
  minHeight: number;
  maxHeight: number;
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

export class AudioCapturer {
  private audioCapturer?: audio.AudioCapturer;
  private uiContext?: UIContext;
  // 当前已写入文件的音频数据总字节数
  private bufferSize: number = 0;
  // 统计样本数量，确保计算的平均值准确
  private sampleValCnt: number = 0;
  // 累积样本能量的平方和，用于音量强度计算
  private sampleValSum: number = 0;
  // 最小高度
  private minHeight: number = 0;
  // 最大高度
  private maxHeight: number = 0;
  // 录制存储文件
  private file?: fileIo.File;
  // 事件监听
  private eventListener: Map<string, Set<(value: ESObject) => void>> = new Map();

  constructor(params: AudioCapturerConstructorParams) {
    this.uiContext = params.uiContext;
    this.minHeight = params.minHeight;
    this.maxHeight = params.maxHeight;
  }

  private getBytesPerSample(format: audio.AudioSampleFormat): number {
    switch (format) {
      case audio.AudioSampleFormat.SAMPLE_FORMAT_U8: return 1;
      case audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE: return 2;
      case audio.AudioSampleFormat.SAMPLE_FORMAT_S24LE: return 3;
      case audio.AudioSampleFormat.SAMPLE_FORMAT_S32LE:
      case audio.AudioSampleFormat.SAMPLE_FORMAT_F32LE: return 4;
      default: return 2;
    }
  }

  // 开始录制
  async start() {
    const uiAbilityContext = this.uiContext!.getHostContext() as common.UIAbilityContext;

    if (await PermissionUtil.requestPermissionsFromUser(Constants.MICROPHONE_PERMISSION, uiAbilityContext)) {
      if (!this.audioCapturer) {
        this.audioCapturer = await audio.createAudioCapturer({
          streamInfo: {
            samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
            channels: audio.AudioChannel.CHANNEL_1,
            sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
            encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
          },
          capturerInfo: {
            source: audio.SourceType.SOURCE_TYPE_MIC,
            capturerFlags: 0
          }
        });

        class Options {
          offset?: number;
          length?: number;
        }

        const hostContext = this.uiContext!.getHostContext();
        const path = hostContext!.cacheDir;
        const filePath = path + `/${util.generateRandomUUID()}.pcm`;
        const file: fileIo.File = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);

        this.file = file;

        let buffers: ArrayBuffer[] = [];

        const readDataCallback = (buffer: ArrayBuffer) => {
          buffers.push(buffer)
          if (buffers.length === 2) {
            this.eventListener.get('readData')?.forEach((listener) => {
              listener(concatBuffers(buffers));
            });
            buffers = []
          }

          let options: Options = {
            offset: this.bufferSize,
            length: buffer.byteLength
          };
          fileIo.writeSync(file.fd, buffer, options);
          this.bufferSize += buffer.byteLength;

          let samples = new Int16Array(buffer);
          for (let i = 0; i < samples.length; i++) {
            let val = samples[i] / Constants.VOLUME_MAX;
            this.sampleValSum += val * val;
            this.sampleValCnt += 1;
          }
        };

        this.audioCapturer.on('readData', readDataCallback);

        this.audioCapturer.on('stateChange', (state) => {
          this.eventListener.get('stateChange')?.forEach((listener) => {
            listener(state);
          });
        });

        await this.audioCapturer.start()
        return true
      } else {
        await this.audioCapturer.start()
        return true
      }
    } else {
      // TODO:提示用户去应用授权
      console.log('未授权');
      return false
    }
  }

  // 停止录制
  async stop() {
    try {
      let res = await this.audioCapturer!.stop();
    } catch (e) {
      console.log("e",e)
    }
  }

  // 销毁
  async destroy() {
    if (this.audioCapturer) {
      await this.stop();
      await this.audioCapturer!.release();
      const arrayBuffer = new ArrayBuffer(this.bufferSize);
      const readOptions: ReadOptions = {
        offset: 0,
        length: arrayBuffer.byteLength
      };
      const readLen = fileIo.readSync(this.file!.fd, arrayBuffer, readOptions);
      const buf = buffer.from(arrayBuffer, 0, readLen);
      this.audioCapturer = undefined;
      fileIo.closeSync(this.file!.fd);
      this.file = undefined;
      this.eventListener = new Map();
      this.sampleValCnt = 0;
      this.sampleValSum = 0;
      this.bufferSize = 0;
      return buf;
    }
    return undefined;
  }

  // 重置
  async reset() {
    if (this.audioCapturer) {
      await this.stop();
      const arrayBuffer = new ArrayBuffer(this.bufferSize);
      const readOptions: ReadOptions = {
        offset: 0,
        length: arrayBuffer.byteLength
      };
      const readLen = fileIo.readSync(this.file!.fd, arrayBuffer, readOptions);
      const buf = buffer.from(arrayBuffer, 0, readLen);
      this.audioCapturer = undefined;
      fileIo.closeSync(this.file!.fd);
      this.file = undefined;
      this.sampleValCnt = 0;
      this.sampleValSum = 0;
      this.bufferSize = 0;
      return buf;
    }
    return undefined;
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

  // 注册事件监听
  addEventListener(key: string, listener: (value: ESObject) => void) {
    if (!this.eventListener.get(key)) {
      this.eventListener.set(key, new Set());
    }
    this.eventListener.get(key)!.add(listener);
  }

  // 取消事件监听
  removeEventListener(key: string, listener: (value: ESObject) => void) {
    this.eventListener.get(key)?.delete(listener);
  }

  // 计算音频时长
  async getDuration(): Promise<number> {
    const audioParamsGet = this.audioCapturer?.getStreamInfoSync()
    if (!audioParamsGet) return 0;

    const bytesPerSample = this.getBytesPerSample(audioParamsGet.sampleFormat);
    const duration = this.bufferSize / (
      audioParamsGet.samplingRate *
      audioParamsGet.channels *
        bytesPerSample
    ) * 1000;

    return Math.floor(duration);
  }
}
