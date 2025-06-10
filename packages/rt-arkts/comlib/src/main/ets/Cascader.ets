import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { CommonModifier } from '@kit.ArkUI';

interface CascaderItem {
  label: string,
  value: string,
  children?: CascaderItem[]
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

@ComponentV2
export default struct MyBricksCascader {
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
  @Local activeIndex: number = 0

  @Local isFixed: boolean = false
  @Local tabBarModifier: CommonModifier = new CommonModifier();
  @Local isVertical: boolean = true;
  @Local text: string = '文本';
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

  getSeletableList(index: number) {
    if (index === 0) {
      return this.options
    }
    return this.selectedPath[index - 1].children
  }

  hasSelected(itemValue: string) {
    return this.selectedPath.some(t => t.value === itemValue)
  }

  @Builder
  renderTabContent(index: number) {
    Column() {
      List({ space: 0, initialIndex: 0 }) {
        ForEach(this.getSeletableList(index), (item: CascaderItem) => {
          ListItem() {
            Row() {
              Text(item.label)
                .fontSize(14)
                .fontColor(this.hasSelected(item.value) ? 'red' : '#000000')
                .fontWeight(this.hasSelected(item.value) ? 500 : 400)
              Column() {
                if (this.hasSelected(item.value)) {
                  SymbolGlyph($r('sys.symbol.checkmark'))
                    .fontSize(20)
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([this.hasSelected(item.value) ? 'red' : '#000000', Color.White])
                    .fontWeight(this.hasSelected(item.value) ? 500 : 400)
                }
              }

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
              const hasSelected = this.hasSelected(item.value)
              if (hasSelected) {
                return
              }
              // 切换选择，后面的选择都需要取消
              this.selectedPath[index] = item
              this.selectedPath.splice(index + 1)

              if (item.children?.length) {
                this.activeIndex = index + 1
              }
            })
          }
        }, (item: CascaderItem) => item.value)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Computed
  get cascaderPath(): CascaderItem[] {
    if (this.selectedPath.length === 0) {
      return [
        {
          label: this.data.placeholder,
          value: '_0_',
          children: this.options
        }
      ]
    }
    const nextOption = this.selectedPath[this.selectedPath.length - 1]

    if (nextOption?.children?.length) {
      return this.selectedPath.concat({
        label: this.data.placeholder,
        value: String(Math.random()),
        children: nextOption.children
      });
    }
    return this.selectedPath;
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
              .labelStyle({ unselectedColor: '#646566', selectedColor: '#323233', font: { size: 14, weight: 500 } })
          ).id(path.value)
        }, (item: CascaderItem) => item.value)
      }
      .backgroundColor(Color.Transparent)
      .width('100%')
      .barMode(BarMode.Scrollable)
      .animationDuration(0)
      .onChange(index => {
        this.activeIndex = index
      })
    }
    .width('100%')
    .height('100%')
  }
}