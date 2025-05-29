import { AnyType } from './types'
import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'

export interface DataType {
  item?: AnyType,
  autoplay?: boolean,
  duration?: number,
  showIndicator?: boolean,
  circular?: boolean
}

interface DataSourceItem {
  _id: string;
  thumbnail: string;
}

@ObservedV2
export class Data implements DataType {
  @Trace item?: AnyType
  @Trace autoplay?: boolean
  @Trace duration?: number
  @Trace showIndicator?: boolean
  @Trace circular?: boolean


  constructor(config: DataType) {
    this.item = config.item
    this.autoplay = config.autoplay
    this.duration = config.duration
    this.showIndicator = config.showIndicator
    this.circular = config.circular  //是否支持循环播放
  }
}

interface Inputs {
  setItems: (fn: (array: AnyType) => void) => void
}

interface Outputs {
  onClick: (value: DataSourceItem) => void
}

@ComponentV2
export default struct MyBricksSwiper {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

  aboutToAppear(): void {
    this.inputs?.setItems((array:AnyType) => {
      this.data.item = array
    })
  }

  build() {
    Column() {
      Swiper() {
        ForEach(this.data.item, (item: DataSourceItem, index) => {
          Image(item.thumbnail)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
            .onClick(()=>{
              this.outputs?.onClick(item)
            })
        })
      }
      .autoPlay(this.data.autoplay)
      .duration(this.data.duration)
      .loop(this.data.circular)
      .indicator(
        Indicator.dot()
          .color(this.data.showIndicator ? Color.Gray : Color.Transparent)
          .selectedColor(this.data.showIndicator ? Color.Blue : Color.Transparent)
      )
    }
    .width('100%')
    .height('100%')
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-swiper-wrapper'])
    )
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
