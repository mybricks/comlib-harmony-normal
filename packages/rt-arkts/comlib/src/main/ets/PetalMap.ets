import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  src?: string
  svgPolyfill?: string
  mode?: 'aspectFit' | 'cover' | string
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
  @Local imgHolder?: string = 'https://assets.mybricks.world/y53nJ4RaO3nygVwUT9AP2tJp8MOgOMoH-1750341422504.jpg'

  aboutToAppear(): void {
    this.inputs?.setSrc((src) => {
      this.data.src = src;
    })
  }


  build() {
    Column() {
      Image(this.imgHolder)
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-map'])
        )
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

    }
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
