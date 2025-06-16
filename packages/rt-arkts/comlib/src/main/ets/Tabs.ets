/**
 * @todo 参考 https://developer.huawei.com/consumer/cn/doc/harmonyos-faqs/faqs-arkui-344 自定义实现能更贴近配置
 * */

import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from './utils/GetDesignStyle'
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

  constructor(config?: DataType) {
    this.tabs = config?.tabs ?? []
    this.sticky = config?.sticky ?? false
    this.swipeable = config?.swipeable ?? false
    this.tabWidthType = config?.tabWidthType ?? 'fill'
    this.tabItemGap = config?.tabItemGap ?? 0
    this.contentShowType = config?.contentShowType ?? "switch"
    this.useDynamicTab = config?.useDynamicTab ?? false
    this.initChangeTab = config?.initChangeTab ?? false
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

@Builder function emptySlot(params: SlotsParamsTabItem) {}

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
  @Local currentTabId: string = ''
  @Local currentTabIndex: number = 0
  @Local windowHeight: number = 0
  @Local windowWidth: number = 0
  @Local safeAreaHeight: number = 0

  aboutToAppear() {
    // 初始化当前tab
    if(this.data.tabs.length > 0) {
      this.currentTabId = this.data.tabs[0]._id
    }

    this.inputs?.activeTabId?.((index)=>{
      this.currentTabIndex = index
    })

    this.inputs?.dataSource?.((ds: InputTabData[], outputRels: AnyType) => {
      if(Array.isArray(ds)) {
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

  @Builder
  renderTabContent(tab: Tab, index: number) {
    Column() {
      if(this.data.useDynamicTab) {
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
    .height('100%')
    .visibility(this.currentTabId === tab._id ? Visibility.Visible : Visibility.None)
  }

  /**
   * @todo 如果可以实现Line样式的居中的话，还是建议自定义渲染的
   * */
  @Builder
  renderTabItem(params: RenderTabItemParams) {
    Column() {
      Text(params?.tab.tabName)
        .flexGrow(1)  // 让Text填充剩余空间
        .height('100%') // 占满高度
        .textAlign(TextAlign.Center)
        .attributeModifier(new ApplyStyleModifier(
          this.styles[params.isActive ? '.taroify-tabs__text--active' : '.taroify-tabs__text:not(.taroify-tabs__text--active)']
        ))

      Line()
        .width(40)
        .height(3)
        .zIndex(-1)
        .attributeModifier(
          new ApplyStyleModifier(
            this.styles['.taroify-tabs__line']
          )
          .backgroundColor(params.isActive ? '#00F500' : Color.Transparent)
        )
    }
    .align(Alignment.Center)
    .height(44)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(HorizontalAlign.Center)
    .attributeModifier(new ApplyStyleModifier(
      this.styles[params.isActive ? '.taroify-tabs__tab--active' : '.taroify-tabs__tab:not(.taroify-tabs__tab--active)']
    )) //样式编辑器配置背景
  }

  setCurrentTabId (currentTabId: string) {
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

  build() {
    Column() {
      // Tabs组件
      Tabs({ barPosition: BarPosition.Start,index: this.currentTabIndex}) {
        ForEach(this.data.tabs, (tab: Tab, index: number) => {
          TabContent() {
            this.renderTabContent(tab, index)
          }
          .tabBar(this.renderTabItem({ tab, index, isActive: this.currentTabId === tab._id }))
        })
      }
      .scrollable(this.data.swipeable)
      .barMode(BarMode.Scrollable, {
        nonScrollableLayoutStyle: this.data.tabWidthType === 'fit' ? LayoutStyle.ALWAYS_CENTER : LayoutStyle.ALWAYS_AVERAGE_SPLIT
      })
      .onChange((index: number) => {
        const tab = this.data.tabs[index]
        this.setCurrentTabId(tab._id)
      })
    }
    .width('100%')
    .height('100%')
    .attributeModifier(new ApplyRootStyleModifier(this.styles['root']))
  }
}