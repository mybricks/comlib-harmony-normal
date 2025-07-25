import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

import { BasicStylesType, Styles } from "./types/Styles"

import { getStyleValueByPattern, parseLinearGradient } from './utils/StyleMatching'

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
}

@ObservedV2
export class Data implements DataType {
  @Trace text: string
  @Trace disabled: boolean = false

  constructor(config: DataType) {
    this.text = config.text
    this.disabled = config.disabled ?? false
  }
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

  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;

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

  build() {
    Button({ type: ButtonType.Normal }) {
      Text(this.data.text)
        .halfLeading(true)
        .attributeModifier(
          new ApplyFontStyleModifier(this.styles['.mybricks-button'])
            .fontSize(14)
            .fontColor('#ffffff')
        )
    }
    .type(ButtonType.Normal)
    .onClick(() => {
      this.outputs?.onClick(this.data.text)
    })
    .enabled(!this.data.disabled)
    .align(Alignment.Center)
    .attributeModifier(new ApplyStyleModifier(this.styles[this.data.disabled ? '.mybricks-button-disable' : '.mybricks-button']).borderRadius('50%').backgroundColor('#fa6400'))
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    //渐变色需要通过链式调用单独配置
    .linearGradient(parseLinearGradient(getStyleValueByPattern(this.styles,[this.data.disabled ? '.mybricks-button-disable' : '.mybricks-button'],'backgroundImage')))
  }
}
