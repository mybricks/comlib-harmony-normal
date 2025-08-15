import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

import { getStyleValueByPattern, parseLinearGradient } from './utils/StyleMatching'

export interface DataType {
  scope: string,
  type: string,
  icon?: string,
  fontColor?: string[],
  fontSize?: number,
  fontWeight?: number
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
  onClick: () => void
}

//这些图标是长方形，需要单独进行判断然后Width配置为"auto"
const non_square_icon = [
  "chevron_down",
  "chevron_left",
  "chevron_right",
  "chevron_up"
]

@ComponentV2
export default struct MyBricksIcon {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  aboutToAppear(): void {
  }

  build() {
    Column() {
      SymbolGlyph($r(`sys.symbol.${this.data.icon}`))
        .fontSize(this.data.fontSize)
        .fontWeight(this.data.fontWeight)
        .fontColor([this.data.fontColor?.[0], Color.White])
        .renderingStrategy(SymbolRenderingStrategy.SINGLE)
        .width(non_square_icon.includes(this.data.icon) ? 'auto' : this.data.fontSize)
        .height(this.data.fontSize)
        .alignSelf(ItemAlign.Center)
        .align(Alignment.Center)
        .renderFit(RenderFit.CENTER)
    }
    .width('100%')  // 确保Column有宽度
    .height('100%') // 确保Column有高度
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(()=>{
      this.outputs?.onClick()
    })
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-icon'])
    )
    .linearGradient(parseLinearGradient(getStyleValueByPattern(this.styles,['.mybricks-icon'],'backgroundImage')))
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(this.modifier)
  }
}
