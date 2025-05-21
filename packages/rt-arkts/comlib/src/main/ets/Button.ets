import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

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

@ComponentV2
export default struct MyBricksButton {
  @Param data: Data = new Data({
    text: '按钮'
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

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
      this.data.text = text;
    })
  }

  build() {
    Button({ type: ButtonType.Normal }) {
      Text(this.data.text)
        .attributeModifier(
          new ApplyFontStyleModifier(this.styles['.mybricks-button'])
            .fontSize(14)
            .fontColor('#ffffff')
        )
    }
    .height(40)
    .padding({
      top: 0,
      bottom: 0,
      left: 14,
      right: 14
    })
    .onClick(() => {
      if (this.data.disabled) {
        return
      }
      this.outputs?.onClick(this.data.text)
    })
    .attributeModifier(new ApplyStyleModifier(this.styles[this.data.disabled ? '.mybricks-button-disable' : '.mybricks-button']).borderRadius('50%').backgroundColor('#fa6400'))
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
