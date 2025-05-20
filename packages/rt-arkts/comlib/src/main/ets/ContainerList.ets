import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'

export interface DataType {
  direction?: 'row' | 'column',
  spacing?: number
  rowKey?: string
}

type DataSourceItem = Record<string, string | number | boolean | Object> | string | number | boolean

@ObservedV2
export class Data implements DataType {
  @Trace rowKey?: string
  @Trace spacing?: number = 0
  @Trace direction?: 'row' | 'column' = 'column'

  constructor(config: DataType) {
    this.rowKey = config.rowKey ?? 'id'
    this.spacing = config.spacing ?? 0
    this.direction = config?.direction ?? 'column'
  }
}


interface Inputs {
  addDataSource: (fn: (ds: Array<DataSourceItem>) => void) => void
  refreshDataSource: (fn: (ds: Array<DataSourceItem>) => void) => void
}

interface Outputs {
}

interface ItemParamsInputValues {
  index: number,
  itemData: DataSourceItem
}

export interface SlotsParamsItem {
  id: string,
  inputValues: ItemParamsInputValues
}

@Builder function emptySlot(params: SlotsParamsItem) {}

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
  @Local dataSource: Array<DataSourceItem> = []

  @BuilderParam slots: (slotsParams: SlotsParamsItem) => void = emptySlot;

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
          }
        })
      }.listDirection(this.data.direction === 'row' ? Axis.Horizontal: Axis.Vertical)
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
