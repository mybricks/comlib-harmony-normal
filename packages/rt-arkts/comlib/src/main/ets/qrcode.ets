import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './styles/getDesignStyle'

export interface DataType {
  text: string
}

@ObservedV2
export class Data implements DataType {
  @Trace text: string

  constructor(config: DataType) {
    this.text = config.text
  }
}

interface Inputs {
  Text: (fn: (text: string) => void) => void
}

interface Outputs {

}

@ComponentV2
export default struct Mybricks_Qrcode {
  @Param data: Data = new Data({
    text: '初始二维码内容'
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

  aboutToAppear(): void {
    this.inputs?.Text((text) => {
      this.data.text = text;
    })
  }

  build() {
    Column() {
      QRCode(this.data.text)
        .width(200)
        .height(200)
        .color(Color.Black)
        .backgroundColor(Color.White)
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-qrcode'])
        )
    }
    // .width('100%')
    // .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
