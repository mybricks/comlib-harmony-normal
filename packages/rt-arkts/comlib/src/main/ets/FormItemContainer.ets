import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

type InputAlignType = 'left' | 'right' | 'center';

function convertInputAlignToTextAlign(align: InputAlignType): TextAlign {
  switch (align) {
    case 'left':
      return TextAlign.Start;
    case 'right':
      return TextAlign.End;
    case 'center':
      return TextAlign.Center;
    default:
      return TextAlign.Start;
  }
}

export interface DataType {
  disabled: boolean,
  value: string,
}

@ObservedV2
export class Data implements DataType {
  @Trace disabled: boolean
  @Trace value: string

  constructor(config?: DataType) {
    this.disabled = config?.disabled ?? false
    this.value = config?.value ?? ''
  }
}

interface Inputs {
  setValue: (fn: (val: string, outputRels?: void) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
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
  setDisabledSuccess: (value: string) => void
  setEnabledSuccess: (value: string) => void
}

interface ItemParamsInputValues {
  curValue: AnyType
}

export interface SlotsParamsItem {
  id: string,
  inputValues: ItemParamsInputValues
  outputs: AnyType
}

@Builder function emptySlot(params: SlotsParamsItem) {}

@ComponentV2
export default struct MyBricksFormInput {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParamsItem) => void = emptySlot;

  aboutToAppear(): void {
    this.inputs?.setDisabled((val, outputRels: AnyType) => {
      this.data.disabled = true;
    })

    this.inputs?.setEnabled((val, outputRels: AnyType) => {
      this.data.disabled = false;
    })

    this.inputs?.setValue((val, outputRels: AnyType) => {
      this.data.value = val;
      this.slotsIO?.formItem?.inputs?.curValue?.(this.data.value);
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.data.value);
    })
  }


  build() {
    Column() {
      this.slots({
        id: 'formItem',
        inputValues: {
          curValue: this.slotsIO?.formItem?.inputs?.curValue
        },
        outputs: {
          setCurValue: this.slotsIO?.formItem?.outputs?.setCurValue?.((value: AnyType) => {
            this.data.value = value;

            this.parentSlot?._inputs["onChange"]?.({
              id: this.uid,
              value,
            });

            this.outputs?.onChange?.(value);
          })
        }
      })
    }.attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}

