import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'

export interface DataType {
  text: string
  mode?: 'qrcode' | 'barcode'
}

@ObservedV2
export class Data implements DataType {
  @Trace text: string
  @Trace mode: 'qrcode' | 'barcode'

  constructor(config: DataType) {
    this.text = config.text
    this.mode = config?.mode ?? 'qrcode'
  }
}

interface Inputs {
  Text: (fn: (text: string) => void) => void
}

interface Outputs {

}

@ComponentV2
export default struct MyBricksQrcode {
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
        .width('100%')
        .height('100%')
        .color(Color.Black)
        .backgroundColor(Color.White)
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
