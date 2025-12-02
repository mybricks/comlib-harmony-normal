import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

import { BasicStylesType, Styles } from "./types/Styles"
import { getStyleValueByPattern, parseLinearGradient, parseMargin, parseSize } from './utils/StyleMatching'

interface MyBricksButtonStyles {
  color: Styles.Color
  fontSize: Styles.FontSize
  fontWeight: Styles.FontWeight
  backgroundColor: Styles.BackgroundColor
  borderRadius: Styles.BorderRadius
  border: Styles.Border
  borderTop: Styles.BorderTop
  borderLeft: Styles.BorderLeft
  borderRight: Styles.BorderRight
  borderBottom: Styles.BorderBottom
  backgroundSize: Styles.BackgroundSize
  backgroundImage: Styles.BackgroundImage
}

export interface StylesType extends BasicStylesType {
  ".mybricks-button"?: Partial<MyBricksButtonStyles>
  ".mybricks-button-disable"?: Partial<MyBricksButtonStyles>
}

export interface DataType {
  text: string
  disabled?: boolean
  showIcon?: boolean
  useImageIcon?: boolean
  imageIcon?: string
  icon?: string
  iconSize?: number
  iconMargin?: number
  iconColor?: string[]
  iconPosition?: string
}

@ObservedV2
export class Data implements DataType {
  @Trace text: string
  @Trace disabled: boolean = false
  @Trace showIcon: boolean = false
  @Trace useImageIcon: boolean = false
  @Trace imageIcon?: string
  @Trace icon: string = 'plus'
  @Trace iconSize: number = 14
  @Trace iconMargin: number = 8
  @Trace iconColor: string[] = ["#fff"]
  @Trace iconPosition: string = "left"

  constructor(config: DataType) {
    this.text = config.text
    this.disabled = config.disabled ?? false
    this.showIcon = config.showIcon ?? false
    this.useImageIcon = config.useImageIcon ?? false
    this.icon = config.icon ?? 'plus'
    this.iconSize = config.iconSize ?? 14
    this.iconMargin = config.iconMargin ?? 8
    this.iconColor = config.iconColor ?? ["#fff"]
    this.iconPosition = config.iconPosition ?? "left"
    this.imageIcon = config.imageIcon
  }
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

interface Inputs {
  buttonText: (fn: (text: string) => void) => void
  setDisabled: (fn: (val: boolean, outputRels: void) => void) => void
  setEnabled: (fn: (val: boolean, outputRels: void) => void) => void
}

interface Outputs {
  onClick: (value: string) => void
  setDisabledSuccess: (value: string) => void
  setEnabledSuccess: (value: string) => void
}

export interface SlotsParams {
  id: string,
  style?: CSSProperties
}

@Builder function emptySlot(params: SlotsParams) {}

@ComponentV2
export default struct MyBricksButton {
  @Param data: Data = new Data({
    text: '按钮'
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;
  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  aboutToAppear(): void {

    this.inputs?.setDisabled((val, outputRels: AnyType) => {
      this.data.disabled = !!val;
      outputRels?.["setDisabledSuccess"]?.(val);
    })

    this.inputs?.setEnabled((val, outputRels: AnyType) => {
      this.data.disabled = false;
      outputRels?.["setEnabledSuccess"]?.(val);
    })

    this.inputs?.buttonText((text) => {
      this.data.text = String(text);
    })
  }

  @Builder iconDom() {
    if (this.data.showIcon) {
      if (this.data.useImageIcon) {
        Image(this.data.imageIcon)
          .attributeModifier(
            new ApplyStyleModifier(this.styles['.mybricks-button-image-icon'])
          )
          .width(parseSize(this.styles['.mybricks-button-image-icon'].width) ?? 14)
          .height(parseSize(this.styles['.mybricks-button-image-icon'].height) ?? 14)
          .margin(parseMargin(this.styles['.mybricks-button-image-icon']))
      } else {
        SymbolGlyph($r(`sys.symbol.${this.data.icon}`))
          .fontWeight(400)
          .fontSize(this.data.iconSize)
          .fontColor([this.data.iconColor?.[0], Color.White])
          .renderingStrategy(SymbolRenderingStrategy.SINGLE)
          .width(this.data.iconSize)
          .height(this.data.iconSize)
          .alignSelf(ItemAlign.Center)
          .align(Alignment.Center)
          .renderFit(RenderFit.CENTER)
          .margin(this.data.iconPosition === 'right' ? {left: this.data.iconMargin} : {right: this.data.iconMargin})
      }
    }
  }

  build() {
    Button({ type: ButtonType.Normal }) {
      Row() {
        this.iconDom()
        Text(this.data.text)
          .halfLeading(true)
          .attributeModifier(
            new ApplyFontStyleModifier(this.styles['.mybricks-button'], 'text')
              .fontSize(14)
              .fontColor('#ffffff')
          )
      }
      .reverse(this.data.iconPosition === 'right')
      .alignItems(VerticalAlign.Center)
    }
    .type(ButtonType.Normal)
    .onClick(() => {
      this.outputs?.onClick(this.data.text)
    })
    .enabled(!this.data.disabled)
    .align(Alignment.Center)
    .attributeModifier(new ApplyStyleModifier(this.styles[this.data.disabled ? '.mybricks-button-disable' : '.mybricks-button'], 'button').borderRadius('50%').backgroundColor('#fa6400'))
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    //渐变色需要通过链式调用单独配置
    .linearGradient(parseLinearGradient(getStyleValueByPattern(this.styles,[this.data.disabled ? '.mybricks-button-disable' : '.mybricks-button'],'backgroundImage')))
    .attributeModifier(this.modifier)
  }
}
