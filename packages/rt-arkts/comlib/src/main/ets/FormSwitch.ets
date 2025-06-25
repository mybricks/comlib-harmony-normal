import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

// Data 接口定义
export interface DataType {
  label: string
  hideLabel: boolean
  name: string
  value: boolean
  type: 'switch' | 'checkbox'
  backgroundColor: string
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
  @Trace backgroundColor: string = ''

  constructor(config?: Partial<DataType>) {
    // 默认值
    this.label = config?.label ?? '开关'
    this.hideLabel = config?.hideLabel ?? false
    this.name = config?.name ?? '开关'
    this.value = config?.value ?? false
    this.type = config?.type ?? 'switch'
    this.backgroundColor = config?.backgroundColor ?? ''
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
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Local switchColor?: AnyType = "#FA6400"

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

    //获取开关颜色
    const style = this.styles['.taroify-switch--checked']
    this.switchColor = style.backgroundColor
  }

  build() {
    Column() {
      Toggle({ type: this.data.type === 'checkbox' ? ToggleType.Checkbox : ToggleType.Switch, isOn: !!this.data.value })
        .onChange((isOn) => {
          this.data.value = isOn;
          this.outputs?.onChange?.(isOn)

          this.parentSlot?._inputs?.["onChange"]?.({
            id: this.uid,
            value:this.data.value,
          });
        })
        .selectedColor(this.switchColor)
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}