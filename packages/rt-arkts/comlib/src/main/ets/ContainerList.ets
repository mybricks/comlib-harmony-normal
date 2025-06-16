import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  direction?: 'row' | 'column',
  spacing?: number
  rowKey?: string
  scrollBar?: boolean
  wrap?: boolean
}

type DataSourceItem = Record<string, string | number | boolean | Object> | string | number | boolean

@ObservedV2
export class Data implements DataType {
  @Trace rowKey?: string
  @Trace spacing?: number = 0
  @Trace direction?: 'row' | 'column' = 'column'
  @Trace scrollBar?: boolean = false
  @Trace wrap?: boolean = false

  constructor(config: DataType) {
    this.rowKey = config.rowKey ?? 'id'
    this.spacing = config.spacing ?? 0
    this.direction = config?.direction ?? 'column'
    this.scrollBar = config?.scrollBar ?? false
    this.wrap = config?.wrap ?? false
  }
}


interface Inputs {
  addDataSource: (fn: (ds: Array<DataSourceItem>) => void) => void
  refreshDataSource: (fn: (ds: Array<DataSourceItem>) => void) => void
}

interface Outputs {}

interface ItemParamsInputValues {
  index: number,
  itemData: DataSourceItem
}

export interface SlotsParamsItem {
  id: string,
  inputValues: ItemParamsInputValues
}

@Builder
function emptySlot(params: SlotsParamsItem) {
}

@ComponentV2
export default struct MyBricksContainerList {
  @Param data: Data = new Data({
    rowKey: 'id',
    spacing: 0,
    direction: 'column'
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Local dataSource: Array<DataSourceItem> = []
  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParamsItem) => void = emptySlot;
  @Local maxItemHeight: number = -1

  aboutToAppear(): void {
    this.inputs?.addDataSource((ds) => {
      this.dataSource = this.dataSource.concat(ds)
    })

    this.inputs?.refreshDataSource((ds) => {
      this.dataSource = ds
    })
  }

  build() {
    Column() {
      if (this.data.direction === 'row' && this.data.wrap) {
        //当列表为横向，且开启了换行时，使用Flex组件实现
        Flex({
          direction: FlexDirection.Row,
          wrap: FlexWrap.Wrap,
          justifyContent: FlexAlign.Start,
          alignItems: ItemAlign.Start
        }) {
          ForEach(this.dataSource, (item: DataSourceItem, index) => {
            Column() {
              this.slots({
                id: 'item',
                inputValues: {
                  itemData: item,
                  index
                }
              })
            }
            .margin({
              right: this.data.spacing,
            })
          })
        }
        .width('100%')
        .height('fit-content')
      } else {
        List({ space: this.data.spacing, initialIndex: 0, }) {
          ForEach(this.dataSource, (item: DataSourceItem, index) => {
            ListItem() {
              this.slots({
                id: 'item',
                inputValues: {
                  itemData: item,
                  index
                }
              })
            }.onAreaChange((oldArea: Area, newArea: Area) => {
              if (this.data.direction === 'row' && this.maxItemHeight < newArea.height) { // 横排布局的高度依赖与内部实现
                this.maxItemHeight = newArea.height as number
              }
            })
          })
        }
        .scrollBar(this.data.scrollBar ? BarState.Auto : BarState.Off)
        .listDirection(this.data.direction === 'row' ? Axis.Horizontal : Axis.Vertical)
        .height(this.maxItemHeight == -1 ? 'fit-content' : this.maxItemHeight)
      }
    }
    .alignItems(HorizontalAlign.Start)
    .align(Alignment.Start)
    .height('100%')
    .width('100%')
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
