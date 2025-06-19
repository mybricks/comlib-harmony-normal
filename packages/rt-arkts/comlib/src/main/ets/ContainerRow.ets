import {
  ApplyRootStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'

interface SlotStyle {
  flexDirection: "column" | "row"
}
interface Item {
  id: string;
  widthMode: "number" | "auto" | "fit-content" | "percent"
  slotStyle: CSSProperties
  width?: "fit-content" | number | string
}
export interface DataType {
  slotStyle?: SlotStyle
  items?: Item[]
}

@ObservedV2
export class Data implements DataType {
  slotStyle: SlotStyle = {
    flexDirection: 'column'
  };
  items: Item[] = [];

  constructor(config: DataType) {
    this.slotStyle = config?.slotStyle || {
      flexDirection: 'column'
    }
    this.items = config.items || []
  }
}

interface Inputs {}

interface Outputs {}

export interface SlotsParams {
  id: string,
  style?: CSSProperties
}

@Builder
function emptySlot(params: SlotsParams) {
}

interface ColumnStyle {
  flex?: number;
  width?: "fit-content" | number | string;
}

type Style = Record<string, string | number>;
type Styles = Record<string, Style>;

class ColumnModifier implements AttributeModifier<ColumnAttribute> {
  style: ColumnStyle;

  constructor(style: ColumnStyle) {
    this.style = style;
  }

  applyNormalAttribute(instance: ColumnAttribute): void {
    const style = this.style;

    if (style.width || (typeof style.width === "number")) {
      instance.width(style.width)
    }

    if (style.flex) {
      instance.flexGrow(style.flex)
      instance.flexShrink(1)
      instance.flexBasis("0%")
    }
  }
}

@ComponentV2
export default struct MyBricksContainerRow {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;

  aboutToAppear(): void {

  }

  getColumnStyle(item: Item) {
    const columnStyle: ColumnStyle = {}
    if (item.widthMode === 'auto') {
      columnStyle.flex = 1
    } else if (item.widthMode === 'fit-content') {
      columnStyle.width = 'fit-content'
    } else if (item.widthMode === 'number') {
      // widthLayout.width = item.width
    } else if (item.widthMode === 'percent') {
      columnStyle.width = `${item.width}%`
    }
    return columnStyle
  }

  build() {
    Flex({
      direction: this.data.slotStyle.flexDirection === "column" ? FlexDirection.Column : FlexDirection.Row
    }) {
      ForEach(this.data.items, (item: Item) => {
        Column() {
          this.slots({
            id: item.id,
          })
        }
        .attributeModifier(
          new ColumnModifier(this.getColumnStyle(item))
        )
      })
    }
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
