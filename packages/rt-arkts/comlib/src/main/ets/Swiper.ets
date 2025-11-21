import { AnyType } from './types'
import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'

type ContentType = 'image' | 'custom' | 'custom_dynamic'

export interface DataType {
  items?: AnyType,
  autoplay?: boolean,
  duration?: number,
  showIndicator?: boolean,
  contentType?: ContentType,
  circular?: boolean,
  vertical?: boolean,
  indicatorColor?: string
  itemOffsets?: Array<number | string>
  blurInactive?: boolean
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
  @Trace vertical?: boolean
  @Trace indicatorColor?: string
  @Trace itemOffsets?: Array<number | string>
  @Trace blurInactive?: boolean = false


  constructor(config: DataType) {
    this.items = config.items
    this.autoplay = config.autoplay
    this.duration = config.duration
    this.showIndicator = config.showIndicator
    this.contentType = config.contentType
    this.circular = config.circular  //是否支持循环播放
    this.vertical = config.vertical
    this.indicatorColor = config.indicatorColor
    this.itemOffsets = config.itemOffsets
    this.blurInactive = config.blurInactive
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
  inputValues?: AnyType
}

@Builder function emptySlot(params: SlotsParams) {}

interface InputTo {
  isInputing: boolean,
  toIndex: number
}

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
  @Local indicatorItemWidth?: number = 6
  @Local indicatorItemHeight?: number = 6
  @Local indicatorSelectItemWidth?: number = 6
  @Local indicatorSelectItemHeight?: number = 6

  @Local dataSource: AnyType[] = this.data.items || []
  @Monitor ('data.items')
  onDataItemsChange(monitor: IMonitor) {
    this.dataSource = monitor.value()?.now as AnyType[]
  }

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Local swiperWidth: number = 0
  /** 滑动中的Index，滑动中实时计算当前的高亮Index，onAnimationStart那里是松手后触发的，逻辑不一样 */
  @Local swiperIndex: number = 0;

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  private swiperController: SwiperController = new SwiperController()

  private isSwiping: boolean = false

  private inputTo: InputTo = {
    isInputing: false,
    toIndex: 0
  }

  @Computed
  get shouldScroll (): boolean {
    const styles = this.styles?.['.mybricks-swiper-wrapper'];
    return styles?.overflowY === 'scroll' || styles?.overflowY === 'auto' || styles?.overflowX === 'scroll' || styles?.overflowX === 'auto'
  }

  @Computed
  get shouldClip (): boolean {
    const styles = this.styles?.['.mybricks-swiper-wrapper'];
    return styles?.overflowY === 'hidden' || styles?.overflowX === 'hidden'
  }

  aboutToAppear(): void {
    this.inputs?.setItems((array:AnyType) => {
      if (Array.isArray(array)) {
        this.dataSource = array
      }
    })

    this.inputs?.activeIndex((index: AnyType) => {
      if (this.isSwiping) {
        return
      }

      if (this.swiperIndex === index) {
        return
      }

      this.inputTo = {
        isInputing: true,
        toIndex: index
      }
      this.swiperController.changeIndex(index, true)
      this.swiperIndex = index
    })

    //获取指示器选中颜色
    const indicatorStyle = this.styles[".mybricks-swiper-wrapper .indicator.indicator-active"]
    this.indicatorColor = indicatorStyle?.backgroundColor ? indicatorStyle?.backgroundColor :this.indicatorColor
    this.indicatorSelectItemWidth = indicatorStyle?.width ? parseFloat(indicatorStyle.width as string) :this.indicatorSelectItemWidth
    this.indicatorSelectItemHeight = indicatorStyle?.height ? parseFloat(indicatorStyle.height as string) :this.indicatorSelectItemHeight

    //获取指示器非选中颜色
    const indicatorDefaultStyle = this.styles[".mybricks-swiper-wrapper .indicator:not(.indicator-active)"]
    this.indicatorColorDefault = indicatorDefaultStyle?.backgroundColor
    this.indicatorItemWidth = indicatorDefaultStyle?.width ? parseFloat(indicatorDefaultStyle.width as string) :this.indicatorItemWidth
    this.indicatorItemHeight = indicatorDefaultStyle?.height ? parseFloat(indicatorDefaultStyle.height as string) :this.indicatorItemHeight
  }

  private onActive (index: number) {
    if (this.swiperIndex !== index) {
      this.swiperIndex = index
      this.outputs?.onChange?.(index)
    }
  }

  build() {
    Column() {
      Swiper(this.swiperController) {
        ForEach(this.dataSource, (item: DataSourceItem, index) => {
          if (this.data.contentType === 'image') {
            Image(item.thumbnail)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Cover)
              .onClick(()=>{
                this.outputs?.onClick(item)
              })
          } else {
            if (this.shouldScroll) {
              Scroll() {
                if (this.data.contentType === 'custom') {
                  this.slots({
                    id: `slot_${item._id}`,
                    key: item._id,
                  })
                } else {
                  this.slots({
                    id: 'slot_custom',
                    key: String(index),
                    inputValues: { itemData: item, index }
                  })
                }
              }
              .blur(this.data?.blurInactive ? (this.swiperIndex !== index ? 10 : 0) : 0)
              .opacity(this.data?.blurInactive ? (this.swiperIndex !== index ? 0.4 : 1) : 1)
            } else {
              Column() {
                if (this.data.contentType === 'custom') {
                  this.slots({
                    id: `slot_${item._id}`,
                    key: item._id,
                  })
                } else {
                  this.slots({
                    id: 'slot_custom',
                    key: String(index),
                    inputValues: { itemData: item, index }
                  })
                }
              }
              .blur(this.data?.blurInactive ? (this.swiperIndex !== index ? 10 : 0) : 0)
              .opacity(this.data?.blurInactive ? (this.swiperIndex !== index ? 0.4 : 1) : 1)
            }
          }
        })
      }
      .width("100%")
      .height("100%")
      .autoPlay(this.data.autoplay)
      .duration(this.data.duration)
      .loop(this.data.circular)
      .vertical(this.data.vertical)
      .prevMargin(this.data.itemOffsets?.[0] ?? 0)
      .nextMargin(this.data.itemOffsets?.[1] ?? 0)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.swiperWidth = newValue.width as number
      })
      .indicator(
        this.data.showIndicator
          ? Indicator.dot()
            .color(this.indicatorColorDefault)
            .selectedColor(this.indicatorColor)
            .itemWidth(this.indicatorItemWidth)
            .itemHeight(this.indicatorItemHeight)
            .selectedItemWidth(this.indicatorSelectItemWidth)
            .selectedItemHeight(this.indicatorSelectItemHeight)
          : false
      )
      .onAnimationStart((index, targetIndex) => {
        this.outputs?.onChangeConfirm?.(targetIndex)
      })
      .onAnimationEnd(() => {
      })
      .onTouch((evt) => {
        if (evt.type === TouchType.Move) {
          this.isSwiping = true
        }
        if (evt.type === TouchType.Up) {
          this.isSwiping = false
        }
      })
      .onChange((index) => {
        if (this.inputTo.isInputing && index === this.inputTo.toIndex) {
          this.inputTo.isInputing = false
        }
      })
      .customContentTransition({
        timeout: 1000,
        transition: (proxy: SwiperContentTransitionProxy) => {
          const hasNext = proxy.index < this.dataSource.length - 1;
          const hasPrev = proxy.index > 0;

          if (!this.inputTo.isInputing) { // 如果是输入触发的动画，不要再触发事件，防止循环
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
        }
      })
      .attributeModifier(
        new ApplyStyleModifier(this.styles['.mybricks-swiper-wrapper'])
      )
    }
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(this.modifier)
  }
}