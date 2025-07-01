import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  text: string
  ellipsis?: boolean
  maxLines?: number
}

@ObservedV2
export class Data implements DataType {
  @Trace text: string
  @Trace ellipsis: boolean
  @Trace maxLines: number

  constructor(config: DataType) {
    this.text = config.text
    this.ellipsis = config?.ellipsis || false
    this.maxLines = config?.maxLines || 1
  }
}

interface Inputs {
  value: (fn: (text: string) => void) => void
}

interface Outputs {
  onClick: (value: string) => void
}

@ComponentV2
export default struct MyBricksText {
  @Param data: Data = new Data({
    text: '文本内容'
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  aboutToAppear(): void {
    this.inputs?.value((text) => {
      this.data.text = String(text);
    })
  }

  build() {
    Column() {
      Text(this.data.text)
        .lineBreakStrategy(LineBreakStrategy.GREEDY)
        .wordBreak(WordBreak.BREAK_WORD)
        .textOverflow({ overflow: this.data.ellipsis ? TextOverflow.Ellipsis : TextOverflow.None }) // 超出显示省略号
        .maxLines(this.data.ellipsis ? this.data.maxLines : undefined)  // 设置最大行数为1
        .halfLeading(true) // 添加了这个文本就可以垂直居中
        .width('100%')
        .height('auto')
        .attributeModifier(
          new ApplyFontStyleModifier(this.styles['.mybricks-text'])
            .fontSize(14)
            .fontColor('#333333')
        )
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      this.outputs?.onClick(this.data.text)
    })
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-text'])
    )
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
