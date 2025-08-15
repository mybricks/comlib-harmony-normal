import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'

import { parseBorder } from './utils/StyleMatching'

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

interface _Env {
  currentScenes: _EnvCurrentScenes
}

interface Env {
  currentScenes: EnvCurrentScenes
}

interface _EnvCurrentScenes {
  close: () => void
}


interface EnvCurrentScenes {
  close: () => void
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
export default struct MyBricksFormRadio {
  @Param data: Data = new Data()
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined
  @Param outputs?: Outputs = undefined
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Local activeValue: string | number = ''
  @Local ready: boolean = true
  @Local uniqueRroupId: string = String(Math.random())

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  @Computed
  get unSelectedStyle(): AnyType {
    const style = this.styles?.['.mybricks-inactive .taroify-icon'] ?? {}
    return {
      border: style?.border,
      backgroundColor: style?.backgroundColor,
      borderRadius: style?.borderRadius || '100%' //单选默认是圆形
    };
  }

  @Computed
  get selectedStyle(): AnyType {
    const style = this.styles?.['.mybricks-active .taroify-icon'] ?? {}
    return {
      border: style?.border,
      backgroundColor: style?.backgroundColor || '#1989FA',
      borderRadius: style?.borderRadius || '100%' //单选默认是圆形
    };
  }

  aboutToAppear(): void {

    const res = parseBorder(this.selectedStyle.border,'#1989FA',1)
    console.log("res",res)

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
      Flex({
        direction: this.data.direction === 'vertical' ? FlexDirection.Column : FlexDirection.Row,
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Start
      }) {
        ForEach(this.data.options, (item: Option, index: number) => {
          Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            // 自定义radio容器
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              // 选中时显示的圆点
              if (item.value === this.activeValue) {
                SymbolGlyph($r(`sys.symbol.checkmark`))
                  .fontSize(12)
                  .fontWeight(700)
                  .fontColor([Color.White])
                  .width("auto")
                  .height("auto")
              }
            }
            .width(20)
            .height(20)
            .borderRadius(item.value === this.activeValue
              ? this.selectedStyle.borderRadius
              : this.unSelectedStyle.borderRadius)
            .backgroundColor(item.value === this.activeValue
              ? this.selectedStyle.backgroundColor
              : this.unSelectedStyle.backgroundColor)
            .border(item.value === this.activeValue
                ? parseBorder(this.selectedStyle.border,'#1989FA',1)
                : parseBorder(this.unSelectedStyle.border,'#C2C2C2',1)
            )
            .onClick(() => {
              if (item.value !== this.activeValue) {
                this.activeValue = item.value;
                // 触发onChange事件
                this.outputs?.onChange(this.activeValue);
                this.parentSlot?._inputs?.["onChange"]?.({
                  id: this.uid,
                  value: this.activeValue,
                });
              }
            })

            Text(item.label)
              .margin({ left: 8 })
              .fontSize(13)
          }
          .width('auto')
          .margin({ right: this.data.gap, bottom: this.data.direction === 'vertical' ? 17 : 0 })
        })
      }
      .width('100%')
      .enabled(!this.data.disabled)
      .attributeModifier(
        new ApplyRootStyleModifier(this.styles['root'])
      )
      .attributeModifier(this.modifier)
    }
  }
}