import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties, ApplyFontStyleModifier } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { CommonModifier } from '@kit.ArkUI';
import { getStyleValueByPattern, parseMargin } from './utils/StyleMatching'

type ContentShowType = "roll" | "switch"

// Tab项定义
interface Tab {
  _id: string
  tabName: string
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

  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (params: SlotsParamsTabItem) => void = emptySlot;

  @Local isFixed: boolean = false
  @Local tabBarModifier: CommonModifier = new CommonModifier();
  @Local isVertical: boolean = true;
  @Local text: string = '文本';
  @Local currentTabId?: string
  private controller: TabsController = new TabsController();

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

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

  parseHorizontalAlign(value: string) {
    let result = HorizontalAlign.Start
    switch (value) {
      case "center":
        result = HorizontalAlign.Center
      case "end":
        result = HorizontalAlign.End
    }
    return result
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
    Stack(){
      Column() {
        Text(params?.tab.tabName).attributeModifier(
          new ApplyFontStyleModifier(
            this.styles[params.isActive ? '.taroify-sidebar-tab--active' : '.taroify-sidebar-tab:not(.taroify-sidebar-tab--active)']
          ).fontSize(14).fontColor("#323233")
        )
      }
      .attributeModifier(
        new ApplyStyleModifier(
          this.styles[params.isActive ? '.taroify-sidebar-tab--active' : '.taroify-sidebar-tab:not(.taroify-sidebar-tab--active)']
        )
          .padding({
            top: 14,
            right: 12,
            left: 12,
            bottom: 14
          })
          .backgroundColor(params.isActive ? '#fff' : '#F7F8FA')
          .borderRadius(0)
      )
      // .align(Alignment.Bottom)
      // .align(Alignment.Center)
      .width('100%')
      .height(getStyleValueByPattern(
        this.styles,
        [params.isActive ? '.taroify-sidebar-tab--active' : '.taroify-sidebar-tab:not(.taroify-sidebar-tab--active)'],
        'height',
        45
      ))
      .alignItems(this.parseHorizontalAlign(getStyleValueByPattern<string>(
        this.styles,
        [params.isActive ? '.taroify-sidebar-tab--active' : '.taroify-sidebar-tab:not(.taroify-sidebar-tab--active)'],
        'textAlign',
        "start"
      )))
      .onClick(()=>{
        this.controller.changeIndex(params.index)
        this.currentTabId = this.data.tabs[params.index]._id

        this.outputs?.changeTab?.({
          id: this.data.tabs[params.index]._id,
          title: this.data.tabs[params.index].tabName,
          index:params.index,
        })
      })
      if (params.isActive) {
        Line()
          .attributeModifier(
            new ApplyStyleModifier(
              this.styles['.taroify-sidebar-tab--active:before']
            )
              .borderRadius(0)
              .backgroundColor('#ee0a24')
          )
          .width(getStyleValueByPattern(
            this.styles,
            ['.taroify-sidebar-tab--active:before'],
            'width',
            4
          ))
          .height(getStyleValueByPattern(
            this.styles,
            ['.taroify-sidebar-tab--active:before'],
            'height',
            16
          ))
          .margin(parseMargin(this.styles['.taroify-sidebar-tab--active:before']))
      }
    }.alignContent(Alignment.Start)
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
      .barWidth(getStyleValueByPattern(this.styles, [`.taroify-tree-select__sidebar`], 'width', 90))
      .barBackgroundColor(this.styles[`.taroify-tree-select__sidebar`]?.backgroundColor || "#F8F8F8")
    }
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .width('100%')
    .height('100%')
    .attributeModifier(this.modifier)
  }
}