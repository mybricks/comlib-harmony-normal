/**
 * @todo 参考 https://developer.huawei.com/consumer/cn/doc/harmonyos-faqs/faqs-arkui-344 自定义实现能更贴近配置
 * */

import {
  ApplyFontStyleModifier,
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'

import { getFilterSelector } from './utils/cssSelector';

import { getStyleValueByPattern } from './utils/StyleMatching'

type ContentShowType = "roll" | "switch"

// Tab项定义
interface Tab {
  _id: string
  tabName: string
  height?: number
  style?: CSSProperties
  activeStyle?: CSSProperties
  useStyle?: boolean
  badge?: string,
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

// 数据类型定义
export interface DataType {
  /** @deprecated */
  mode?: string
  /** @deprecated */
  new_index?: string | number
  /** @deprecated */
  edit?: AnyType
  tabs: Tab[]
  initChangeTab: boolean
  swipeable?: boolean
  tabWidthType?: 'fit' | 'fill'
  tabItemGap?: number
  sticky?: boolean
  slotStyle?: CSSProperties
  contentShowType: ContentShowType
  useDynamicTab?: boolean
  hideContent?: boolean
}

@ObservedV2
export class Data implements DataType {
  @Trace tabs: Tab[]
  @Trace sticky: boolean
  @Trace swipeable: boolean
  @Trace tabWidthType: 'fit' | 'fill'
  @Trace tabItemGap: number
  @Trace contentShowType: ContentShowType
  @Trace useDynamicTab: boolean
  @Trace initChangeTab: boolean
  @Trace hideContent: boolean

  constructor(config?: DataType) {
    this.tabs = config?.tabs ?? []
    this.sticky = config?.sticky ?? false
    this.swipeable = config?.swipeable ?? false
    this.tabWidthType = config?.tabWidthType ?? 'fill'
    this.tabItemGap = config?.tabItemGap ?? 0
    this.contentShowType = config?.contentShowType ?? "switch"
    this.useDynamicTab = config?.useDynamicTab ?? false
    this.initChangeTab = config?.initChangeTab ?? false
    this.hideContent = config?.hideContent ?? false
  }
}

interface InputTabData {
  id: string,
  tabName: string
}

interface Inputs {
  dataSource: (fn: (ds: InputTabData[], outputRels?: AnyType) => void) => void
  activeTabId: (fn: (val: number, outputRels?: AnyType) => void) => void
  setBadge: (fn: (val: AnyType) => void) => void
  setDesc: (fn: (val: AnyType) => void) => void
  getActiveTabId: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
}

type SwitchTabInput = (fn: (selected: boolean, outputRels?: AnyType) => void) => void

interface ChangeTabItem {
  id: string,
  title: string,
  index: number
}

// 输出接口定义
interface Outputs {
  changeTab: (value: ChangeTabItem) => void
  changeDone: (value: boolean) => void
}

export interface SlotsParamsTabItem {
  id: string,
  inputValues?: AnyType
  key?: string
}

interface RenderTabItemParams {
  tab: Tab,
  index: number,
  isActive: boolean
}

@Builder
function emptySlot(params: SlotsParamsTabItem) {
}

@ComponentV2
export default struct MyBricksTabs {
  @Param data: Data = new Data()
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined
  @Param outputs?: Outputs = undefined
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (params: SlotsParamsTabItem) => void = emptySlot;
  @Local isFixed: boolean = false
  @Local tabsPaneHeight: number = 0
  @Local customNavigationHeight: number = 0
  @Local tabsHeight: number = 0
  @Local currentTabId: string = this.data.tabs?.[0]?._id || ''
  @Local currentTabIndex: number = 0
  @Local windowHeight: number = 0
  @Local windowWidth: number = 0
  @Local safeAreaHeight: number = 0
  @Local tabsTextColor: AnyType = ''
  @Local tabsTextColorActive: AnyType = ''
  @Local tabsLineStyle: AnyType = ''

  @Local contentWidth: AnyType = 0
  @Local screenWidth: AnyType = 0

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined


  private scroller: Scroller = new Scroller()

  async aboutToAppear() {

    const tabsTextActive = this.styles[`.taroify-tabs__tab--active${getFilterSelector()}`]
    this.tabsTextColorActive = tabsTextActive.color

    const tabsText = this.styles[`.taroify-tabs__tab:not(.taroify-tabs__tab--active)${getFilterSelector()}`]
    this.tabsTextColor = tabsText.color


    // 初始化当前tab
    if (this.data.tabs.length > 0) {
      const tab = this.data.tabs[0]
      this.setCurrentTabId(tab._id)
    }

    this.inputs?.activeTabId?.((index) => {
      this.currentTabIndex = index
      const tab = this.data.tabs[index]
      this.setCurrentTabId(tab._id)
    })

    this.inputs?.dataSource?.((ds: InputTabData[], outputRels: AnyType) => {
      if (Array.isArray(ds)) {
        this.data.tabs = ds.map(item => ({
          _id: item.id,
          tabName: item.tabName
        }) as Tab)
        this.currentTabId = this.data.tabs[0]._id
      }
    })

    this.data.tabs.forEach((item) => {
      if (this.inputs) {
        const tabInput: SwitchTabInput = Reflect.get(this.inputs, item._id);
        tabInput?.((selected, relOutputs: AnyType) => {
          this.setCurrentTabId(item._id)
          relOutputs.changeDone?.(selected);
        })
      }
    });
  }

  private handleTabScroll(index: number) {
    // 如果内容宽度小于等于屏幕宽度，不需要滚动
    if (this.contentWidth <= this.screenWidth) {
      return
    }

    // 计算每个标签的估计宽度
    const tabWidth = this.parseStyleValue(this.styles['.taroify-tabs__tab--active']?.width) ||
      (this.screenWidth / Math.min(this.data.tabs.length, 4))

    let scrollPosition = 0

    // 如果是最后几个标签
    if (index >= this.data.tabs.length - 2) {
      // 滚动到最右端，留出一定余量
      scrollPosition = this.contentWidth - this.screenWidth
    } else {
      // 计算目标位置，使当前标签尽量居中
      scrollPosition = Math.max(0, (tabWidth * index) - (this.screenWidth - tabWidth) / 2)
    }

    // 使用动画滚动到目标位置
    this.scroller.scrollTo({
      xOffset: scrollPosition,
      yOffset: 0,
      animation: {
        duration: 300,
        curve: Curve.EaseOut
      }
    })
  }


  @Builder
  renderTabContent(tab: Tab, index: number) {
    Column() {
      if (this.data.useDynamicTab) {
        // 动态tab内容
        this.slots?.({
          id: 'tabItem',
          inputValues: {
            itemData: tab,
            index: index,
          },
        })
      } else {
        // 静态tab内容
        this.slots?.({
          id: tab._id,
          key: tab._id,
        })
      }
    }
    .width('100%')
    .height("auto")
    .visibility(this.currentTabId === tab._id ? Visibility.Visible : Visibility.None)
  }

  setCurrentTabId(currentTabId: string) {
    const index = this.data.tabs.findIndex((tab) => tab._id == currentTabId);
    if (index === -1) {
      return;
    }
    const findItem = this.data.tabs[index];

    this.currentTabId = currentTabId

    this.outputs?.changeTab?.({
      id: findItem._id,
      title: findItem.tabName,
      index,
    });
  }

  parseStyleValue(value: string | number): number {
    if (typeof value === 'number') {
      return value;
    }
    // 处理带px单位的字符串
    if (typeof value === 'string' && value.endsWith('px')) {
      return parseInt(value);
    }
    // 处理纯数字字符串
    return parseInt(String(value));
  }

  build() {
    Column() {
      // 自定义tab顶部标签页
      Scroll(this.scroller) {
        Row() {
          ForEach(this.data.tabs, (tab: Tab, index: number) => {
            Column() {
              Stack({ alignContent: Alignment.Bottom }) {  // 使用Stack布局来实现绝对定位效果
                Column() {
                  Text(tab.tabName)
                    .height('100%')
                    .layoutWeight(1)
                    .textAlign(TextAlign.Center)
                    .fontColor(
                      this.styles[
                      this.currentTabId === tab._id
                        ? `.taroify-tabs__tab--active${getFilterSelector()}`
                        : `.taroify-tabs__tab:not(.taroify-tabs__tab--active)${getFilterSelector()}`
                      ]?.color || (this.currentTabId === tab._id ? "#323233" : "#646566")
                    )
                    .fontSize(
                    getStyleValueByPattern(this.styles,[
                      this.currentTabId === tab._id
                        ? `.taroify-tabs__tab--active${getFilterSelector()}`
                        : `.taroify-tabs__tab:not(.taroify-tabs__tab--active)${getFilterSelector()}`
                    ],"fontSize",14)
                  )
                }

                Column()
                  .width(this.parseStyleValue(this.styles[`.taroify-tabs__line${getFilterSelector()}`]?.width) || 45)
                  .height(this.parseStyleValue(this.styles[`.taroify-tabs__line${getFilterSelector()}`]?.height) || 3)
                  .backgroundColor(
                    this.currentTabId === tab._id
                      ? (this.styles[`.taroify-tabs__line${getFilterSelector()}`]?.backgroundColor || "#EE0A24")
                      : Color.Transparent
                  )
                  // .position({ x: '50%', y: 0 }) // 设置绝对定位
                  // .translate({ x: '-50%', y: 0 }) // 居中对齐
              }
              // .width('100%')
              .height('100%')
            }
            .onClick(() => {
              // this.currentTabId = tab._id
              this.currentTabIndex = index
              const tab = this.data.tabs[index]
              this.setCurrentTabId(tab._id)

              this.handleTabScroll(index)
            })
            .backgroundImageSize(ImageSize.Cover) // 或 ImageSize.Contain
            .backgroundImagePosition(Alignment.Center) // 设置背景图片居中
            .height(getStyleValueByPattern(
              this.styles,
              [
                this.currentTabId === tab._id
                  ? `.taroify-tabs__tab--active${getFilterSelector()}`
                  : `.taroify-tabs__tab:not(.taroify-tabs__tab--active)${getFilterSelector()}`
              ],
              'height',
              35
            ))
            // .flexGrow(1)  // 让Text填充剩余空间
            .layoutWeight(this.data.tabWidthType === 'fill' ? 1 : '')
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .attributeModifier(new ApplyStyleModifier(
              this.styles[this.currentTabId === tab._id ? `.taroify-tabs__tab--active${getFilterSelector()}` :
                `.taroify-tabs__tab:not(.taroify-tabs__tab--active)${getFilterSelector()}`]
            ))
            .padding({
              left: this.styles[
              this.currentTabId === tab._id
                ? `.taroify-tabs__tab--active${getFilterSelector()}`
                : `.taroify-tabs__tab:not(.taroify-tabs__tab--active)${getFilterSelector()}`
              ]?.paddingLeft || 12,
              right: this.styles[
              this.currentTabId === tab._id
                ? `.taroify-tabs__tab--active${getFilterSelector()}`
                : `.taroify-tabs__tab:not(.taroify-tabs__tab--active)${getFilterSelector()}`
              ]?.paddingRight || 12,
            })
            .width('auto')

          })
        }
        .onAreaChange((oldArea: Area, newArea: Area)=>{
          this.contentWidth = newArea.width
        })
        .justifyContent(FlexAlign.Start)
      }
      .align(Alignment.Start)
      .width('100%')
      .onAreaChange((oldArea: Area, newArea: Area)=>{
        this.screenWidth = newArea.width
      })
      .scrollable(this.contentWidth > this.screenWidth ? ScrollDirection.Horizontal : ScrollDirection.None) // 设置横向滚动
      .scrollBar(BarState.Off)  // 隐藏滚动条
      .edgeEffect(EdgeEffect.Spring) // 设置滚动到边缘时的效果
      .attributeModifier(new ApplyStyleModifier(this.styles['.taroify-tabs__wrap .taroify-tabs__wrap__scroll']))

      if (!this.data.hideContent) {
        ForEach(this.data.tabs, (tab: Tab, index: number) => {
          this.renderTabContent(tab, index)
        })
      }

    }
    .width('100%')
    .height('100%')
    .attributeModifier(new ApplyRootStyleModifier(this.styles['root']))
  }
}