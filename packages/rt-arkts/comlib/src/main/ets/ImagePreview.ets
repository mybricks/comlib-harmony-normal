import { clamp, getComponentsInfo } from './utils/imagePreview'
import { ApplyRootStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  items?: ListItemType[]
  /**
   * 遮罩背景色
   */
  maskColor?: ResourceColor
  /**
   * 指定初始显示的图片索引
   */
  current?: number
  /**
   * 动画时长
   */
  swipeDuration?: number
  /**
   * 是否循环
   */
  loop?: boolean
  /**
   * 是否启用双击缩放手势，禁用后，点击时会立即关闭图片预览
   */
  doubleScale?: boolean
  /**
   * 最大缩放比例
   */
  maxScale?: number
  /**
   * 最小缩放比例
   */
  minScale?: number
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

interface Inputs {
  setItems: (fn: (array: AnyType) => void) => void
  activeIndex: (fn: (index: AnyType) => void) => void
}

interface Outputs {
  onClick: (index: number) => void
  onChange: (index: number) => void
}

interface ListItemType {
  thumbnail: PreviewImgType
}

type PreviewImgType  = PixelMap | ResourceStr | DrawableDescriptor

interface CenterLocation {
  x: number;
  y: number;
}

interface ScaleImageInfo {
  width: number
  height: number
  localLeft: number
  localTop: number
}

/**
 * 对齐方式
 */
export enum PreviewVerticalAlign {
  Top = 'top',
  Bottom = 'bottom',
}

@ObservedV2
export class Data implements DataType {
  @Trace items: ListItemType[] = []
  @Trace maskColor?: ResourceColor = '#000000'
  @Trace current?: number = 0
  @Trace swipeDuration?: number = 200
  @Trace loop?: boolean = true
  @Trace doubleScale?: boolean = true
  @Trace maxScale?: number = 3
  @Trace minScale?: number = 1

  constructor(config: DataType) {
    this.items = config?.items || []
    this.maskColor = config?.maskColor || '#000000'
    this.current = config?.current || 0
    this.swipeDuration = config?.swipeDuration || 200
    this.loop = config?.loop !== undefined ? config.loop : true
    this.doubleScale = config?.doubleScale !== undefined ? config.doubleScale : true
    this.maxScale = config?.maxScale || 3
    this.minScale = config?.minScale || 1
  }
}

@ComponentV2
struct SwiperItem {
  @Param @Require params: DataType = new Data({})
  @Param outputs?: Outputs = undefined;
  @Require @Param url: PreviewImgType
  @Require @Param index: number
  @Require @Param active: number
  @Require @Param isDisabledSwiper: boolean
  @Local rootWidth: number = 0
  @Local rootHeight: number = 0
  @Local imgWidth: number = 0
  @Local imgHeight: number = 0
  @Local curScale: number = 1
  @Local pinchValue: number = 1
  @Local offsetX: number = 0
  @Local offsetY: number = 0
  @Local startX: number = 0
  @Local startY: number = 0
  @Local curX: number = 0
  @Local curY: number = 0
  @Local offsetMaxX: number = 0
  @Local offsetMaxY: number = 0
  @Local imageRatio: number = 0
  @Local isLongImage: boolean = false
  @Local imgDraggable: boolean = true
  @Local isMoving: boolean = false
  private isImageMoved: boolean = false
  private isFingerMove: boolean = false
  private longImageRatio: number = 2.6
  private lastCenter: CenterLocation = { x: 0, y: 0 }
  @Event onDisabledSwiper: (isDisabled: boolean) => void = () => {
  }

  @Monitor('isMoving')
  moveChange() {
    console.log('isMoving')
  }

  // 初始化
  init(width: number, height: number) {
    let comInfo = getComponentsInfo(this.getUIContext(), 'PreviewImgContent')
    let rootRatio = comInfo.height / comInfo.width
    this.imgWidth = px2vp(width)
    this.imgHeight = px2vp(height)
    this.imageRatio = height / width
    this.rootWidth = this.imgWidth
    this.rootHeight = this.imgHeight

    this.isLongImage = this.imageRatio > rootRatio && this.imageRatio >= this.longImageRatio

    this.setParams(1)
  }

  getCenter(fingers: FingerInfo[]): CenterLocation {
    return {
      x: (fingers[0].localX + fingers[1].localX) / 2,
      y: (fingers[0].localY + fingers[1].localY) / 2,
    }
  }

  getMaxMoveX() {
    if (this.imageRatio) {
      const displayWidth = this.isLongImage ? this.imgWidth : this.rootWidth
      return Math.max(0, (this.curScale * displayWidth - this.rootWidth) / 2)
    }
    return 0
  }

  getMaxMoveY() {
    if (this.imageRatio) {
      const displayHeight = this.isLongImage ? this.rootHeight : this.imgHeight
      return Math.max(0, (this.curScale * displayHeight - this.rootHeight) / 2)
    }
    return 0
  }

  // 获取缩放后图片信息
  getScaleImageInfo(): ScaleImageInfo {
    let scaleWidth = this.imgWidth * this.curScale
    let scaleHeight = this.imgHeight * this.curScale
    return {
      width: scaleWidth,
      height: scaleHeight,
      localLeft: (this.rootWidth - scaleWidth) / 2,
      localTop: (this.rootHeight - scaleHeight) / 2,
    }
  }

  // 单击
  singleClick(index: number) {
    if (!this.isFingerMove) {
      this.outputs?.onClick(index)
    }
  }

  // 双击
  doubleClick(fingers: FingerInfo[]) {
    if (!this.isFingerMove) {
      if (this.params.doubleScale) {
        let scale = this.curScale === 1 ? 2 : 1
        this.setParams(scale,
          scale === 2 || this.isLongImage ? { x: fingers[0].localX, y: fingers[0].localY } : undefined)
      }
    }
  }

  // 手指移动
  onFingerMove(event: TouchEvent) {
    switch (event.type) {
      case TouchType.Down:
        this.isMoving = this.curScale !== 1 || this.isLongImage
        this.startX = event.touches[0].x
        this.startY = event.touches[0].y
        this.curX = this.offsetX
        this.curY = this.offsetY
        this.isImageMoved = false
        this.isFingerMove = false
        break
      case TouchType.Move:
        let x = event.touches[0].x - this.startX
        let y = event.touches[0].y - this.startY
        this.isFingerMove = x !== 0 || y !== 0
        let offsetX = this.curX + x
        let offsetY = this.curY + y
        let isDisabled = Math.abs(offsetX) <= this.offsetMaxX
        this.onDisabledSwiper(isDisabled)
        if (this.isMoving) {
          if (Math.abs(offsetX) > this.offsetMaxX && !this.isImageMoved) {
            this.isMoving = false
            return
          }
          this.isImageMoved = true
          this.offsetX = clamp(offsetX, -this.offsetMaxX, this.offsetMaxX)
          this.offsetY = clamp(offsetY, -this.offsetMaxY, this.offsetMaxY)
        }
        break
      case TouchType.Up:
        this.isMoving = false
        break
    }
  }

  // 设置参数
  setParams(scale: number, lastCenter?: CenterLocation) {
    scale = clamp(scale, +(this.params.minScale as number), +(this.params.maxScale as number) + 1)
    if (scale !== this.curScale) {
      const ratio = scale / this.curScale
      this.curScale = scale
      this.offsetMaxX = this.getMaxMoveX()
      this.offsetMaxY = this.getMaxMoveY()
      if (lastCenter) {
        const imgInfo = this.getScaleImageInfo()
        const moveX = this.offsetX - (lastCenter.x - imgInfo.localLeft - imgInfo.width / 2) * (ratio - 1)
        const moveY = this.offsetY - (lastCenter.y - imgInfo.localTop - imgInfo.height / 2) * (ratio - 1)

        this.offsetX = clamp(moveX, -this.offsetMaxX, this.offsetMaxX)
        this.offsetY = clamp(moveY, -this.offsetMaxY, this.offsetMaxY)
      } else {
        this.offsetX = 0
        this.offsetY = 0
      }
    }
  }

  // 重置
  @Monitor('active')
  reset() {
    this.setParams(1)
  }

  build() {
    Row() {
      Image(this.url)
        .width(this.isLongImage ? '' : '100%')
        .height(this.isLongImage ? '100%' : '')
        .objectFit(ImageFit.Contain)
        .scale({ x: this.curScale, y: this.curScale, z: 1 })
        .translate({ x: this.offsetX, y: this.offsetY, z: 0 })
        .draggable(this.imgDraggable)
        .animation({
          duration: 100,
        })
        .onComplete((event) => {
          if (event) {
            this.init(event.contentWidth, event.contentHeight)
          }
        })
    }
    .justifyContent(FlexAlign.Center)
    .id('PreviewImgContent')
    .onTouch((event) => {
      this.onFingerMove(event)
    })
    .parallelGesture(
      GestureGroup(GestureMode.Exclusive,
        // 双击
        TapGesture({ fingers: 1, count: 2 }).onAction((event) => {
          this.doubleClick(event.fingerList)
        }),
        // 单击
        TapGesture({ fingers: 1, count: 1 }).onAction(() => {
          this.singleClick(this.active)
        }),
        // 缩放
        PinchGesture({ fingers: 2 })
          .onActionStart(() => {
            this.pinchValue = this.curScale
          })
          .onActionUpdate((event: GestureEvent) => {
            let scale = Number((this.pinchValue * event.scale).toFixed(1))
            let lastCenter = this.getCenter(event.fingerList)
            this.lastCenter = lastCenter
            this.isMoving = false
            this.onDisabledSwiper(true)
            this.setParams(scale, lastCenter)
          })
          .onActionEnd(() => {
            const maxZoom = +(this.params.maxScale as number)
            if (this.curScale > maxZoom) {
              this.setParams(maxZoom, this.lastCenter)
            }
            this.pinchValue = Math.min(this.curScale, maxZoom)
          }),
      ),
    )
  }
}

@ComponentV2
export default struct MyBricksImagePreview {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  @Local isDisabledSwiper: boolean = false


  aboutToAppear(): void {
    this.inputs?.setItems((array: AnyType) => {
      this.data.items = array
    })


    this.inputs?.activeIndex((index: AnyType) => {
      this.data.current = index
    })
  }

  build() {
    Column() {
      Swiper() {
        ForEach(this.data.items, (item: ListItemType, index: number) => {
          SwiperItem({
            url: item.thumbnail,
            index: index,
            active: this.data.current,
            params: this.data,
            isDisabledSwiper: this.isDisabledSwiper,
            onDisabledSwiper: (isDisabled: boolean) => {
              this.isDisabledSwiper = isDisabled
            },
            outputs: this.outputs
          })
        }, (item: ListItemType, index: number) => JSON.stringify(item) + index)
      }
      .index($$this.data.current)
      .indicator(false)
      .loop(this.data.loop)
      .duration(this.data.swipeDuration)
      .disableSwipe(this.isDisabledSwiper)
      .width('100%')
      .height('100%')
      .onChange((index: number) => {
        this.outputs?.onChange(index)
      })
    }
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(this.modifier)
  }

}