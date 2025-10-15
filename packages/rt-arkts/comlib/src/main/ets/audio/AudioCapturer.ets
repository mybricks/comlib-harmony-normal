import { audio } from '@kit.AudioKit';
import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { Constants } from './common/Constants';
import { PermissionUtil } from './common/utils/PermissionUtil';

interface AudioCapturerConstructorParams {
  uiContext: UIContext;
  minHeight: number;
  maxHeight: number;
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
        const filePath = path + `/${"helloworld"}.pcm`;
        const file: fileIo.File = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);

        const readDataCallback = (buffer: ArrayBuffer) => {
          this.eventListener.get('readData')?.forEach((listener) => {
            listener(buffer);
          });
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

        await this.audioCapturer.start();
      } else {
        await this.audioCapturer.start();
      }
    } else {
      // TODO:提示用户去应用授权
      console.log('未授权');
    }
  }

  // 停止录制
  async stop() {
    await this.audioCapturer!.stop();
  }

  // 销毁
  async destroy() {
    await this.stop();
    await this.audioCapturer!.release();
    fileIo.closeSync(this.file!.fd);
    this.file = undefined;
    this.eventListener = new Map();
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

    console.log(`Leon calculateDecibelHeight ${db} ${(db + Math.abs(Constants.MIN_DB)) / Math.abs(Constants.MIN_DB) * this.maxHeight}`)

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
}
