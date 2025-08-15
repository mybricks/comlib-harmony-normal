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

  constructor(config: DataType) {
    this.src = config.src
    this.svgPolyfill = config.svgPolyfill
    this.mode = config.mode
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

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  aboutToAppear(): void {

    this.inputs?.setSrc((src) => {
          this.data.src = src
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
        .onFinish(() => {
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
    .attributeModifier(this.modifier)
  }
}