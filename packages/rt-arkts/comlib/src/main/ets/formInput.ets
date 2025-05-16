import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './styles/getDesignStyle'

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
  hideLabel: boolean,
  label: string,
  name: string,
  value: string,
  placeholder: string,
  type: string,
  disable: boolean,
  required: boolean,
  hidden: boolean,
  maxlength: number,
  inputAlign: InputAlignType
}

@ObservedV2
export class Data implements DataType {
  @Trace hideLabel: boolean
  @Trace label: string
  @Trace name: string
  @Trace value: string
  @Trace placeholder: string
  @Trace type: string
  @Trace disable: boolean
  @Trace required: boolean
  @Trace hidden: boolean
  @Trace maxlength: number
  @Trace inputAlign: InputAlignType

  constructor(config: DataType) {
    this.hideLabel = config.hideLabel
    this.label = config.label
    this.name = config.name
    this.value = config.value
    this.placeholder = config.placeholder
    this.type = config.type
    this.disable = config.disable
    this.required = config.required
    this.hidden = config.hidden
    this.maxlength = config.maxlength
    this.inputAlign = config.inputAlign
  }
}

interface Inputs {
  setValue: (fn: (setValue: string) => void) => void
  getValue:(fn: (getValue: string) => void) => void
  resetValue:(fn: (resetValue: string) => void) => void
  setLabel:(fn: (setLabel: string) => void) => void
  setDisabled:(fn: (setDisabled: string) => void) => void
  setPlaceholder: (fn: (setPlaceholder: string) => void) => void
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
export default struct Mybricks_FormInput {
  // 修改这里的默认值，确保包含所有必需的属性
  @Param data: Data = new Data({
    hideLabel: false,
    label: '',
    name: '',
    value: '',
    placeholder: '请输入内容',
    type: 'text',
    disable: false,
    required: false,
    hidden: false,
    maxlength: 50,
    inputAlign: 'left'
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

  aboutToAppear(): void {
    this.inputs?.setValue((val) => {
      this.data.value = val;
    })
    this.inputs?.setPlaceholder((val) => {
      this.data.placeholder = val;
    })
  }

  build() {
    Column() {
      if (!this.data.hidden) {  // 只在不隐藏时显示
        Row() {  // 使用Row来实现左右布局
          if (!this.data.hideLabel) {  // 如果不隐藏标签则显示标签
            Row() {
              Text(this.data.required ? '* ' : '')
                .fontSize(14)
                .fontColor('#ff4d4f')
              Text(this.data.label)
                .fontSize(14)
                .fontColor('#333333')
            }
            .width('10%')  // 标签占30%宽度
            .alignItems(VerticalAlign.Center)  // 垂直居中对齐
            .justifyContent(FlexAlign.End)     // 靠右对齐
            .margin({ right: 12 })            // 右边距
          }

          TextInput({
            text: this.data.value,
            placeholder: this.data.placeholder
          })
            .type(InputType.Normal)
            .placeholderColor('#999999')
            .height(40)
            .backgroundColor('#FFFFFF')
            .padding({ left: 12, right: 12 })
            .borderRadius(4)
            .fontSize(14)
            .maxLength(this.data.maxlength)
            .enabled(!this.data.disable)
            .textAlign(convertInputAlignToTextAlign(this.data.inputAlign))
            .onChange((value: string) => {
              this.data.value = value;
              this.outputs?.onChange?.(value);
            })
            .layoutWeight(1)  // 输入框占剩余空间
            .attributeModifier(
              new ApplyStyleModifier(this.styles['.mybricks-input'])
            )
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)  // 垂直居中对齐
      }
    }.attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}