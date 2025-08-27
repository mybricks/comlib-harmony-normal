import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

import { parseLinearGradient } from "./utils/StyleMatching"

export type DataType = AnyType

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
  navigationStyle?: string
  navigationBarStyle?: AnyType
  enabledPulldown: boolean = false
  backgroundImage?: string
  backgroundColor?: string
  bottomSpace?: number
  backgroundPosition?: string
  backgroundSize?: string
  backgroundRepeat?: string

  constructor(config: DataType) {
    this.navigationBarStyle = config?.navigationBarStyle
    this.navigationStyle = config?.navigationStyle
    this.backgroundColor = config?.backgroundColor ?? config.background
    this.backgroundImage = config?.backgroundImage
    this.bottomSpace = config?.bottomSpace
    this.backgroundPosition = config?.backgroundPosition
    this.backgroundSize = config?.backgroundSize
    this.backgroundRepeat = config?.backgroundRepeat

  }
}

interface Inputs {}

interface Outputs {}

@Builder
function emptySlot(params: AnyType) {
}

@ComponentV2
export default struct MyBricksSystemPage {
  @Param data: Data = new Data({
    background: '#ffffff',
    enabledPulldown: false
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (params: AnyType) => void = emptySlot;
  @Local isRefreshing: boolean = false;
  @Local backgroundStyle: AnyType = parseBackgroundStyle({
    backgroundColor: this.data.backgroundColor,
    backgroundImage: this.data.backgroundImage,
    backgroundPosition: this.data.backgroundPosition,
    backgroundSize: this.data.backgroundSize,
    backgroundRepeat: this.data.backgroundRepeat
  })
  @Param _env?: _Env = undefined
  @Param env?: Env = undefined
  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  aboutToAppear(): void {

  }

  @Builder
  renderContent() {
    Column() {
      if (this.data.navigationStyle === 'custom') {
        Row() {
          this.slots({
            id: 'header'
          })
        }.backgroundColor(this.data.navigationBarStyle?.backgroundColor)
      }
      Scroll() {
        Column() {
          this.slots({
            id: 'content'
          })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .align(Alignment.Start)
      }
      .layoutWeight(1)
      .align(Alignment.TopStart)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .applyScrollBackground(this.data.navigationStyle === 'custom' || this.data.navigationStyle === 'default' ?
      this.backgroundStyle : {})
      .padding({
        bottom: this.data.bottomSpace || 30
      })
    }
    .height('100%')
    .width('100%')
  }

  build() {
    if (this.data.enabledPulldown) {
      Refresh({ refreshing: this.isRefreshing }) {
        this.renderContent()
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .applyRefreshBackground(this.data.navigationStyle === 'none' ? this.backgroundStyle : {})
      .onRefreshing(() => {
        // 数据刷新逻辑
      })
    } else {
      Column() {
        this.renderContent()
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .applyColumnBackground(this.data.navigationStyle === 'none' ? this.backgroundStyle : {})
    }
  }
}

@Extend(Column)
function applyColumnBackground(backgroundStyle: AnyType) {
  .backgroundColor(backgroundStyle?.backgroundColor ?? Color.Transparent)
  .backgroundImage(backgroundStyle?.backgroundImage ?? undefined, backgroundStyle?.backgroundRepeat)
  .linearGradient(backgroundStyle?.linearGradient ?? {})
  .backgroundImageSize(backgroundStyle?.backgroundSize ?? ImageSize.Auto)
  .backgroundImagePosition(backgroundStyle?.backgroundPosition ?? Alignment.TopStart)
}

@Extend(Refresh)
function applyRefreshBackground(backgroundStyle: AnyType) {
  .backgroundColor(backgroundStyle?.backgroundColor ?? Color.Transparent)
  .backgroundImage(backgroundStyle?.backgroundImage ?? undefined)
  .linearGradient(backgroundStyle?.linearGradient ?? {})
}

@Extend(Scroll)
function applyScrollBackground(backgroundStyle: AnyType) {
  .backgroundColor(backgroundStyle?.backgroundColor ?? Color.Transparent)
  .backgroundImage(backgroundStyle?.backgroundImage ?? undefined)
  .linearGradient(backgroundStyle?.linearGradient ?? {})
}

function parseBackgroundStyle(styleObject: AnyType): AnyType {
  const backgroundColor: string = styleObject?.backgroundColor;
  const backgroundImage: string = styleObject?.backgroundImage;
  const backgroundPosition: string = styleObject?.backgroundPosition
  const backgroundSize: string = styleObject?.backgroundSize
  const backgroundRepeat: string = styleObject?.backgroundRepeat

  const parseBackgroundSize = (backgroundSize: string) => {
    if (backgroundSize == "cover") {
      return ImageSize.Cover
    }
    if (backgroundSize == "contain") {
      return ImageSize.Contain
    }
    if (backgroundSize == "auto") {
      return ImageSize.Auto
    }
    if (backgroundSize == "100% 100%") {
      return ImageSize.FILL
    }
    return ImageSize.Auto
  }

  const parseBackgroundPosition = (backgroundPosition: string) => {
    if (backgroundPosition == "top") {
      return Alignment.Top
    }
    if (backgroundPosition == "center") {
      return Alignment.Center
    }
    if (backgroundPosition == "bottom") {
      return Alignment.Bottom
    }
    if (backgroundPosition == "top left") {
      return Alignment.TopStart
    }
    if (backgroundPosition == "bottom left") {
      return Alignment.BottomStart
    }
    if (backgroundPosition == "top right") {
      return Alignment.TopEnd
    }
    if (backgroundPosition == "bottom right") {
      return Alignment.BottomEnd
    }
    return Alignment.TopStart
  }

  const parseBackgroundRepeat = (backgroundRepeat: string) => {
    if (backgroundRepeat == "no-repeat") {
      return ImageRepeat.NoRepeat
    }
    if (backgroundRepeat == "repeat") {
      return ImageRepeat.XY
    }
    return ImageRepeat.NoRepeat
  }

  if (backgroundImage?.startsWith?.('url(')) {
    const urlMatch = backgroundImage.match(/url\((.*?)\)/);
    const imageUrl = urlMatch ? urlMatch[1] : '';
    return {
      backgroundColor: backgroundColor,
      backgroundImage: imageUrl,
      backgroundPosition: parseBackgroundPosition(backgroundPosition),
      backgroundSize: parseBackgroundSize(backgroundSize),
      backgroundRepeat: parseBackgroundRepeat(backgroundRepeat)
    };
  }
  // 如果是渐变
  if (backgroundImage?.startsWith?.('linear-gradient')) {
    return {
      backgroundColor: backgroundColor,
      linearGradient: parseLinearGradient(backgroundImage)
    }
  }
  // 如果既不是图片也不是渐变，返回默认背景色
  return {
    backgroundColor: backgroundColor
  };
}