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

  @Local value: string = this.data.value ?? ''
  @Local placeholder: string = this.data.placeholder ?? ''

  aboutToAppear(): void {
    this.inputs?.setValue((val, outputRels: AnyType) => {
      this.value = val;
      outputRels?.["setValueComplete"]?.(val);
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.value);
    })

    this.inputs?.resetValue((_: AnyType, outputRels: AnyType) => {
      this.value = '';
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
        text: this.value,
        placeholder: this.placeholder
      })
        .fontColor(getStyleValueByPattern(this.styles, [
          ".taroify-textarea__wrapper .mybricks-textarea,.taroify-textarea__wrapper .mybricks-h5Textarea .taroify-native-textarea",
        ],
          'color',
          '#323233'
        ))
        .fontSize(getStyleValueByPattern(this.styles, [
          ".taroify-textarea__wrapper .mybricks-textarea,.taroify-textarea__wrapper .mybricks-h5Textarea .taroify-native-textarea",
        ],
          'fontSize',
          12
        ))
        .placeholderColor(getStyleValueByPattern(this.styles, [
          ".taroify-textarea__wrapper .taroify-textarea__placeholder,.taroify-textarea__wrapper .mybricks-h5Textarea .taroify-native-textarea::placeholder",
        ],
          'color',
          '#C8C9CC'
        ))
        .placeholderFont({
          size: getStyleValueByPattern(this.styles, [
            ".taroify-textarea__wrapper .taroify-textarea__placeholder, .taroify-textarea__wrapper .mybricks-h5Textarea .taroify-native-textarea::placeholder",
          ],
            'fontSize',
            12
          )
        })
        .fontSize(14)
        .maxLength(this.shouldLimit ? 999999 : this.data.limit)
        .enabled(!this.data.disabled)
        .onChange((value: string) => {
          this.value = value;
          this.outputs?.onChange?.(value);

          this.parentSlot?._inputs?.["onChange"]?.({
            id: this.uid,
            value: this.value,
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
      if (this.data.showCount) {
        Text(`${this.value.length}/${this.data.limit}`).fontColor('#646566').fontSize(12).textAlign(TextAlign.End).margin({top:5})
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