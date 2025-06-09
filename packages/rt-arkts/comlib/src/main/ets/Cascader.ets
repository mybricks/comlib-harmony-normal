import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { CommonModifier } from '@kit.ArkUI';

interface CascaderItem {
  label: string,
  value: string,
  children?: CascaderItem[]
}

// Tab项定义
interface Tab {
  _id: string
  tabName: string
}

// 数据类型定义
export interface DataType {
  placeholder?: string,
  options?: CascaderItem[]
}

@ObservedV2
export class Data implements DataType {
  @Trace placeholder: string = '请选择'
  @Trace options?: CascaderItem[]

  constructor(config?: DataType) {
    this.placeholder = config?.placeholder ?? '请选择';
    this.options = config?.options ?? [];
  }
}

interface Inputs {
  addDataSource: (fn: (ds: CascaderItem[], outputRels?: AnyType) => void) => void
  setValue: (fn: (vals: string[], outputRels?: AnyType) => void) => void
}


// 输出接口定义
interface Outputs {
  onSelect: (value: CascaderItem) => void
  onChange: (value: CascaderItem) => void
}

interface RenderTabItemParams {
  path: CascaderItem,
  index: number,
  isActive: boolean
}

@ComponentV2
export default struct MyBricksSideBar {
  @Param data: Data = new Data()
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined
  @Param outputs?: Outputs = undefined
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Local options: CascaderItem[] = this.data.options ?? []
  @Local selectedValues: string[] = []
  /** 已选择的层级 */
  @Local selectedPath: CascaderItem[] = []
  @Local isFixed: boolean = false
  @Local tabBarModifier: CommonModifier = new CommonModifier();
  @Local isVertical: boolean = true;
  @Local text: string = '文本';
  @Local currentTabId?: string
  private controller: TabsController = new TabsController();

  aboutToAppear() {
    this.inputs?.addDataSource?.((ds, outputRels: AnyType) => {
      if (Array.isArray(ds)) {
        this.options = ds
      }
    })

    this.inputs?.setValue?.((vals, outputRels: AnyType) => {
      if (Array.isArray(vals)) {
        this.selectedValues = vals
      }
    })

    this.tabBarModifier.align(Alignment.Start);
  }

  @Builder
  renderTabContent(index: number) {
    Column() {
      List({ space: 0, initialIndex: 0 }) {
        ForEach(this.cascaderPath[index]?.children, (item: CascaderItem) => {
          ListItem() {
            Row() {
              Text(item.label)
                .fontSize(14)
              SymbolGlyph($r('sys.symbol.chevron_right'))
                .fontSize(20)
                .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                .fontColor(['#000000', Color.White])
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding({
              top: 10,
              bottom: 10,
              left: 16,
              right: 16
            })
            .onClick(() => {
              this.selectedPath[this.selectedPath.length] = item
              this.controller.changeIndex(this.selectedPath.length + 1)
            })
          }
        }, (item: CascaderItem) => item.value)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  renderTabItem(params: RenderTabItemParams) {
    Column() {
      Text(params?.path.label).fontSize(12).fontColor(params.isActive ? '#FF686B' : "#434343")
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
    .onClick(() => {
      this.controller.changeIndex(params.index)
      // this.currentTabId = this.data.tabs[params.index]._id
    })
  }

  // setCurrentTabId (currentTabId: string) {
  //   const index = this.data.tabs.findIndex((tab) => tab._id == currentTabId);
  //   if (index === -1) {
  //     return;
  //   }
  //   const findItem = this.data.tabs[index];
  //
  //   this.currentTabId = currentTabId
  //
  //   this.outputs?.changeTab?.({
  //     id: findItem._id,
  //     title: findItem.tabName,
  //     index,
  //   });
  // }

  @Computed
  get cascaderPath(): CascaderItem[] {
    if (this.selectedPath.length === 0) {
      return [
        {
          label: this.data.placeholder,
          value: '__',
          children: this.options
        }
      ]
    }
    return this.selectedPath.concat({
      label: this.data.placeholder,
      value: '__',
      children: this.selectedPath[this.selectedPath.length - 1].children
    });
  }

  @Computed
  get activeIndex(): number {
    return this.selectedPath.length
  }

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.Start,
        index: this.activeIndex,
        controller: this.controller,
        barModifier: this.tabBarModifier
      }) {
        ForEach(this.cascaderPath, (path: CascaderItem, index: number) => {
          TabContent() {
            this.renderTabContent(index)
          }.tabBar(
            SubTabBarStyle.of(path.label)
              .indicator({
                color: '#ee0a24', //下划线颜色
                height: 3, //下划线高度
                width: 44, //下划线宽度
                borderRadius: 0, //下划线圆角半径
                marginTop: 10 //下划线与文字间距
              })
              .board({ borderRadius: 0 })
              .selectedMode(SelectedMode.INDICATOR)
              .labelStyle({ unselectedColor: '#646566', selectedColor: '#323233', font: { size: 14 } })
          )
        }, (item: CascaderItem) => item.value)
      }
      .backgroundColor(Color.Transparent)
      .width('100%')
      .barMode(BarMode.Scrollable)
      .onChange(index => {
        return
        this.selectedPath.slice(0, index)
      })
    }
    .width('100%')
    .height('100%')
  }
}