import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

// Data Option 接口定义
export interface Option {
  label: string
  value: string | number
  icon?: string
  brief?: string
  checked?: boolean
}

// Data 接口定义
export interface DataType {
  options: Option[]
  direction: 'horizontal' | 'vertical'
  disabled: boolean
  gap: number
  columns?: number
  defaultRenderMode?: string
}

// Data 类实现
@ObservedV2
export class Data implements DataType {
  @Trace options: Option[] = []
  @Trace direction: 'horizontal' | 'vertical' = 'horizontal'
  @Trace disabled: boolean = false
  @Trace gap: number = 8
  @Trace columns?: number
  @Trace defaultRenderMode?: string

  constructor(config?: Partial<DataType>) {
    this.options = config?.options ?? []
    this.direction = config?.direction ?? 'horizontal'
    this.disabled = config?.disabled ?? false
    this.gap = config?.gap ?? 8
    this.columns = config?.columns
    this.defaultRenderMode = config?.defaultRenderMode
  }
}

// 接口定义
interface Inputs {
  setValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  setLabel: (fn: (val: string) => void) => void
  setOptions: (fn: (val: Option[]) => void) => void
  setDisabled: (fn: (val: boolean, outputRels: AnyType) => void) => void
}

interface Outputs {
  onChange: (value: string | number) => void
  setValueComplete: (value: string | number) => void
  returnValue: (value: string | number) => void
  resetValueComplete: (value: string) => void
  setDisabledComplete: (value: boolean) => void
}


@ComponentV2
export default struct MyBricksFormRadio{
  @Param data: Data = new Data()
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined
  @Param outputs?: Outputs = undefined

  @Local activeValue: string | number = ''
  @Local ready: boolean = true

  @Local uniqueRroupId: string = String(Math.random())

  @Computed
  get unSelectedStyle(): AnyType {
    const style = this.styles?.['.mybricks-inactive .taroify-icon'] ?? {}
    return {
      borderColor: style?.borderColor,
      backgroundColor: style?.backgroundColor
    };
  }

  @Computed
  get selectedStyle(): AnyType {
    const style = this.styles?.['.mybricks-active .taroify-icon'] ?? {}
    return {
      borderColor: style?.borderColor,
      backgroundColor: style?.backgroundColor
    };
  }

  aboutToAppear(): void {
    // 初始化值
    this.inputs?.setValue((val: AnyType, outputRels: AnyType) => {
      if (val === null || val === undefined) {
        this.activeValue = ''
      } else if (typeof val === 'string' || typeof val === 'number') {
        this.activeValue = val
      }
      outputRels?.['setValueComplete']?.(this.activeValue)
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.['returnValue'](this.activeValue)
    })

    this.inputs?.resetValue((_: AnyType, outputRels: AnyType) => {
      this.activeValue = ''
      outputRels?.['resetValueComplete']?.('')
    })

    this.ready = this.data.defaultRenderMode === "dynamic" ? false : true
    this.inputs?.setOptions((val) => {
      if (Array.isArray(val)) {
        this.data.options = val
        this.ready = true

        const checkedItem = val.filter(item => item.checked).pop()
        if (checkedItem) {
          this.activeValue = checkedItem.value
        }
      }
    })

    this.inputs?.setDisabled?.((val, outputRels: AnyType) => {
      this.data.disabled = !!val
      outputRels?.['setDisabledComplete']?.(this.data.disabled)
    })
  }

  build() {
    if (this.ready) {
      Flex({ direction: this.data.direction === 'vertical' ? FlexDirection.Column : FlexDirection.Row }) {
        ForEach(this.data.options, (item: Option, index: number) => {
          Radio({ value: item.label, group: this.uniqueRroupId })
            .checked(item.value === this.activeValue)
            .radioStyle({
              checkedBackgroundColor: this.selectedStyle.backgroundColor,
              uncheckedBorderColor: this.unSelectedStyle.borderColor
            })
            .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.activeValue = item.value
                  this.outputs?.onChange(item.value)
                }
            })
        })
      }
      .width('100%')
      .enabled(!this.data.disabled)
      .attributeModifier(
        new ApplyRootStyleModifier(this.styles['root'])
      )
    }
  }
}