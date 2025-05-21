import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  hideLabel: boolean,
  label: string,
  name: string,
  value: string,
  placeholder: string,
  type: string,
  disabled: boolean,
  required: boolean,
  hidden: boolean,
  autoHeight: boolean,
  limit: number
}

@ObservedV2
export class Data implements DataType {
  @Trace hideLabel: boolean
  @Trace label: string
  @Trace name: string
  @Trace value: string
  @Trace placeholder: string
  @Trace type: string
  @Trace disabled: boolean
  @Trace required: boolean
  @Trace hidden: boolean
  @Trace autoHeight: boolean
  @Trace limit: number

  constructor(config?: DataType) {
    this.hideLabel = config?.hideLabel ?? false
    this.label = config?.label ?? '多行输入'
    this.name = config?.name ?? '多行输入'
    this.value = config?.value ?? ''
    this.placeholder = config?.placeholder ?? '请输入内容'
    this.type = config?.type ?? 'text'
    this.disabled = config?.disabled ?? false
    this.required = config?.required ?? false
    this.hidden = config?.hidden ?? false
    this.autoHeight = config?.autoHeight ?? false
    this.limit = config?.limit ?? 100
  }
}

interface Inputs {
  setValue: (fn: (val: string, outputRels?: void) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  setLabel: (fn: (val: string) => void) => void
  setDisabled: (fn: (val: boolean, outputRels: void) => void) => void
  setPlaceholder: (fn: (val: string) => void) => void
}

interface Outputs {
  onChange: (value: string) => void
  onBlur: (value: string) => void
  onConfirm: (value: string) => void
  setValueComplete: (value: string) => void
  returnValue: (value: string) => void
  resetValueComplete: (value: string) => void
  setDisabledComplete: (value: string) => void
}

@ComponentV2
export default struct MyBricksFormTextarea {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

  aboutToAppear(): void {
    this.inputs?.setValue((val, outputRels: AnyType) => {
      this.data.value = val;
      outputRels?.["setValueComplete"]?.(val);
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.data.value);
    })

    this.inputs?.resetValue((_: AnyType, outputRels: AnyType) => {
      this.data.value = '';
      outputRels?.["resetValueComplete"]?.('');
    })

    this.inputs?.setPlaceholder((val) => {
      this.data.placeholder = val;
    })
  }

  build() {
    Column() {
      TextArea({
        text: this.data.value,
        placeholder: this.data.placeholder
      })
        .placeholderColor('#999999')
        .height('100%')
        .fontSize(14)
        .maxLength(this.data.limit)
        .enabled(!this.data.disabled)
        .onChange((value: string) => {
          this.data.value = value;
          this.outputs?.onChange?.(value);
        })
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.taroify-textarea__wrapper'])
            .backgroundColor(Color.Transparent)
        )
    }.attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}