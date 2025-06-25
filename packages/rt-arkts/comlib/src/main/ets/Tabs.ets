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
  @Local screenWidth: number = 0
  @Local tabsTextColor: AnyType = ''
  @Local tabsTextColorActive: AnyType = ''
  @Local tabsLineStyle: AnyType = ''

  async aboutToAppear() {

    const tabsTextActive = this.styles['.taroify-tabs__tab--active']
    this.tabsTextColorActive = tabsTextActive.color

    const tabsText = this.styles['.taroify-tabs__tab:not(.taroify-tabs__tab--active)']
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

    this.screenWidth = vp2px(100)

    console.log("screenWidth", this.screenWidth)
  }

  getWidth(num: number) {
    // return '100%'
    // const res = 100 / num
    const res = this.screenWidth / num
    return res
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
      Row() {
        ForEach(this.data.tabs, (tab: Tab, index: number) => {
          Column() {
            Text(tab.tabName)
              .height('100%')// 占满高度
              .layoutWeight(1)// .width("100%")
              .textAlign(TextAlign.Center)
              .fontColor(
                this.styles[
                this.currentTabId === tab._id
                  ? '.taroify-tabs__tab--active'
                  : '.taroify-tabs__tab:not(.taroify-tabs__tab--active)'
                ]?.color || (this.currentTabId === tab._id ? "#323233" : "#646566")
              )
              .fontSize(
                this.styles[
                this.currentTabId === tab._id
                  ? '.taroify-tabs__tab--active'
                  : '.taroify-tabs__tab:not(.taroify-tabs__tab--active)'
                ]?.fontSize || 14
              )

            if (this.currentTabId === tab._id) {
              Column()
                .width(this.parseStyleValue(this.styles['.taroify-tabs__line'].width) || 45)
                .height(this.parseStyleValue(this.styles['.taroify-tabs__line'].height) || 3)
                .zIndex(-1)
                .backgroundColor(this.currentTabId === tab._id ? this.styles['.taroify-tabs__line'].backgroundColor :
                Color.Transparent)
            } else {
              Column()
                .width(this.parseStyleValue(this.styles['.taroify-tabs__line'].width) || 45)
                .height(this.parseStyleValue(this.styles['.taroify-tabs__line'].height) || 3)
                .zIndex(-1)
                .backgroundColor(Color.Transparent)

            }

          }
          .onClick(() => {
            // this.currentTabId = tab._id
            this.currentTabIndex = index
            const tab = this.data.tabs[index]
            this.setCurrentTabId(tab._id)
          })
          .backgroundImageSize(ImageSize.Cover) // 或 ImageSize.Contain
          .backgroundImagePosition(Alignment.Center) // 设置背景图片居中
          .height(44)
          // .flexGrow(1)  // 让Text填充剩余空间
          .layoutWeight(this.data.tabWidthType === 'fill' ? 1 : '')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .attributeModifier(new ApplyStyleModifier(
            this.styles[this.currentTabId === tab._id ? '.taroify-tabs__tab--active' :
              '.taroify-tabs__tab:not(.taroify-tabs__tab--active)']
          ))
          .padding({
            left: this.styles[
            this.currentTabId === tab._id
              ? '.taroify-tabs__tab--active'
              : '.taroify-tabs__tab:not(.taroify-tabs__tab--active)'
            ]?.paddingLeft || 12,
            right: this.styles[
            this.currentTabId === tab._id
              ? '.taroify-tabs__tab--active'
              : '.taroify-tabs__tab:not(.taroify-tabs__tab--active)'
            ]?.paddingRight || 12,
          })

        })
      }
      .width('100%')
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