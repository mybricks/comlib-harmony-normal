import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'
import { parseSize, parseMargin } from './utils/StyleMatching'

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
  searchIconColor?: ResourceColor[]
  searchIconFontSize?: number
  searchIcon?: string
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
  @Trace placeholderText?: string
  @Trace label?: string
  @Trace disabled?: boolean
  @Trace showSearchButton?: boolean
  @Trace searchButtonText?: string
  @Trace iconDistance?: number
  @Trace autoFocus?: boolean
  @Trace clearable?: boolean
  @Trace showSearchIcon?: boolean
  @Trace searchIconColor?: ResourceColor[]
  @Trace searchIconFontSize?: number
  @Trace searchIcon?:string

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
    this.searchIconColor = config?.searchIconColor ?? ['#303030']
    this.searchIconFontSize = config?.searchIconFontSize ?? 15
    this.searchIcon = config?.searchIcon ?? 'magnifyingglass'
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



@ComponentV2
export default struct MyBricksSearchBar {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Local value?: string

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

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
  get placeHolderStyle(): AnyType {
    const style = this.styles?.['.mybricks-searchBar-input .taroify-native-input::placeholder'] ?? {}
    return {
      color: style?.color,
      fontSize: style?.fontSize ? parseFloat(style?.fontSize as string) : undefined
    };
  }

  build() {
    Column() {
      Row() {
        if (this.data.label) {
          Text(this.data.label)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks-searchBar-label'])
                .fontSize(13)
                .fontColor('#333')
            )
            .attributeModifier(
              new ApplyStyleModifier(this.styles['.mybricks-searchBar-label'])
            )
            .width(parseSize(this.styles['.mybricks-searchBar-label'].width) || '10%')
            .height(parseSize(this.styles['.mybricks-searchBar-label'].height))
            .margin(parseMargin(this.styles['.mybricks-searchBar-label']))
        }

        Row() {
          if (this.data.showSearchIcon) {
            SymbolGlyph($r(`sys.symbol.${this.data.searchIcon}`))
              .fontSize(this.data.searchIconFontSize)
              .fontWeight(400)
              .fontColor(this.data.searchIconColor)
              .renderingStrategy(SymbolRenderingStrategy.SINGLE)
              .width(this.data.searchIconFontSize)
              .height(this.data.searchIconFontSize)
              .alignSelf(ItemAlign.Center)
              .align(Alignment.Center)
              .renderFit(RenderFit.CENTER)
              .margin({
                right: 3
              })
          }
          TextInput({
            placeholder: this.data.placeholderText,
            text: this.value
          })
            .enabled(!this.data.disabled)
            .placeholderColor(this.placeHolderStyle?.color ?? '#C8C9CC')
            .placeholderFont({
              size: this.placeHolderStyle?.fontSize ?? 14
            })
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks-searchBar-input .taroify-native-input'])
                .fontSize(14)
                .fontColor('#323233')
            )
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
                  new ApplyFontStyleModifier(this.styles['.mybricks-searchButton'])
                    .fontSize(14)
                    .fontColor('#ffffff')
                )
            }
            .onClick(() => {
              if (this.data.disabled) {
                this.outputs?.onClick(this.value || this.data.placeholderText || "")
              } else {
                this.outputs?.onSearch(this.value ?? "")
              }

            })
            .attributeModifier(
              new ApplyStyleModifier(this.styles['.mybricks-searchButton'])
                .backgroundColor("#FA6400")
                .borderRadius(2)
            )
            .margin(parseMargin(this.styles['.mybricks-searchButton']))
            .width(parseSize(this.styles['.mybricks-searchButton'].width) || 50)
            .height(parseSize(this.styles['.mybricks-searchButton'].height) || '100%')
          }
        }
        .onClick(() => {
          if (this.data.disabled) {
            // 禁用状态下的点击事件
            this.outputs?.onClick(this.value || this.data.placeholderText || "")
          }
        })
        .height('100%')
        // .width(this.data.label ? '90%' : '100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-searchBar'])
            .borderRadius(2)
            .backgroundColor('#F7F8FA')
            .padding({
              top: 3,
              right: 3,
              bottom: 3,
              left: 12
            })
        )

      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
    }.attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    ).attributeModifier(this.modifier)
  }
}

