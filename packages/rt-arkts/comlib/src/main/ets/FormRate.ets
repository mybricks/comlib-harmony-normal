import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { isEmpty, isString, isNumber, isObject } from './utils/Helper'

export interface DataType {
  label: string
  name: string
  count: number
  allowHalf: boolean
  disabled: boolean
}

@ObservedV2
export class Data implements DataType {
  @Trace label: string
  @Trace name: string
  @Trace count: number
  @Trace allowHalf: boolean
  @Trace disabled: boolean

  constructor(config?: DataType) {
    this.label = config?.label ?? '评分'
    this.name = config?.name ?? 'rate'
    this.count = config?.count ?? 5
    this.allowHalf = config?.allowHalf ?? false
    this.disabled = config?.disabled ?? false
  }
}

interface Inputs {
  setValue: (fn: (val: AnyType, outputRels?: void) => void) => void
  setDisabled: (fn: (val: boolean, outputRels: void) => void) => void
}

interface Outputs {
  onChange: (value: number) => void
}

@ComponentV2
export default struct MyBricksRate {
  @Param data: Data = new Data()
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined
  @Param outputs?: Outputs = undefined
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  
  @Local value: number = 0

  aboutToAppear(): void {
    // 处理输入事件
    this.inputs?.setValue((val: AnyType, outputRels: AnyType) => {
      switch (true) {
        case isEmpty(val): {
          this.value = 0
          break
        }
        case isString(val) || isNumber(val):
          this.value = Number(val)
          break
        case isObject(val):
          this.value = Number(val[this.data.name])
          break
        default:
          break
      }
    })

    this.inputs?.setDisabled((val) => {
      this.data.disabled = !!val
    })
  }

  onChange = (val: number) => {
    this.value = val;
    this.outputs?.onChange?.(val)
  }

  build() {
    Column() {
      Rating({
        rating: this.value,
        indicator: false,
      })
        .stepSize(this.data.allowHalf ? 0.5 : 1)
        .stars(this.data.count)
        .enabled(!this.data.disabled)
        .onChange(this.onChange)
    }
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}