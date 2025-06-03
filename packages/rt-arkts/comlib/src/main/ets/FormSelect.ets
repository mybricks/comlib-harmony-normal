import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  label?: string;
  name?: string;
  placeholder?: string;
  value?: string;
  options?: Option[];
}

interface Option {
  label: string;
  value: string;
  disabled?: boolean;
  checked?: boolean
}

@ObservedV2
export class Data implements DataType {
  @Trace label?: string
  @Trace name?: string
  @Trace placeholder?: string
  @Trace value?: string
  @Trace options?: Option[]

  constructor(config: DataType) {
    this.label = config?.label
    this.name = config?.name
    this.placeholder = config?.placeholder
    this.value = config?.value
    this.options = config?.options
  }
}

interface Inputs {
  setValue: (fn: (val: string, outputRels?: void) => void) => void
  getValue:  (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  setOptions:  (fn: (val: Option, outputRels?: AnyType) => void) => void
  setDisabled:(fn: (val: boolean, outputRels: void) => void) => void
}

interface Outputs {
  onChange: (value: string) => void
  onCancel: (value: string) => void
  setValueComplete: (value: string) => void
  returnValue: (value: string) => void
  resetValueComplete: (value: string) => void
  setOptionsComplete: (value: string) => void
  setDisabledComplete: (value: string) => void
}

@ComponentV2
export default struct MyBricksFormSelect {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Local selectedIndex?: number = 0

  aboutToAppear(): void {
    //连线设置下拉框值
    this.inputs?.setValue((val) => {
      this.data.value = String(val);
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.data.value);
    })

    this.inputs?.resetValue((_: AnyType, outputRels: AnyType) => {
      this.data.value = '';
      outputRels?.["resetValueComplete"]?.(this.data.value);
    })

    this.inputs?.setOptions((_: AnyType, outputRels: AnyType) => {
      this.data.options =  _
      outputRels?.["setOptionsComplete"]?.(this.data.options);
    })
  }

  build() {
    Column() {
      Select(this.data.options)
        .selected(this.selectedIndex)
        .value(this.data.value || this.data.placeholder)
        .font({ size: 13, weight: 400 })
        .selectedOptionFont({ size: 13, weight: 400 })
        .controlSize(ControlSize.NORMAL)
        .optionFont({ size: 13, weight: 400 })
        .fontColor(this.data.value ? '#182431' : '#B9B9B9')
        .space(8)
        .width("100%")
        .arrowPosition(ArrowPosition.END)
        .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
        .optionWidth(OptionWidthMode.FIT_TRIGGER)
        .borderRadius(5)
        .onSelect((index: number, value?: string | undefined) => {
          console.info('Select:' + index)
          this.selectedIndex = index;
          if (value) {
            this.data.value = value;
          }
        })
    }
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-select'])
    )
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
