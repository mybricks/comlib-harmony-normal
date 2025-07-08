import { AnyType } from './types'
import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'

type ContentType = 'image' | 'custom'

export interface DataType {
  items?: AnyType,
  autoplay?: boolean,
  duration?: number,
  showIndicator?: boolean,
  contentType?: ContentType,
  circular?: boolean,
  indicatorColor?: string
}

interface DataSourceItem {
  _id: string;
  thumbnail: string;
}

@ObservedV2
export class Data implements DataType {
  @Trace items?: AnyType
  @Trace autoplay?: boolean
  @Trace duration?: number
  @Trace showIndicator?: boolean
  @Trace contentType?: ContentType
  @Trace circular?: boolean
  @Trace indicatorColor?: string


  constructor(config: DataType) {
    this.items = config.items
    this.autoplay = config.autoplay
    this.duration = config.duration
    this.showIndicator = config.showIndicator
    this.contentType = config.contentType
    this.circular = config.circular  //是否支持循环播放
    this.indicatorColor = config.indicatorColor
  }
}

interface Inputs {
  setItems: (fn: (array: AnyType) => void) => void
}

interface Outputs {
  onClick: (value: DataSourceItem) => void
}

export interface SlotsParams {
  id: string,
  key?: string
}

@Builder function emptySlot(params: SlotsParams) {}

@ComponentV2
export default struct MyBricksSwiper {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;

  @Local indicatorColor?: AnyType = '#558EFF'
  @Local indicatorColorDefault?: AnyType = '#D9D9D9'



  aboutToAppear(): void {
    this.inputs?.setItems((array:AnyType) => {
      this.data.items = array
    })

    //获取指示器选中颜色
    const indicatorColor = this.styles[".mybricks-swiper-wrapper .indicator.indicator-active"]
    this.indicatorColor = indicatorColor?.backgroundColor

    //获取指示器非选中颜色
    const indicatorColorDefault = this.styles[".mybricks-swiper-wrapper .indicator:not(.indicator-active)"]
    this.indicatorColorDefault = indicatorColorDefault?.backgroundColor
  }

  build() {
    Column() {
      Swiper() {
        ForEach(this.data.items, (item: DataSourceItem, index) => {
          if (this.data.contentType !== 'custom') {
            Image(item.thumbnail)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Cover)
              .onClick(()=>{
                this.outputs?.onClick(item)
              })
          } else {
            this.slots({
              id: `slot_${item._id}`,
              key: item._id,
            })
          }
        })
      }
      .height("100%")
      .autoPlay(this.data.autoplay)
      .duration(this.data.duration)
      .loop(this.data.circular)
      .indicator(
        Indicator.dot()
          .color(this.data.showIndicator ? this.indicatorColorDefault : Color.Transparent)
          .selectedColor(this.data.showIndicator ? this.indicatorColor : Color.Transparent)
      )
      .attributeModifier(
        new ApplyStyleModifier(this.styles['.mybricks-swiper-wrapper'])
      )
    }
    .width('100%')
    .height('100%')
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
