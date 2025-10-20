import media from '@ohos.multimedia.media'

import { AnyType } from './types'

class AudioPlayer {
  // 播放器实例
  avPlayer?: media.AVPlayer;
  // 是否等待播放，如果是在资源加载完成后直接播放
  private waitingToPlay?: boolean;
  // 监听
  private eventListener: Map<string, Set<(value: ESObject) => void>> = new Map();

  constructor() {
    this.init();
  }

  // 初始化
  private async init() {
    this.avPlayer = await media.createAVPlayer();
    this.setAVPlayerCallback();
  }

  // 设置AVPlayer回调
  private setAVPlayerCallback() {
    this.avPlayer!.on('stateChange', (state) => {
      switch (state) {
        case 'idle':
          // 初始状态。当 avPlayer 实例刚创建或调用 reset() 后进入此状态，此时尚未进行任何初始化操作。
          break;
        case 'initialized':
          // 初始化完成状态。调用 init() 方法并传入媒体源（如 URL 或文件路径）后，播放器完成基础初始化，准备进入预处理阶段。
          this.avPlayer!.prepare();
          break;
        case 'prepared':
          // 预处理完成状态。播放器已完成媒体资源的加载、解析（如获取时长、分辨率等元数据），可以随时调用 play() 开始播放。
          if (this.waitingToPlay) {
            this.avPlayer?.play()
          }
          break;
        case 'playing':
          // 播放中状态。调用 play() 后进入此状态，媒体正在正常播放。
          break;
        case 'paused':
          // 暂停状态。调用 pause() 后进入此状态，媒体播放暂停，可通过 play() 恢复播放。
          break;
        case 'completed':
          // 播放完成状态。媒体文件播放到末尾时自动进入此状态，此时可调用 play() 重新播放，或调用 stop() 停止。
          break;
        case 'stopped':
          // 停止状态。调用 stop() 后进入此状态，播放器停止播放并释放部分资源，但仍保留初始化信息，可重新调用 prepare() 再次准备播放。
          break;
        case 'released':
          // 资源释放状态。调用 release() 后进入此状态，播放器释放所有占用的资源（如内存、解码器等），实例不再可用，需重新创建才能使用。
          break;
        case 'error':
          // 错误状态。当播放器在操作过程中发生错误（如网络异常、格式不支持等）时进入此状态，可通过相关接口获取错误详情。
          break
        default:
          break;
      }
      this.runEventListener("stateChange", state);
    })

    this.avPlayer!.on('timeUpdate', (time) => {
      this.runEventListener("timeUpdate", time);
    })
  }

  // 注册监听
  addEventListener(key: string, listener: (value: ESObject) => void) {
    if (!this.eventListener.get(key)) {
      this.eventListener.set(key, new Set());
    }

    this.eventListener.get(key)!.add(listener);
  }

  // 执行监听
  private runEventListener(key: string, value: ESObject) {
    this.eventListener.get(key)?.forEach((listener) => {
      listener(value)
    })
  }

  // 播放歌曲
  async play(resourceUrl?: string) {
    if (resourceUrl) {
      // 切换歌曲
      await this.stopAndReset();

      this.waitingToPlay = true;
      this.avPlayer!.url = resourceUrl;
      return;
    }

    if (['prepared', 'paused', 'completed'].includes(this.avPlayer!.state)) {
      this.avPlayer!.play();
    } else {
      this.waitingToPlay = true;
    }
  }

  // 暂停
  async pause() {
    if (this.avPlayer!.state === 'playing') {
      await this.avPlayer!.pause();
    }
  }

  // 销毁（目前不需要销毁，不调用release）
  async destroy() {
    await this.stopAndReset();
    // 重置
    this.eventListener = new Map();
    this.waitingToPlay = false;
  }

  // 目前不需要销毁，不调用
  private async stopAndReset() {
    if (['prepared', 'playing', 'paused', 'completed'].includes(this.avPlayer!.state)) {
      await this.avPlayer!.stop();
    }
    if (['initialized', 'playing', 'paused', 'completed', 'stopped', 'error'].includes(this.avPlayer!.state)) {
      await this.avPlayer!.reset();
    }
  }
}

const audioPlayer = new AudioPlayer()

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  @Trace type: string
  @Trace immediate: boolean

  constructor(config?: DataType) {
    this.immediate = config?.immediate ?? false
    this.type = config?.type
  }
}

interface Inputs {
  call?: (fn: (number: DataType, relOutputs?: AnyType) => void) => void
}

interface Outputs {
  then: (value?: AnyType) => void
}

interface IOContext {
  data: DataType
  inputs: Inputs
  outputs: Outputs
}

export default (context: IOContext) => {
  const data: Data = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs


  if (data.immediate) {
    audioPlayer.addEventListener('stateChange', (state: media.AVPlayerState) => {
      if (state === 'playing' && data.type === 'onPlay') {
        outputs?.then();
      } else if (state === 'paused' && data.type === 'onPause') {
        outputs?.then();
      }
    });

    if (data.type === 'onPlayPosition') {
      audioPlayer.addEventListener('timeUpdate', (time: number) => {
        outputs?.then(time / 1000);
      });
    }
  } else {
    inputs.call?.(async (val: AnyType) => {
      switch (true) {
        case data.type === 'play': {
          if (typeof val === 'string') {
            await audioPlayer.play(val);
            outputs?.then()
          } else {
            await audioPlayer.play();
            outputs?.then()
          }
          return
        }
        case data.type === 'pause': {
          await audioPlayer.pause();
          outputs?.then()
          return
        }
        case data.type === 'seek': {
          await audioPlayer.seek(val);
          return
        }
        case data.type === 'destroy': {
          await audioPlayer.destroy();
          outputs?.then()
          return
        }
      }
    })
  }
}