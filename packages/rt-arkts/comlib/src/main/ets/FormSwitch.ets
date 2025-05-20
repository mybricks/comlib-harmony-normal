import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

// Data 接口定义
export interface DataType {
  label: string
  hideLabel: boolean
  name: string
  value: boolean
  type: 'switch' | 'checkbox'
}

// Data 类实现
@ObservedV2
export class Data implements DataType {
  @Trace label: string
  @Trace hideLabel: boolean
  @Trace name: string
  @Trace value: boolean
  @Trace type: 'switch' | 'checkbox'
  @Trace disabled: boolean = false

  constructor(config?: Partial<DataType>) {
    // 默认值
    this.label = config?.label ?? '开关'
    this.hideLabel = config?.hideLabel ?? false
    this.name = config?.name ?? '开关'
    this.value = config?.value ?? false
    this.type = config?.type ?? 'switch'
  }
}

// 其他接口定义保持不变
interface Inputs {
  setValue: (fn: (val: boolean, outputRels?: void) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  setLabel: (fn: (val: string) => void) => void
  setDisabled: (fn: (val: boolean, outputRels: void) => void) => void
}

interface Outputs {
  onChange: (value: boolean) => void
  setValueComplete: (value: boolean) => void
  returnValue: (value: boolean) => void
  resetValueComplete: (value: boolean) => void
  setDisabledComplete: (value: boolean) => void
}

@ComponentV2
export default struct MyBricksFormSwitch {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

  aboutToAppear(): void {
    this.inputs?.setValue((val, outputRels: AnyType) => {
      this.data.value = !!val;
      outputRels?.["setValueComplete"]?.(!!val);
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.data.value);
    })

    this.inputs?.resetValue((_: AnyType, outputRels: AnyType) => {
      this.data.value = false;
      outputRels?.["resetValueComplete"]?.(false);
    })
  }

  build() {
    Column() {
      Toggle({ type: this.data.type === 'checkbox' ? ToggleType.Checkbox : ToggleType.Switch, isOn: !!this.data.value })
        .onChange((isOn) => {
          this.data.value = isOn;
          this.outputs?.onChange?.(isOn)
        })
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}