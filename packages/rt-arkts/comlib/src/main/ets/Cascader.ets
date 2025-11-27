import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties, ApplyFontStyleModifier } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { CommonModifier } from '@kit.ArkUI';
import { parseMargin, parsePadding } from './utils/StyleMatching';

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

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

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
                .attributeModifier(
                  new ApplyFontStyleModifier(this.styles[this.hasSelected(item.value) ? '.mybricks-cascader .taroify-cascader__option--active' : '.mybricks-cascader .taroify-cascader__option:not(.taroify-cascader__option--active)'])
                    .fontSize(14)
                    .fontColor(this.hasSelected(item.value) ? '#EE0A24' : '#000000')
                    .fontWeight(this.hasSelected(item.value) ? 500 : 400)
                )
              Column() {
                if (this.hasSelected(item.value)) {
                  SymbolGlyph($r('sys.symbol.checkmark'))
                    .renderingStrategy(SymbolRenderingStrategy.SINGLE)
                    .fontColor([this.styles['.mybricks-cascader .taroify-cascader__option--active'].color ?? '#EE0A24'])
                    .fontWeight(this.styles['.mybricks-cascader .taroify-cascader__option--active'].fontWeight ?? 500)
                    .fontSize(this.styles['.mybricks-cascader .taroify-cascader__option--active'].fontSize ? parseFloat(this.styles['.mybricks-cascader .taroify-cascader__option--active'].fontSize as string) : 14)
                }
              }
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .attributeModifier(
              new ApplyStyleModifier(this.styles[this.hasSelected(item.value) ? '.mybricks-cascader .taroify-cascader__option--active' : '.mybricks-cascader .taroify-cascader__option:not(.taroify-cascader__option--active)'])
                .padding({
                  top: 10,
                  bottom: 10,
                  left: 16,
                  right: 16
                })
            )
            .margin(parseMargin(this.styles[this.hasSelected(item.value) ? '.mybricks-cascader .taroify-cascader__option--active' : '.mybricks-cascader .taroify-cascader__option:not(.taroify-cascader__option--active)']))
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

  @Computed
  get tabBarLabelStyle(): LabelStyle {
    const defaultLabel = this.styles['.mybricks-cascader .taroify-tabs__tab:not(.taroify-tabs__tab--active)'] || {}
    const activeLabel = this.styles['.mybricks-cascader .taroify-tabs__tab--active'] || {}
    return {
      unselectedColor: defaultLabel?.color ?? '#646566',
      selectedColor: activeLabel?.color ?? '#323233',
      font: {
        size: defaultLabel?.fontSize ? parseFloat(defaultLabel?.fontSize as string) : 14,
        weight: defaultLabel?.fontWeight ?? 500
      }
    }
  }

  @Computed
  get tabBarIndicatorStyle(): IndicatorStyle {
    const indicatorStyle = this.styles['.mybricks-cascader .taroify-tabs__line'] || {}
    return {
      color: indicatorStyle?.backgroundColor ?? '#ee0a24', //下划线颜色
      height: indicatorStyle?.height ? parseFloat(indicatorStyle?.height as string) : 3, //下划线高度
      width: indicatorStyle?.width ? parseFloat(indicatorStyle?.width as string) : 40, //下划线宽度
      borderRadius: 0, //下划线圆角半径
      marginTop: 10 //下划线与文字间距
    }
  }

  @Computed
  get tabBarPadding(): Padding {
    return parsePadding(this.styles['.mybricks-cascader .taroify-tabs__tab:not(.taroify-tabs__tab--active)'], {
      top: 12,
      bottom: 12,
      left: 12,
      right: 12,
    })
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
              .indicator(this.tabBarIndicatorStyle)
              .board({ borderRadius: 0 })
              .selectedMode(SelectedMode.INDICATOR)
              .labelStyle(this.tabBarLabelStyle)
              .padding(this.tabBarPadding)
          )
          .id(path.value)
          .attributeModifier(
            new ApplyStyleModifier(this.styles['.mybricks-cascader .taroify-tabs__content'])
          )
          .margin(parseMargin(this.styles['.mybricks-cascader .taroify-tabs__content']))
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
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-cascader'])
        .backgroundColor(Color.White)
    )
    .attributeModifier(this.modifier)
  }
}