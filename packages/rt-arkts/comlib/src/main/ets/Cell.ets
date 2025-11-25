import { AnyType } from './types'
import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { parsePadding, parseMargin, parseSize } from './utils/StyleMatching'

export interface DataType {
  title?: string
  brief?: string
  content?: string
  useArrowIcon?: boolean
  arrowIconColor?: string
  useSwipeLeft?: boolean   //是否开启左滑主按钮
  leftSwipeText?: string   //左滑菜单按钮文本内容
  leftSwipeStyle?: AnyType  //左滑菜单的样式
  useSwipeLeftSecondary?: boolean   //是否开启左滑副按钮
  leftSwipeTextSecondary?: string   //左滑菜单副按钮文本内容
  leftSwipeStyleSecondary?: AnyType  //左滑菜单副按钮的样式
  useChildren?: boolean    //是否展示插槽
  useThumb?: boolean       //是否展示图标
  thumb?: string           //图标链接
}

@ObservedV2
export class Data implements DataType {
  @Trace title?: string
  @Trace brief?: string | undefined
  @Trace content?: string | undefined
  @Trace useArrowIcon?: boolean | undefined
  @Trace arrowIconColor?: string | undefined
  @Trace useSwipeLeft?: boolean | undefined
  @Trace leftSwipeText?: string | undefined
  @Trace leftSwipeStyle?: AnyType
  @Trace useSwipeLeftSecondary?: boolean | undefined
  @Trace leftSwipeTextSecondary?: string | undefined
  @Trace leftSwipeStyleSecondary?: AnyType
  @Trace useChildren?: boolean | undefined
  @Trace useThumb?: boolean | undefined
  @Trace thumb?: string | undefined

  constructor(config: DataType) {
    this.title = config?.title
    this.brief = config?.brief
    this.content = config?.content
    this.useArrowIcon = config?.useArrowIcon
    this.arrowIconColor = config?.arrowIconColor
    this.useSwipeLeft = config?.useSwipeLeft
    this.leftSwipeText = config?.leftSwipeText
    this.leftSwipeStyle = config?.leftSwipeStyle
    this.useSwipeLeftSecondary = config?.useSwipeLeftSecondary
    this.leftSwipeTextSecondary = config?.leftSwipeTextSecondary
    this.leftSwipeStyleSecondary = config?.leftSwipeStyleSecondary
    this.useChildren = config?.useChildren
    this.useThumb = config?.useThumb
    this.thumb = config?.thumb
  }
}

interface Inputs {
  value: (fn: (value: AnyType) => void) => void
}

interface Outputs {
  onClick: (value: string) => void
  onClickLeftAction: () => void
  onClickLeftActionSecondary: () => void
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

type DataSourceItem = Record<string, string | number | boolean | Object> | string | number | boolean
interface ItemParamsInputValues {
  index: number,
  itemData: DataSourceItem
}

export interface SlotsParamsItem {
  id: string,
  inputValues?: ItemParamsInputValues
}

@Builder
function emptySlot(params: SlotsParamsItem) {
}


@ComponentV2
export default struct MyBricksCell {
  @Param data: Data = new Data({
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParamsItem) => void = emptySlot;
  @Param slotsIO?: AnyType = undefined;
  @Local arrowRight:string = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNzQ4NTczMjk4ODI4IiBjbGFzcz0iaWNvbiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjUzMjEiIHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPjxwYXRoIGQ9Ik0zNDUuNiAyMzkuMzZhNDIuNDk2IDQyLjQ5NiAwIDAgMS0xLjI4LTYwLjE2IDQyLjI0IDQyLjI0IDAgMCAxIDYwLjU4NjY2Ny0xLjI4bDMxMS40NjY2NjYgMjk4LjY2NjY2N2MxMC4yNCA5LjgxMzMzMyAxNS4zNiAxOS42MjY2NjcgMTUuNzg2NjY3IDI5Ljg2NjY2NiAwIDkuODEzMzMzLTQuNjkzMzMzIDIwLjA1MzMzMy0xNC41MDY2NjcgMzAuMjkzMzM0bC0zMTIuNzQ2NjY2IDI5OS45NDY2NjZhNDIuNjY2NjY3IDQyLjY2NjY2NyAwIDAgMS02MC41ODY2NjctMS4yOCA0Mi40OTYgNDIuNDk2IDAgMCAxIDEuMjgtNjAuMTZsMjc5LjQ2NjY2Ny0yNjcuOTQ2NjY2TDM0NS42IDIzOS4zNnoiIHAtaWQ9IjUzMjIiIGRhdGEtc3BtLWFuY2hvci1pZD0iYTMxM3guc2VhcmNoX2luZGV4LjAuaTYuMTM1ODNhODFXdUFKVmwiIGNsYXNzPSJzZWxlY3RlZCIgZmlsbD0iIzQ3NDc0NyI+PC9wYXRoPjwvc3ZnPg=="
  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  aboutToAppear(): void {
    this.inputs?.value((value:AnyType) => {
      this.data.title = value.title
      this.data.brief = value.brief
      this.data.content = value.brief
    })
  }

  private scroller: ListScroller = new ListScroller();

  @Builder itemEnd() {
    Row() {
      if (this.data.useSwipeLeftSecondary) {
        Column(){
          Text(this.data.leftSwipeTextSecondary ?? '')
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks-cell-swipe-left-secondary'])
                .fontSize(14)
                .fontColor('#333')
            )
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-cell-swipe-left-secondary'])
            .backgroundColor('#d9d9d9')
        )
        .width(parseSize(this.styles['.mybricks-cell-swipe-left-secondary']?.width) ?? 50)
        .height(parseSize(this.styles['.mybricks-cell-swipe-left-secondary']?.height) ?? '100%')
        .onClick(() => {
          this.outputs?.onClickLeftActionSecondary()
          this.scroller.closeAllSwipeActions();
        })
      }

      Column(){
        Text(this.data.leftSwipeText ?? '')
          .attributeModifier(
            new ApplyFontStyleModifier(this.styles['.mybricks-cell-swipe-left'])
              .fontSize(14)
              .fontColor(Color.White)
          )
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .attributeModifier(
        new ApplyStyleModifier(this.styles['.mybricks-cell-swipe-left'])
          .backgroundColor('#DD241F')
      )
      .width(parseSize(this.styles['.mybricks-cell-swipe-left']?.width) ?? 50)
      .height(parseSize(this.styles['.mybricks-cell-swipe-left']?.height) ?? '100%')
      .onClick(() => {
        this.outputs?.onClickLeftAction()
        this.scroller.closeAllSwipeActions();
      })
    }.justifyContent(FlexAlign.Start).backgroundColor(Color.Transparent)
  }

  build() {
    Column() {
      List({ space: 0, scroller: this.scroller }) {
        ListItem() {
          Row(){
            Row() {
              if (this.data.useThumb) {
                Image(this.data.thumb)
                  .attributeModifier(
                    new ApplyStyleModifier(this.styles['.mybricks-thumb'])
                  )
                  .width(parseSize(this.styles['.mybricks-thumb'].width) ?? 42)
                  .height(parseSize(this.styles['.mybricks-thumb'].height) ?? 42)
                  .margin(parseMargin(this.styles['.mybricks-thumb'], {
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 12,
                  }))
              }
              Column() {
                Text(this.data.title)
                  .attributeModifier(
                    new ApplyFontStyleModifier(this.styles['.mybricks-title'])
                      .fontSize(14)
                      .fontColor('#323233')
                  )
                  .margin(parseMargin(this.styles['.mybricks-title']))
                Text(this.data.brief)
                  .attributeModifier(
                    new ApplyFontStyleModifier(this.styles['.mybricks-brief'])
                      .fontSize(12)
                      .fontColor('#969799')
                  )
                  .margin(parseMargin(this.styles['.mybricks-brief'], {
                    top: 4,
                    bottom: 0,
                    right: 0,
                    left: 0
                  }))
              }
              // .height(55)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Start) // 添加水平对齐
            }
            .alignItems(VerticalAlign.Center) // 确保 Row 内容垂直居中

            Row(){
              if(this.data.useChildren){
                this.slots({
                  id: 'children',
                })
              }else{
                Text(this.data.content)
                  .attributeModifier(
                    new ApplyFontStyleModifier(this.styles['.mybricks-content'])
                      .fontSize(14)
                      .fontColor('#969799')
                  )
                  .margin(parseMargin(this.styles['.mybricks-content']))
              }

              if (this.data.useArrowIcon) {
                SymbolGlyph($r(`sys.symbol.chevron_right`))
                  .width(12)
                  .height(19)
                  .fontSize(18)
                  .fontColor([this.data.arrowIconColor || '#969799'])
              }
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding(parsePadding(this.styles['.mybricks-cell'],{
            top: 12,
            bottom: 12,
            left: 16,
            right: 16,
          }))
        }

        .transition({ type: TransitionType.Delete, opacity: 0 })
        .swipeAction(this.data?.useSwipeLeft ? {
          end: {
            builder: () => { this.itemEnd() },
            // onAction: () => {
            //   this.getUIContext()?.animateTo({ duration: 1000 }, () => {
            //     let index = this.arr.indexOf(item);
            //     this.arr.splice(index, 1);
            //   });
            // },
            actionAreaDistance: 56,
            onEnterActionArea: () => {
            },
            onExitActionArea: () => {
            }
          }
        } : {})
      }
    }
    .width('100%')
    // .height('100%')
    .onClick(() => {
      this.outputs?.onClick(this.data.title || "")
    })
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-cell'])
        .backgroundColor(Color.White)
    )
    .margin(parseMargin(this.styles['.mybricks-cell']))
    .padding(0)
    .attributeModifier(this.modifier)
    // .backgroundColor(Color.Red)
  }
}
