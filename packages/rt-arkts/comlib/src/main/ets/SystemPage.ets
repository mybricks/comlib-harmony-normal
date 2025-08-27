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

  constructor(config: DataType) {
    this.navigationBarStyle = config?.navigationBarStyle
    this.navigationStyle = config?.navigationStyle
    this.backgroundColor = config?.backgroundColor ?? config.background
    this.backgroundImage = config?.backgroundImage
    this.bottomSpace = config?.bottomSpace
  }
}

interface Inputs {}

interface Outputs {
  pageDidShow: () => void
  pageDidHide: () => void
}

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
        bottom:this.data.bottomSpace || 30
      })
    }
    .height('100%')
    .width('100%')
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean) => {
      if (isVisible) {
        this.outputs?.pageDidShow?.()
      } else {
        this.outputs?.pageDidHide?.()
      }
    })
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
  .backgroundImage(backgroundStyle?.backgroundImage ?? undefined)
  .linearGradient(backgroundStyle?.linearGradient ?? {})
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
  // 提取背景色
  const backgroundColor: string = styleObject?.backgroundColor;

  // 提取渐变字符串
  const backgroundImage: string = styleObject?.backgroundImage;

  // 判断是否为图片URL
  if (backgroundImage?.startsWith?.('url(')) {
    // 提取URL
    const urlMatch = backgroundImage.match(/url\((.*?)\)/);
    const imageUrl = urlMatch ? urlMatch[1] : '';

    return {
      backgroundColor: backgroundColor,
      backgroundImage: imageUrl
    };
  }

  // 如果是渐变，则处理渐变
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