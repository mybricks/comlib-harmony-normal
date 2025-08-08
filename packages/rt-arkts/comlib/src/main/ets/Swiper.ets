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
  itemOffsets?: Array<number | string>
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
  @Trace itemOffsets?: Array<number | string>


  constructor(config: DataType) {
    this.items = config.items
    this.autoplay = config.autoplay
    this.duration = config.duration
    this.showIndicator = config.showIndicator
    this.contentType = config.contentType
    this.circular = config.circular  //是否支持循环播放
    this.indicatorColor = config.indicatorColor
    this.itemOffsets = config.itemOffsets
  }
}

interface Inputs {
  setItems: (fn: (array: AnyType) => void) => void
  activeIndex: (fn: (index: AnyType) => void) => void
}

interface Outputs {
  onClick: (value: DataSourceItem) => void
  /** 滑动时切换 */
  onChange: (index: number) => void
  /** 滑动松手时切换 */
  onChangeConfirm: (index: number) => void
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

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Local swiperWidth: number = 0
  /** 滑动中的Index，滑动中实时计算当前的高亮Index，onAnimationStart那里是松手后触发的，逻辑不一样 */
  @Local swiperIndex: number = 0;

  private swiperController: SwiperController = new SwiperController()

  aboutToAppear(): void {
    this.inputs?.setItems((array:AnyType) => {
      this.data.items = array
    })

    this.inputs?.activeIndex((index: AnyType) => {
      this.swiperController.changeIndex(index, true)
    })

    //获取指示器选中颜色
    const indicatorColor = this.styles[".mybricks-swiper-wrapper .indicator.indicator-active"]
    this.indicatorColor = indicatorColor?.backgroundColor

    //获取指示器非选中颜色
    const indicatorColorDefault = this.styles[".mybricks-swiper-wrapper .indicator:not(.indicator-active)"]
    this.indicatorColorDefault = indicatorColorDefault?.backgroundColor
  }

  private onActive (index: number) {
    this.swiperIndex = index
    this.outputs?.onChange?.(index)
  }

  build() {
    Column() {
      Swiper(this.swiperController) {
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
      .prevMargin(this.data.itemOffsets?.[0] ?? 0)
      .nextMargin(this.data.itemOffsets?.[1] ?? 0)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.swiperWidth = newValue.width as number
      })
      .indicator(
        Indicator.dot()
          .color(this.data.showIndicator ? this.indicatorColorDefault : Color.Transparent)
          .selectedColor(this.data.showIndicator ? this.indicatorColor : Color.Transparent)
      )
      .onAnimationStart((index, targetIndex) => {
        this.outputs?.onChangeConfirm?.(targetIndex)
      })
      .customContentTransition({
        timeout: 1000,
        transition: (proxy: SwiperContentTransitionProxy) => {
          const hasNext = proxy.index < this.data.items.length - 1;
          const hasPrev = proxy.index > 0;

          // 只提取高亮的index的信息
          if (proxy.index === proxy.selectedIndex) {
            if (hasNext && proxy.position <= -0.5) {
              this.onActive(proxy.index + 1)
            } else if (hasPrev && proxy.position >= 0.5) {
              this.onActive(proxy.index - 1)
            } else {
              this.onActive(proxy.index)
            }
          }
        }
      })
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
