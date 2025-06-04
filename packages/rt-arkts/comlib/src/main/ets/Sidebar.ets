import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { CommonModifier } from '@kit.ArkUI';

type ContentShowType = "roll" | "switch"

// Tab项定义
interface Tab {
  _id: string
  tabName: string
}

// 数据类型定义
export interface DataType {
  tabs?:Tab[],
  tabItemGap?: number,
  navBarGutter?: number,
  contentShowType?:'roll' | 'switch'
}

@ObservedV2
export class Data implements DataType {
  @Trace tabs: Tab[]
  @Trace tabItemGap: number
  @Trace contentShowType?: 'roll' | 'switch' | undefined

  constructor(config?: DataType) {
    this.tabs = config?.tabs ?? []
    this.tabItemGap = config?.tabItemGap ?? 0
    this.contentShowType = config?.contentShowType ?? "switch"
  }
}

interface InputTabData {
  id: string,
  tabName: string
}

interface Inputs {
  dataSource: (fn: (ds: InputTabData[], outputRels?: AnyType) => void) => void
  activeTabId: (fn: (val: number, outputRels?: AnyType) => void) => void
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
export default struct MyBricksSideBar {
  @Param data: Data = new Data()
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined
  @Param outputs?: Outputs = undefined
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @BuilderParam slots: (params: SlotsParamsTabItem) => void = emptySlot;

  @Local isFixed: boolean = false
  @Local tabBarModifier: CommonModifier = new CommonModifier();
  @Local isVertical: boolean = true;
  @Local text: string = '文本';
  @Local currentTabId?: string
  private controller: TabsController = new TabsController();

  aboutToAppear() {
     // this.data.tabs = [{_id:"1",tabName:"全部"},{_id:"2",tabName:"1号线"},{_id:"3",tabName:"2号线"}]
    // 初始化当前tab
    if(this.data.tabs.length > 0) {
      this.currentTabId = this.data.tabs[0]._id
    }

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

    this.tabBarModifier.align(Alignment.Top);
  }

  @Builder
  renderTabContent(tab: Tab, index: number) {
    Column() {
      //Text(`tab._id+${tab._id}`)
        // 静态tab内容
        this.slots?.({
          id: tab._id,
          key: tab._id,
        })
    }
    .width('100%')
    .height('100%')
    // .visibility(this.currentTabId === tab._id ? Visibility.Visible : Visibility.None)
  }

  @Builder
  renderTabItem(params: RenderTabItemParams) {
    Column() {
      Text(params?.tab.tabName).fontSize(12).fontColor(params.isActive ? '#FF686B' : "#434343")
      Line()
        .position({
          left: 0,
          top: '50%',
        })
        .width(3)
        .height(15)
         .translate({ y: '-50%' })
        .backgroundColor(params.isActive ? '#FF686B' : Color.Transparent)
        .borderRadius(10)
    }
    // .align(Alignment.Bottom)
    .align(Alignment.Center)
    .width('100%')
    // .flexGrow(1)
    .height(45)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(params.isActive ? '#FFFFFF' : Color.Transparent)
    .onClick(()=>{
      this.controller.changeIndex(params.index)
      this.currentTabId = this.data.tabs[params.index]._id

      this.outputs?.changeTab?.({
        id: this.data.tabs[params.index]._id,
        title: this.data.tabs[params.index].tabName,
        index:params.index,
      })
    })
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
      Tabs({ barPosition: BarPosition.Start, controller: this.controller, barModifier: this.tabBarModifier }) {
        ForEach(this.data.tabs, (tab: Tab, index: number) => {
          TabContent() {
            // Text(`index+${index}`)
            this.renderTabContent(tab, index)
          }.tabBar(this.renderTabItem({ tab, index, isActive: this.currentTabId === tab._id }))
        })
      }
      .vertical(true)
      .height('100%')
      .backgroundColor(Color.Transparent)
      .scrollable(false)
      .animationDuration(0)
      .barMode(BarMode.Scrollable)
      .barWidth(90)
      .barBackgroundColor('#F8F8F8')
    }
    .width('100%')
    .height('100%')
  }
}