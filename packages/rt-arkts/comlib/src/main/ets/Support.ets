import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  copyright?: string
  logo?: string
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
  @Trace copyright?: string
  @Trace logo?: string

  constructor(config: DataType) {
    this.copyright = config.copyright
    this.logo = config.logo
  }
}

interface Inputs {
}

interface Outputs {
}


@ComponentV2
export default struct MyBricksSupport {
  @Param data: Data = new Data({
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param inputs?: Inputs = undefined
  @Param outputs?: Outputs = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  aboutToAppear(): void {

  }


  build() {
    Column() {
      Row() {
        // 条件渲染版权信息
        if (this.data.copyright) {
          Text(`版权所有：${this.data.copyright}`)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks-support'])
                .fontSize(10)
                .fontColor('#999')
            )
        }
      }
      .width('100%')
      .margin({
        bottom:6
      })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      Row() {
        Image(this.data.logo)
          .opacity(0.6)
          .width(16)
          .height(16)
          .margin({
            right:4
          })
        Text('Powerd by MyBricks.ai')
          .attributeModifier(
            new ApplyFontStyleModifier(this.styles['.mybricks-support'])
              .fontSize(10)
              .fontColor('#999')
          )
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-support'])
    )
    .attributeModifier(this.modifier)
  }

}
