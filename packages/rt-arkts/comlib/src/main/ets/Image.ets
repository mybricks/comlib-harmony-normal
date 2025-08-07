import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { url } from '@kit.ArkTS';

@Extend(Image) function aspectFit() {
  .objectFit(ImageFit.Contain)
}

@Extend(Image) function cover() {
  .objectFit(ImageFit.Cover)
  .overlay('Cover', { align: Alignment.Bottom, offset: { x: 0, y: 0 } })
}

export interface DataType {
  src?: string
  svgPolyfill?: string
  mode?: 'aspectFit' | 'cover' | string
  enableTransition?: boolean
}

interface _Env {
  currentScenes: _EnvCurrentScenes
}

interface Env {
  currentScenes: EnvCurrentScenes
}

interface _EnvCurrentScenes {
  close: () => void
}

interface EnvCurrentScenes {
  close: () => void
}

@ObservedV2
export class Data implements DataType {
  @Trace src?: string
  @Trace svgPolyfill?: string
  @Trace mode?: 'aspectFit' | 'cover' | string
  @Trace enableTransition?: boolean

  constructor(config: DataType) {
    this.src = config.src
    this.svgPolyfill = config.svgPolyfill
    this.mode = config.mode
    this.enableTransition = config.enableTransition ?? false
  }
}

interface Inputs {
  setSrc: (fn: (src: string) => void) => void
}

interface Outputs {
  onClick: (src: string | undefined) => void,
  onLoad?: (src: string) => void,
  onError?: (src: string) => void
}

@ComponentV2
export default struct MyBricksImage {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Local _opacity: number = 1
  private preloadImage: ImageBitmap = new ImageBitmap('')
  private animationDuration: number = 150
  private currentSrc: string = ''
  private isInitialized: boolean = false // 修改：使用isInitialized替代isFirstLoad

  aboutToAppear(): void {
    this.currentSrc = this.data.src || ''
    // 在组件初始化时就设置 isInitialized 为 true
    this.isInitialized = true

    this.inputs?.setSrc((src) => {

        if (!this.data.enableTransition) {
          // 禁用动画时直接设置图片源
          this.data.src = src
          this.currentSrc = src
        } else {
          // 启用动画时执行渐变动画
          this.startTransition(src)
        }

    })
  }

  private startTransition(newSrc: string) {
    if (!this.data.enableTransition) {
      this.data.src = newSrc
      this.currentSrc = newSrc
      return
    }

    animateTo({
      duration: this.animationDuration,
      curve: Curve.EaseInOut,
      onFinish: () => {
        this.data.src = newSrc
        this.currentSrc = newSrc
        animateTo({
          duration: this.animationDuration,
          curve: Curve.EaseInOut,
        }, () => {
          this._opacity = 1
        })
      }
    }, () => {
      this._opacity = 0
    })
  }

  @Computed
  get imageObjectFit (): ImageFit {
    switch (this.data.mode) {
      case 'aspectFill': {
        return ImageFit.Cover
      }
      case 'objectFit': {
        return ImageFit.ScaleDown
      }
      case 'aspectFit': {
        return ImageFit.Contain
      }
      case 'scaleToFill': {
        return ImageFit.Fill
      }
      default: {
        return ImageFit.Auto
      }
      case 'widthFix': {
        // TOOD，这个配置应该要被删除
        return ImageFit.Auto
      }
    }
  }

  @Computed
  get encodedSrc(): string {
    const originUrl = this.data.svgPolyfill || this.data.src
    try {
      const urlObj = url.URL.parseURL(originUrl || '');
      const params = new url.URLParams(urlObj.params);
      // 对参数进行编码处理
      const encodedParams = Array.from(params.entries())
        .map((kv) => `${encodeURIComponent(kv[0])}=${encodeURIComponent(kv[1])}`)
        .join('&');

      return `${urlObj.origin}${urlObj.pathname}?${encodedParams}`;
    } catch {
      // 无效URL时返回原始值
      return originUrl || '';
    }
  }

  build() {
    Column() {
      Image(this.encodedSrc)
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-image'])
        )
        .width('100%')
        .height('100%')
        .opacity(this.data.enableTransition ? this._opacity : 1)
        .onFinish(() => {
          if (this.isInitialized && this._opacity === 0 && this.data.enableTransition) {
            // 组件已初始化且启用动画时执行淡入动画
            animateTo({
              duration: this.animationDuration,
              curve: Curve.EaseInOut
            }, () => {
              this._opacity = 1
            })
          }
          this.outputs?.onLoad?.(this.data.src || '')
        })
        .onError(() => {
          this.outputs?.onError?.('error')
        })
        .objectFit(this.imageObjectFit)
    }.onClick(() => {
      this.outputs?.onClick(this.data.src)
    })
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}