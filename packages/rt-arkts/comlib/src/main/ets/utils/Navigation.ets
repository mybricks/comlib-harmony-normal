import { AnyType } from './../types'

@ComponentV2
export struct DefaultNavigation {
  @Param navHeight: number = 40
  @Param navBackgroundColor: string = '#464646'

  @Param titleColor: string = '#ffffff'
  @Param title: string = '页面标题'

  @Param showBackIcon?: boolean = false
  @Event onBackClick: () => void = () => {}

  aboutToAppear(): void {
    // window.getLastWindow(getContext()).then(win => {
    //   win.setWindowSystemBarProperties({
    //     // 设置状态栏文本颜色为白色
    //     statusBarContentColor: calculateBrightness(this.barBackgroundColor) > 0.5 ? '#000000' : '#ffffff'
    //   })
    // })
  }


  build() {
    Stack() {
      RelativeContainer() {
        Text(this.title)
          .fontSize(16)
          .width('50%')
          .height('100%')
          .fontColor(this.titleColor)
          .fontWeight(FontWeight.Medium)
          .ellipsisMode(EllipsisMode.END)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .textAlign(TextAlign.Center)
          .alignRules({
            middle: { anchor: "__container__", align: HorizontalAlign.Center },
          })
        if (!!this.showBackIcon) {
          Column(){
            SymbolGlyph($r('sys.symbol.chevron_left'))
              .fontSize(32)
              .renderingStrategy(SymbolRenderingStrategy.SINGLE)
              .fontColor([this.titleColor, Color.White])
          }
          .height('100%')
          .width(36)
          .padding({
            left: 16
          })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .alignRules({
            left: { anchor: "__container__", align: HorizontalAlign.Start },
          })
          .onClick(() => {
            this.onBackClick()
          })
        }
      }
      .width('100%')
      .height(this.navHeight)
    }
    .width('100%')
    .backgroundColor(this.navBackgroundColor)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}


@Builder function emptySlot() {}

@ComponentV2
export struct CustomNavigation {
  @Param navHeight: number = 40
  @Param navBackgroundColor: string = '#464646'

  @Param titleColor: string = '#ffffff'
  @Param title: string = '页面标题'

  @BuilderParam content: () => void = emptySlot;

  build() {
    Column() {
      this.content()
    }
    .width('100%')
    .height('fit-content')
    .backgroundColor(this.navBackgroundColor)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}

export type MyBricksNavigationMode = 'custom' | 'none' | 'default'

@ComponentV2
export default struct MyBricksNavigation {
  @Param mode: MyBricksNavigationMode = 'default'
  @Param config: AnyType = {}

  @BuilderParam content: () => void = emptySlot;

  build() {
    Stack() {
      if (this.mode === 'none') {

      } else if (this.mode === 'custom') {
        CustomNavigation({
          navBackgroundColor: this.config?.navigationBarStyle?.backgroundColor,
          titleColor: this.config?.navigationBarStyle?.color
        }) {
          this.content()
        }
      } else {
        DefaultNavigation({
          title: this.config.title,
          navBackgroundColor: this.config?.navigationBarStyle?.backgroundColor,
          titleColor: this.config?.navigationBarStyle?.color,
          showBackIcon: this.config?.showBackIcon
        })
      }
    }
    .backgroundColor(Color.Red)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}