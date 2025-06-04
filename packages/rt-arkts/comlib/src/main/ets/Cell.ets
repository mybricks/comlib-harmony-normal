import { AnyType } from './types'
import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'

export interface DataType {
  title?: string
  brief?: string
  content?: string
  useArrowIcon?: boolean
  arrowIconColor?: string
  useSwipeLeft?: boolean   //是否开启左滑菜单
  leftSwipeText?: string   //左滑菜单按钮文本内容
  leftSwipeWidth?: number  //左滑菜单的宽度
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
  @Trace leftSwipeWidth?: number | undefined

  constructor(config: DataType) {
    this.title = config?.title
    this.brief = config?.brief
    this.content = config?.content
    this.useArrowIcon = config?.useArrowIcon
    this.arrowIconColor = config?.arrowIconColor
    this.useSwipeLeft = config?.useSwipeLeft
    this.leftSwipeText = config?.leftSwipeText
    this.leftSwipeWidth = config?.leftSwipeWidth
  }
}

interface Inputs {
  value: (fn: (value: AnyType) => void) => void
}

interface Outputs {
  onClick: (value: string) => void
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
  @Local arrowRight:string = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+PHN2ZyB0PSIxNzQ4NTczMjk4ODI4IiBjbGFzcz0iaWNvbiIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjUzMjEiIHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPjxwYXRoIGQ9Ik0zNDUuNiAyMzkuMzZhNDIuNDk2IDQyLjQ5NiAwIDAgMS0xLjI4LTYwLjE2IDQyLjI0IDQyLjI0IDAgMCAxIDYwLjU4NjY2Ny0xLjI4bDMxMS40NjY2NjYgMjk4LjY2NjY2N2MxMC4yNCA5LjgxMzMzMyAxNS4zNiAxOS42MjY2NjcgMTUuNzg2NjY3IDI5Ljg2NjY2NiAwIDkuODEzMzMzLTQuNjkzMzMzIDIwLjA1MzMzMy0xNC41MDY2NjcgMzAuMjkzMzM0bC0zMTIuNzQ2NjY2IDI5OS45NDY2NjZhNDIuNjY2NjY3IDQyLjY2NjY2NyAwIDAgMS02MC41ODY2NjctMS4yOCA0Mi40OTYgNDIuNDk2IDAgMCAxIDEuMjgtNjAuMTZsMjc5LjQ2NjY2Ny0yNjcuOTQ2NjY2TDM0NS42IDIzOS4zNnoiIHAtaWQ9IjUzMjIiIGRhdGEtc3BtLWFuY2hvci1pZD0iYTMxM3guc2VhcmNoX2luZGV4LjAuaTYuMTM1ODNhODFXdUFKVmwiIGNsYXNzPSJzZWxlY3RlZCIgZmlsbD0iIzQ3NDc0NyI+PC9wYXRoPjwvc3ZnPg=="

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
      Column(){
        Text("编辑")
      }
      .backgroundColor('#D9D9D9')
      .width(65)
      .height("100%")
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.scroller.closeAllSwipeActions();
      })

      Column(){
        Text("删除").fontColor(Color.White)
      }
      .width(65)
      .height("100%")
      .backgroundColor('#DD241F')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.scroller.closeAllSwipeActions();
      })
    }.justifyContent(FlexAlign.Start).backgroundColor(Color.Transparent)
  }

  build() {
    Column() {
      List({ space: 0, scroller: this.scroller }) {
          ListItem() {
              Row(){
                Column(){
                  Text(this.data.title)
                    .fontColor('#323233')
                    .fontSize(17)
                    .margin({
                      bottom:10
                    })
                  Text(this.data.brief)
                    .fontColor('#969799')
                    .fontSize(15)
                }
                .height('100%')
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)

                Row(){
                  Text(this.data.content)
                    .fontColor('#969799')
                    .fontSize(15)
                    .margin({
                      right:5
                    })

                  // Image(this.arrowRight).width(20).height(20)
                  Text('>')
                    .fontColor('#323233')
                }
              }
              .width('100%')
              .height('100%')
              .padding({
                left:20,
                right:20
              })
              .justifyContent(FlexAlign.SpaceBetween)
          }
          .height("100%")
          .backgroundColor(Color.White)
          .border({
            width: { bottom: 1 },
            color: '#F8F8F8',
            style: BorderStyle.Solid
          })
          .transition({ type: TransitionType.Delete, opacity: 0 })
          .swipeAction({
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
          })
      }
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      this.outputs?.onClick(this.data.title || "")
    })
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-cell'])
    )
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
