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
  showSearchIcon?:boolean
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
  @Trace showSearchIcon?: boolean


  constructor(config?: DataType) {
    this.placeholderText = config?.placeholderText
    this.label = config?.label
    this.disabled = config?.disabled
    this.showSearchButton = config?.showSearchButton
    this.searchButtonText = config?.searchButtonText || "搜索"
    this.iconDistance = config?.iconDistance
    this.autoFocus = config?.autoFocus
    this.clearable = config?.clearable
    this.showSearchIcon = config?.showSearchIcon
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
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

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

        Row(){
          if(this.data.showSearchIcon){
            Image($r('sys.media.ohos_ic_public_search_filled'))
              .width(15)
              .height(15)
              .fillColor("#C4C2C2")
              .margin({
                left:10,
                right:5
              })
          }
          TextInput({
            placeholder:this.data.placeholderText,
            text:this.value
          })
            .enabled(!this.data.disabled)
            .placeholderColor("#999999")
            .placeholderFont({
              size:13
            })
            .fontSize(13)
            .backgroundColor(Color.Transparent)
            .layoutWeight(1) // 添加这一行使其占据剩余空间
            .margin({right: 5}) // 添加右边距
            .onChange((value)=>{
              this.value = value
            })
            .onClick((value)=>{
              if(this.data.disabled){
                this.outputs?.onClick(this.value || this.data.placeholderText || "")
              }
            })
            .defaultFocus(this.data.autoFocus)

          if (this.data.showSearchButton) {
            Button(this.data.searchButtonText)
              .fontColor(Color.White)
              .fontSize(14)
              .margin({
                right: 5,
                top: 5,
                bottom: 5,
                left: 5
              })
              .onClick(() => {
                if(this.data.disabled){
                  this.outputs?.onClick(this.value || this.data.placeholderText || "")
                }else{
                  this.outputs?.onSearch(this.value ?? "")
                }

              })
              .width(60)
              .height(30)
              .attributeModifier(
              new ApplyStyleModifier(this.styles['.mybricks-searchButton'])
                .backgroundColor("#00CF22")

            )
          }
        }
        .onClick(() => {
          if(this.data.disabled) {
            // 禁用状态下的点击事件
            this.outputs?.onClick(this.value || this.data.placeholderText || "")
          }
        })
        .height('100%')
        .width(this.data.label ? '90%' : '100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-searchBar'])
            .borderRadius(50)
            .backgroundColor(Color.White)
        )

      }.justifyContent(FlexAlign.Start)


    }.attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}

