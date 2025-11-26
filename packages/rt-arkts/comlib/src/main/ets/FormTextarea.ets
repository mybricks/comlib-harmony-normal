import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'

import { getStyleValueByPattern, parseLinearGradient } from './utils/StyleMatching'

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
  showCount?: boolean
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
  @Trace showCount?: boolean = false

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
    this.showCount = config?.showCount ?? false
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
  onFocus: (value: string) => void
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
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  // @Local value: string = this.data.value ?? ''

  // @Monitor ('data.value')
  // onDataValueChange(monitor: IMonitor) {
  //   this.value = monitor.value()?.now as string
  // }

  @Local placeholder: string = this.data.placeholder ?? ''

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
      this.placeholder = val;
    })
  }

  @Computed
  get shouldLimit () {
    return this.data.limit !== 0 && this.data.limit !== undefined
  }

  build() {
    Column() {
      TextArea({
        text: this.data.value,
        placeholder: this.placeholder
      })
        .placeholderColor(getStyleValueByPattern(this.styles, [
          ".taroify-textarea__wrapper .taroify-textarea__placeholder",
        ],
          'color',
          '#C8C9CC'
        ))
        .placeholderFont({
          size: getStyleValueByPattern(this.styles, [
            ".taroify-textarea__wrapper .taroify-textarea__placeholder",
          ],
            'fontSize',
            14
          )
        })
        .attributeModifier(
          new ApplyFontStyleModifier(this.styles?.['.taroify-textarea__wrapper .mybricks-textarea'] || {})
            .fontSize(14)
            .fontColor('#323233')
        )
        .maxLength(this.shouldLimit ? 999999 : this.data.limit)
        .enabled(!this.data.disabled)
        .onChange((value: string) => {
          this.data.value = value
          // this.value = value;
          this.outputs?.onChange?.(value);

          this.parentSlot?._inputs?.["onChange"]?.({
            id: this.uid,
            value: this.data.value,
          });
        })
        .flexGrow(1) // 占用剩余空间
        .flexShrink(1) // 允许收缩（防止溢出）
        .width('100%')
        .backgroundColor(Color.Transparent)
        .borderRadius(0)
        .padding({
          left: 0,
          right: 0,
          bottom: 0,
          top: 0
        })
        .onBlur(() => {
          this.outputs?.onBlur?.(this.data.value)
        })
        .onFocus(() => {
          this.outputs?.onFocus?.(this.data.value)
        })
      if (this.data.showCount) {
        Text(`${this.data.value.length}/${this.data.limit}`).fontColor('#646566').fontSize(12).textAlign(TextAlign.End).margin({top:5})
      }
    }
    .attributeModifier(
      new ApplyStyleModifier(this.styles?.['.taroify-textarea__wrapper'] || {})
        .backgroundColor(Color.Transparent)
    )
    .alignItems(HorizontalAlign.End)
    .height('100%')
    .width('100%')
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'] || {})
    )
    .attributeModifier(this.modifier)

  }
}