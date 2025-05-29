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
  placeholderText?: string
  label?:string
  disabled?:boolean
  showSearchButton?:boolean
  searchButtonText?:string
  iconDistance?: number
  autoFocus?:boolean
  clearable?:boolean
}

@ObservedV2
export class Data implements DataType {
  @Trace placeholderText?: string
  @Trace label?: string
  @Trace disabled?: boolean
  @Trace showSearchButton?: boolean
  @Trace searchButtonText?: string
  @Trace iconDistance?: number
  @Trace autoFocus?: boolean
  @Trace clearable?: boolean


  constructor(config?: DataType) {
    this.placeholderText = config?.placeholderText
    this.label = config?.label
    this.disabled = config?.disabled
    this.showSearchButton = config?.showSearchButton
    this.searchButtonText = config?.searchButtonText || "搜索"
    this.iconDistance = config?.iconDistance
    this.autoFocus = config?.autoFocus
    this.clearable = config?.clearable
  }
}

interface Inputs {
  setValue: (fn: (val: string, outputRels?: void) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  focus: (fn:(val: AnyType, outputRels?: AnyType) => void) => void
}

interface Outputs {
  onClick: (value: string) => void
  onChange: (value: string) => void
  onClear: (value: string) => void
  onCancel: (value: string) => void
  onSearch: (value: string) => void
  returnValue: (value: string) => void
  focusDone: (value: string) => void
}

@ComponentV2
export default struct MyBricksSearchBar {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Local value?: string


  aboutToAppear(): void {

    this.inputs?.setValue((val, outputRels: AnyType) => {
      this.value = val;
    })


    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.value);
    })

    this.inputs?.focus((_: AnyType, outputRels: AnyType) => {
      outputRels?.["focusDone"]?.(this.value);
    })

  }

  build() {
    Column() {
      Row(){

        Text(this.data.label).textAlign(TextAlign.Center).width(this.data.label ? '10%': void 0).fontSize(13)
        Search({ value: this.value, placeholder: this.data.placeholderText })
          .searchIcon({
            src: $r('sys.media.ohos_ic_public_search_filled'),
          })
          .cancelButton({
            style: this.data.clearable ? CancelButtonStyle.CONSTANT : CancelButtonStyle.INVISIBLE,
            icon: {
              src: $r('sys.media.ohos_ic_public_cancel_filled')
            }
          })
          .searchButton(this.data.showSearchButton ? this.data.searchButtonText : void 0,{fontSize:13,fontColor:'#FA6400'})
          .defaultFocus(this.data.autoFocus)
          .height(40)
          .maxLength(20)
          .backgroundColor('#F5F5F5')
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .onSubmit((value: string) => {
            this.outputs?.onSearch(value)
          })
          .onChange((value: string) => {
            this.outputs?.onChange(value)
          })
          .onClick(()=>{
            this.outputs?.onClick(this.value || '')
          })
          .width(this.data.label ? '90%' : '100%')
      }.justifyContent(FlexAlign.Start)


    }.attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}

