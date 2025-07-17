import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

import { getStyleValueByPattern, parseLinearGradient } from './utils/StyleMatching'

export interface DataType {
  text: string
  ellipsis?: boolean
  maxLines?: number
  direction?: "horizonal" | "vertical"
}

@ObservedV2
export class Data implements DataType {
  @Trace text: string
  @Trace ellipsis: boolean
  @Trace maxLines: number
  @Trace direction : "horizonal" | "vertical"

  constructor(config: DataType) {
    this.text = config.text
    this.ellipsis = config?.ellipsis || false
    this.maxLines = config?.maxLines || 1
    this.direction = config?.direction || "horizonal"
  }
}

interface Inputs {
  value: (fn: (text: string) => void) => void
}

interface Outputs {
  onClick: (value: string) => void
}

function textAlignParse(cssTextAlign: AnyType): AnyType {
  switch(cssTextAlign) {
    case 'left':
      return HorizontalAlign.Start;
    case 'right':
      return HorizontalAlign.End;
    case 'center':
      return HorizontalAlign.Center;
    default:
      return HorizontalAlign.Start; // 默认值
  }
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
      if(this.data.direction === "horizonal"){
        Text(this.data.text)
          .lineBreakStrategy(LineBreakStrategy.GREEDY)
          .wordBreak(WordBreak.BREAK_WORD)
          .textOverflow({ overflow: this.data.ellipsis ? TextOverflow.Ellipsis : TextOverflow.None }) // 超出显示省略号
          .maxLines(this.data.ellipsis ? this.data.maxLines : undefined)  // 设置最大行数为1
          .halfLeading(true) // 添加了这个文本就可以垂直居中
            // .width('100%') //这里不能是100%，会导致文本的宽度配置没有生效
          .height('auto')
          .attributeModifier(
            new ApplyFontStyleModifier(this.styles['.mybricks-text'])
              .fontSize(14)
              .fontColor('#333333')
          )
          .linearGradient(parseLinearGradient(getStyleValueByPattern(this.styles,['.mybricks-text'],'backgroundImage')))

      } else if (this.data.direction === "vertical"){
        // 垂直排列的文本（拆分字符）
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center }) {
          ForEach(Array.from(this.data.text), (char: string, index: number) => {
            Column() {
              Text(char)
                .attributeModifier(
                  new ApplyFontStyleModifier(this.styles['.mybricks-text'])
                    .fontSize(14)
                    .fontColor('#333333')
                )
            }
          })
        }.height('auto')
        .width('auto')
        .linearGradient(parseLinearGradient(getStyleValueByPattern(this.styles,['.mybricks-text'],'backgroundImage')))
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(textAlignParse(this.styles?.['.mybricks-text']?.textAlign))
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
