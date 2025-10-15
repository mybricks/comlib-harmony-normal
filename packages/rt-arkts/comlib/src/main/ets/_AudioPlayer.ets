import media from '@ohos.multimedia.media'
import { BusinessError } from '@kit.BasicServicesKit'

import { AnyType } from './types'



class AudioPlayer {
  avPlayer?: media.AVPlayer;

  private waitingToPlay = false
  private loopPlay = false

  constructor() {
    this.init();
  }

  // 初始化播放器
  async init() {
    return new Promise<void>((resolve) => {
      if (!this.avPlayer) {
        media.createAVPlayer().then((player) => {
          this.avPlayer = player;
          this.initEvents();

        }).catch((err:BusinessError) => {
        }).finally(() => {
          resolve()
        });
      } else {
        resolve()
      }
    })
  }

  initEvents = () => {
    if (!this.avPlayer) {
      return
    }
    this.avPlayer.on('stateChange', async (state, reason) => {
      switch (state) {
        case 'idle':
          // 初始状态。当 avPlayer 实例刚创建或调用 reset() 后进入此状态，此时尚未进行任何初始化操作。
          break;
        case 'initialized':
          // 初始化完成状态。调用 init() 方法并传入媒体源（如 URL 或文件路径）后，播放器完成基础初始化，准备进入预处理阶段。
          this.avPlayer?.prepare()
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
          if (this.loopPlay) {
            this.avPlayer?.play()
            this.avPlayer?.seek(0)
          } else {
          }
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
    })
  }


  play = async (url?: string) => {
    if (!this.avPlayer) {
      return
    }

    await this.avPlayer?.stop();
    await this.avPlayer?.reset();

    if (url) {
      this.avPlayer.url = url
    } else {
      await this.avPlayer?.play()
    }
  }

  pause = async () => {
    this.avPlayer?.pause()
  }

  destroy = async () => {
    await this.avPlayer?.stop();
    await this.avPlayer?.reset();
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
    audioPlayer.avPlayer?.on('stateChange', (state) => {
      if (state === "playing" && data.type === 'onPlay') {
        outputs?.then()
      } else if (state === "paused" && data.type === 'onPause') {
        outputs?.then()
      }
    })

    if (data.type === 'onPlayPosition') {
      audioPlayer.avPlayer?.on('timeUpdate', (time: number) => {
        const currentTime = time / 1000
        outputs?.then(currentTime)
      })
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
        case data.type === 'destroy': {
          await audioPlayer.destroy();
          outputs?.then()
          return
        }
      }
    })
  }
}