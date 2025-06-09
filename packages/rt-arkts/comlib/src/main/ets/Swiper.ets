import { AnyType } from './types'
import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'

type ContentType = 'image' | 'custom'

export interface DataType {
  items?: AnyType,
  autoplay?: boolean,
  duration?: number,
  showIndicator?: boolean,
  contentType?: ContentType,
  circular?: boolean
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


  constructor(config: DataType) {
    this.items = config.items
    this.autoplay = config.autoplay
    this.duration = config.duration
    this.showIndicator = config.showIndicator
    this.contentType = config.contentType
    this.circular = config.circular  //是否支持循环播放
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

  aboutToAppear(): void {
    this.inputs?.setItems((array:AnyType) => {
      this.data.items = array
    })
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
