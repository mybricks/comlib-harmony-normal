import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'

export interface DataType {
  copyright?: string
  logo?: string
}

@ObservedV2
export class Data implements DataType {
  @Trace copyright?: string
  @Trace logo?: string

  constructor(config: DataType) {
    this.copyright = config.copyright
    this.logo = config.logo
  }
}


@ComponentV2
export default struct MyBricksSupport {
  @Param data: Data = new Data({
  });
  @Param styles: Record<string, CSSProperties> = {}

  aboutToAppear(): void {

  }


  build() {
    Column() {
      Row() {
        // 条件渲染版权信息
        if (this.data.copyright) {
          Text(`版权所有：${this.data.copyright}`).fontSize(12).fontColor("#999999")
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      Row() {
        Image(this.data.logo)
          .width(16)
          .height(16)
          .margin({
            right:4
          })
        Text('Powerd by MyBricks.ai')
          .fontSize(12)
          .fontColor("#999999")
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }

}
