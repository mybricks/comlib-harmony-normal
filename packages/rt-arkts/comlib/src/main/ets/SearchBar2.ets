import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'
import { getStyleValueByPattern, parseRadius } from './utils/StyleMatching'

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
  label?: string
  disabled?: boolean
  showSearchButton?: boolean
  searchButtonText?: string
  iconDistance?: number
  autoFocus?: boolean
  clearable?: boolean
  showSearchIcon?: boolean
  searchIcon?: string
  searchIconColor?: Array<AnyType>
  searchIconFontSize?: number
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
  @Trace searchIcon?: string | undefined
  @Trace searchIconColor?: Array<AnyType>
  @Trace searchIconFontSize?: number

  constructor(config?: DataType) {
    this.placeholderText = config?.placeholderText
    this.label = config?.label
    this.disabled = config?.disabled
    this.showSearchButton = config?.showSearchButton
    this.searchButtonText = config?.searchButtonText || "搜索"
    this.iconDistance = config?.iconDistance
    this.autoFocus = config?.autoFocus
    this.clearable = config?.clearable
    this.showSearchIcon = config?.showSearchIcon || true
    this.searchIcon = config?.searchIcon
    this.searchIconColor = config?.searchIconColor
    this.searchIconFontSize = config?.searchIconFontSize
  }
}

interface Inputs {
  setValue: (fn: (val: string, outputRels?: void) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  focus: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
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

//这些图标是长方形，需要单独进行判断然后Width配置为"auto"
const non_square_icon = [
  "chevron_down",
  "chevron_left",
  "chevron_right",
  "chevron_up"
]



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

  @Computed
  get borderRadiusStyle(): AnyType {
    const style:AnyType = getStyleValueByPattern(this.styles, ['.mybricks-searchBar .mybricks-searchButton'])
    console.log("style",style)
    if(style?.borderRadius){
      //统一的圆角值
      return parseRadius(style.borderRadius)
    }
    return 60
  }

  build() {
    Column() {
      Row() {
        Text(this.data.label).textAlign(TextAlign.Center).width(this.data.label ? '10%' : void 0).fontSize(13)

        Row() {
          if (this.data.showSearchIcon) {
            SymbolGlyph($r(`sys.symbol.${this.data.searchIcon}`))
              .fontSize(this.data.searchIconFontSize)
              .width(non_square_icon.includes(this.data.searchIcon) ? 'auto' : this.data.searchIconFontSize)
              .height(this.data.searchIconFontSize)
              .fontColor([this.data.searchIconColor?.[0], Color.White])
              .renderingStrategy(SymbolRenderingStrategy.SINGLE)
              .alignSelf(ItemAlign.Center)
              .align(Alignment.Center)
              .renderFit(RenderFit.CENTER)
              .margin({
                left: 10,
                right: 5
              })
          }
          TextInput({
            placeholder: this.data.placeholderText,
            text: this.value
          })
            .enabled(!this.data.disabled)
            .placeholderColor("#999999")
            .placeholderFont({
              size: 13
            })
            .fontSize(13)
            .backgroundColor(Color.Transparent)
            .layoutWeight(1)// 添加这一行使其占据剩余空间
            // .margin({ right: 5 })// 添加右边距
            .onChange((value) => {
              this.value = value
            })
            .onClick((value) => {
              if (this.data.disabled) {
                this.outputs?.onClick(this.value || this.data.placeholderText || "")
              }
            })
            .defaultFocus(this.data.autoFocus)
            .padding(0)

          if (this.data.showSearchButton) {
            Button({ type: ButtonType.Normal }){
              Text(this.data.searchButtonText)
                .halfLeading(true)
                .attributeModifier(
                  new ApplyFontStyleModifier(this.styles['.mybricks-searchBar .mybricks-searchButton'])
                    .fontSize(14)
                    .fontColor('#ffffff')
                )
            }
              .margin({
                right: 5,
                top: 5,
                bottom: 5,
                left: 5
              })
              .onClick(() => {
                if (this.data.disabled) {
                  this.outputs?.onClick(this.value || this.data.placeholderText || "")
                } else {
                  this.outputs?.onSearch(this.value ?? "")
                }

              })
              .attributeModifier(
                new ApplyStyleModifier(this.styles['.mybricks-searchBar .mybricks-searchButton'])
                  .backgroundColor("#FA6400")
              )
              .width(getStyleValueByPattern(this.styles, ['.mybricks-searchBar .mybricks-searchButton'], "width", 60))
              .height(getStyleValueByPattern(this.styles, ['.mybricks-searchBar .mybricks-searchButton'], "height", 30))
              .borderRadius(this.borderRadiusStyle)

          }
        }
        .onClick(() => {
          if (this.data.disabled) {
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
            .borderRadius(2)
            .backgroundColor("#F7F8FA")
        )

      }
      .justifyContent(FlexAlign.Start)

    }.attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}

