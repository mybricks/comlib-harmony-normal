import {
  ApplyStyleModifier,
  ApplyRootStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'

interface SlotStyle {
  flexDirection: "column" | "row"
  justifyContent: 'flex-start' | 'center' | 'flex-end' | 'space-around' | 'space-between'
  alignItems: 'flex-start' | 'center' | 'flex-end'
  height: Length
  width: Length
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
    flexDirection: 'column',
    justifyContent: 'flex-start',
    alignItems: 'flex-start',
    height: 'fit-content',
    width: 'fit-content'
  };
  items: Item[] = [];

  constructor(config: DataType) {
    this.slotStyle = config?.slotStyle || {
      flexDirection: 'column',
      justifyContent: 'flex-start',
      alignItems: 'flex-start',
      height: 'fit-content',
      width: 'fit-content'
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

interface GeneratedObjectLiteralInterface_1 {
  direction: FlexDirection;
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
      columnStyle.width = item.width
    } else if (item.widthMode === 'percent') {
      columnStyle.width = `${item.width}%`
    }
    return columnStyle
  }

  getRootFlexOptions() {
    const flexOptions: FlexOptions = {}

    flexOptions.direction = this.data.slotStyle.flexDirection === "column" ? FlexDirection.Column : FlexDirection.Row

    switch (this.data.slotStyle.justifyContent) {
      case 'flex-start':
        flexOptions.justifyContent = FlexAlign.Start
        break
      case 'center':
        flexOptions.justifyContent = FlexAlign.Center
        break
      case 'flex-end':
        flexOptions.justifyContent = FlexAlign.End
        break
      case 'space-around':
        flexOptions.justifyContent = FlexAlign.SpaceAround
        break
      case 'space-between':
        flexOptions.justifyContent = FlexAlign.SpaceBetween
        break
      default:
        flexOptions.justifyContent = FlexAlign.Start
        break
    }

    switch (this.data.slotStyle.alignItems) {
      case 'flex-start':
        flexOptions.alignItems = ItemAlign.Start
        break
      case 'center':
        flexOptions.alignItems = ItemAlign.Center
        break
      case 'flex-end':
        flexOptions.alignItems = ItemAlign.End
        break
      default:
        flexOptions.alignItems = ItemAlign.Start
        break
    }

    return flexOptions
  }

  build() {
    Flex(this.getRootFlexOptions()) {
      ForEach(this.data.items, (item: Item) => {
        Column() {
          this.slots({
            id: item.id,
          })
        }
        .flexShrink(item.widthMode === 'auto' ? 1 : 0)
        .attributeModifier(
          new ColumnModifier(this.getColumnStyle(item))
        )
      })
    }
    .height(this.data.slotStyle.height)
    .width(this.data.slotStyle.width)
    .attributeModifier(
      new ApplyStyleModifier(this.styles[':root'])
    )
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
