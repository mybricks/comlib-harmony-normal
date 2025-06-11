import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  scope: string,
  type: string,
  icon?: string,
  fontColor?: string[],
  fontSize?: number,
  fontWeight?: number
}

@ObservedV2
export class Data implements DataType {
  @Trace scope: string = 'system'
  @Trace type: string = 'single'
  @Trace icon?: string
  @Trace fontColor?: string[]
  @Trace fontSize?: number
  @Trace fontWeight?: number

  constructor(config?: DataType) {
    this.scope = config?.scope ?? 'system'
    this.type = config?.type ?? 'single'
    this.icon = config?.icon
    this.fontColor = config?.fontColor ?? ['#000000']
    this.fontSize = config?.fontSize ?? 24
    this.fontWeight = config?.fontWeight ?? 400
  }
}

interface Inputs {

}

interface Outputs {

}

@ComponentV2
export default struct MyBricksIcon {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  aboutToAppear(): void {

  }

  build() {
    SymbolGlyph($r(`sys.symbol.ohos_${this.data.icon}`))
      .fontSize(this.data.fontSize)
      .fontWeight(this.data.fontWeight)
      .fontColor([this.data.fontColor?.[0], Color.White])
      .renderingStrategy(SymbolRenderingStrategy.SINGLE)
      .attributeModifier(
        new ApplyRootStyleModifier(this.styles['root'])
      )
  }
}
