import { CounterType, CounterComponent } from '@kit.ArkUI';
import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

// Data 接口定义
export interface DataType {
  label: string
  hideLabel: boolean
  name: string
  value: number
  min: number,
  max: number,
  step: number
}

// Data 类实现
@ObservedV2
export class Data implements DataType {
  @Trace label: string
  @Trace hideLabel: boolean
  @Trace name: string
  @Trace value: number
  @Trace min: number
  @Trace max: number
  @Trace step: number
  @Trace disabled: boolean = false

  constructor(config?: Partial<DataType>) {
    // 默认值
    this.label = config?.label ?? '开关'
    this.hideLabel = config?.hideLabel ?? false
    this.name = config?.name ?? '开关'
    this.value = config?.value ?? 0
    this.min = config?.min ?? 0
    this.max = config?.max ?? 999
    this.step = config?.step ?? 1
  }
}

// 其他接口定义保持不变
interface Inputs {
  setValue: (fn: (val: number, outputRels?: void) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  setLabel: (fn: (val: string) => void) => void
  setDisabled: (fn: (val: boolean, outputRels: void) => void) => void
}

interface Outputs {
  onChange: (value: number) => void
  setValueComplete: (value: boolean) => void
  returnValue: (value: number) => void
  resetValueComplete: (value: boolean) => void
  setDisabledComplete: (value: boolean) => void
}

@ComponentV2
export default struct MyBricksFormStepper {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  aboutToAppear(): void {
    this.inputs?.setValue((val, outputRels: AnyType) => {
      this.data.value = val;
      outputRels?.["setValueComplete"]?.(!!val);
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.data.value);
    })

    this.inputs?.resetValue((_: AnyType, outputRels: AnyType) => {
      this.data.value = 0;
      outputRels?.["resetValueComplete"]?.(false);
    })
  }

  build() {
    Column() {
      CounterComponent({
        options: {
          type: CounterType.LIST,
          numberOptions: {
            min: this.data.min,
            value: this.data.value,
            max: this.data.max,
            onChange: (value: number) => {
              this.data.value = value
              this.outputs?.onChange?.(value)

              this.parentSlot?._inputs?.["onChange"]?.({
                id: this.uid,
                value:this.data.value,
              });
            }
          },
        }
      })
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}