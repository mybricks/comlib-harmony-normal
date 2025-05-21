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
  maxlength: number,
  clearable?: boolean
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
  @Trace maxlength: number
  @Trace clearable: boolean

  constructor(config?: DataType) {
    this.hideLabel = config?.hideLabel ?? false
    this.label = config?.label ?? '密码输入'
    this.name = config?.name ?? '密码输入'
    this.value = config?.value ?? ''
    this.placeholder = config?.placeholder ?? '请输入密码'
    this.type = config?.type ?? 'text'
    this.disabled = config?.disabled ?? false
    this.required = config?.required ?? false
    this.hidden = config?.hidden ?? false
    this.maxlength = config?.maxlength ?? 50
    this.clearable = config?.clearable ?? false
  }
}

interface Inputs {
  setValue: (fn: (val: string, outputRels?: void) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  setLabel: (fn: (val: string) => void) => void
  setDisabled: (fn: (val: boolean, outputRels: void) => void) => void
  setEnabled: (fn: (val: boolean, outputRels: void) => void) => void
  setPlaceholder: (fn: (val: string) => void) => void
}

interface Outputs {
  onChange: (value: string) => void
  onBlur: (value: string) => void
  onConfirm: (value: string) => void
  setValueComplete: (value: string) => void
  returnValue: (value: string) => void
  resetValueComplete: (value: string) => void
}

@ComponentV2
export default struct MyBricksFormPassword {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

  aboutToAppear(): void {
    this.inputs?.setDisabled((val, outputRels: AnyType) => {
      this.data.disabled = true;
    })

    this.inputs?.setEnabled((val, outputRels: AnyType) => {
      this.data.disabled = false;
    })

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

  @Computed
  get placeHolderStyle(): AnyType {
    const style = this.styles?.['.mybricks-password .taroify-input__placeholder,.mybricks-h5Password .taroify-native-input::placeholder'] ?? {}
    return {
      color: style?.color,
      fontSize: parseFloat(style?.fontSize as string)
    };
  }

  build() {
    Column() {
      TextInput({
        text: this.data.value,
        placeholder: this.data.placeholder
      })
        .type(InputType.Password)
        .placeholderColor(this.placeHolderStyle?.color ?? '#999999')
        .placeholderFont({
          size: this.placeHolderStyle?.fontSize || 14
        })
        .height('100%')
        .maxLength(this.data.maxlength)
        .enabled(!this.data.disabled)
        .contentType(ContentType.PASSWORD)
        .onChange((value: string) => {
          this.data.value = value;
          this.outputs?.onChange?.(value);
        })
        .layoutWeight(1)  // 输入框占剩余空间
        .attributeModifier(
          new ApplyFontStyleModifier(this.styles['.mybricks-password .taroify-input,.mybricks-h5Password .taroify-input .taroify-native-input'])
            .fontSize(14)
            .fontColor('#000000')
        )
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-password,.mybricks-h5Password'])
            .backgroundColor(Color.Transparent)
        )
    }.attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}