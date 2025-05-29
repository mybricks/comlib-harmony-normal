import { AnyType } from './types'
import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'


export interface DataType {
  src?: string  //视频源地址
  controls?: boolean //是否显示视频控件
  poster?: string //视频封面图片
  autoplay?: boolean //是否自动播放
  loop?: boolean //是否循环播放
  muted?: boolean //是否静音播放
  objectFit?: VideoFitType
}

export type VideoFitType = 'contain' | 'fill' | 'cover' | string;



@ObservedV2
export class Data implements DataType {
  @Trace src?: string
  @Trace controls?: boolean | undefined
  @Trace poster?: string | undefined
  @Trace autoplay?: boolean | undefined
  @Trace loop?: boolean | undefined
  @Trace muted?: boolean | undefined
  @Trace objectFit?: 'contain' | 'fill' | 'cover' | string | undefined

  constructor(config: DataType) {
    this.src = config.src
    this.controls = config.controls
    this.poster = config.poster
    this.autoplay = config.autoplay
    this.loop = config.loop
    this.muted = config.muted
    this.objectFit = config.objectFit
  }
}


interface Inputs {
  setSrc: (fn: (src: string) => void) => void
}

interface Outputs {
  onPlay: (src: string | undefined) => void,
  onPause: (src: string | undefined) => void,
  onEnded: (src: string | undefined) => void,
  onTimeUpdate: (src: string | undefined) => void,
  onWaiting: (src: string | undefined) => void,
  onError: (src: string | undefined) => void
}



@ComponentV2
export default struct MyBricksVideo {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

  private getImageFit(e:VideoFitType): ImageFit {
    switch(e) {
      case 'contain':
        return ImageFit.Contain
      case 'cover':
        return ImageFit.Cover
      case 'fill':
        return ImageFit.Fill
      default:
        return ImageFit.Auto
    }
  }

  aboutToAppear(): void {
    this.inputs?.setSrc((src) => {
      this.data.src = src;
    })
  }

  build() {
    Column() {
      Video({
        src: this.data.src,
        previewUri: this.data.poster,
      })
        .controls(this.data.controls || true) // 设置是否显示默认控制条
        .autoPlay(this.data.autoplay || true)
        .loop(this.data.loop || true)
        .muted(this.data.muted || false)
        .objectFit(this.getImageFit(this.data.objectFit || 'contain'))
        .onStart(()=>{
          this.outputs?.onPlay(this.data.src)
        })
        .onPause(()=>{
          this.outputs?.onPause(this.data.src)
        })
        .onFinish(()=>{
          this.outputs?.onEnded(this.data.src)
        })
        .onUpdate(()=>{
          this.outputs?.onTimeUpdate(this.data.src)
        })
        .onError(()=>{
          this.outputs?.onError(this.data.src)
        })
    }
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
