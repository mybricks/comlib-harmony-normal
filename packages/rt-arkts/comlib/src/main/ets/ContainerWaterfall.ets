import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  spacing?: number
  rowKey?: string,
  layout?: GridLayoutConfig
}

interface GridLayoutConfig {
  type: "grid"; // 固定为 grid 类型
  column: number;
  gutter: [number, number];
  minHeight: number | string;
}

type DataSourceItem = Record<string, string | number | boolean | Object> | string | number | boolean

@ObservedV2
export class Data implements DataType {
  @Trace rowKey?: string
  @Trace spacing?: number = 0
  @Trace layout?: GridLayoutConfig | undefined

  constructor(config: DataType) {
    this.rowKey = config.rowKey ?? 'id'
    this.spacing = config.spacing ?? 0
    this.layout = config.layout ?? {type:"grid",column:2,gutter:[8,8],minHeight:400 }
  }
}


interface Inputs {
  refreshDataSource: (fn: (ds: Array<DataSourceItem>) => void) => void
  addDataSource: (fn: (ds: Array<DataSourceItem>) => void) => void
}

interface Outputs {
  getDataSourceSuccess: (value: string) => void
  afterRefreshDataSource: (value: string) => void
  afterAddDataSource: (value: string) => void
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

function generateColumnsTemplate(columns?: number): string {
  const columnCount = columns ?? 1; // 默认 1 列
  if (columnCount <= 0) {
    console.error("列数必须大于0");
    return "1fr";
  }
  return Array(columnCount).fill("1fr").join(" ");
}

@ComponentV2
export default struct MyBricksContainerWaterfall {
  @Param data: Data = new Data({
    rowKey: 'id',
    spacing: 0,
    layout: {
      type: "grid",
      column: 2,
      gutter: [8, 8],
      minHeight: 400
    },
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Local dataSource: Array<DataSourceItem> = []

  @Param slotsIO?: AnyType = undefined;
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
      WaterFlow() {
        ForEach(this.dataSource, (item: DataSourceItem, index) => {
          FlowItem() {
            this.slots({
              id: 'item',
              inputValues: { itemData: item, index }
            })
          }
          .width('100%')
        })
      }
      .columnsTemplate(generateColumnsTemplate(this.data?.layout?.column))
      .columnsGap(this.data.layout?.gutter[1])
      .rowsGap(this.data.layout?.gutter[0])

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
