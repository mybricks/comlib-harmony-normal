import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { getStyleValueByPattern, parseLinearGradient } from './utils/StyleMatching'

export interface DataType {
  text: string
  ellipsis?: boolean
  maxLines?: number
  direction?: "horizonal" | "vertical"
  enableTransition?: boolean // 添加动画效果开关
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
  @Trace text: string
  @Trace ellipsis: boolean
  @Trace maxLines: number
  @Trace direction: "horizonal" | "vertical"
  @Trace enableTransition: boolean

  constructor(config: DataType) {
    this.text = config.text
    this.ellipsis = config?.ellipsis || false
    this.maxLines = config?.maxLines || 1
    this.direction = config?.direction || "horizonal"
    this.enableTransition = config?.enableTransition ?? false // 默认关闭切换渐变动画
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

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Local _opacity: number = 1
  private animationDuration: number = 150
  private currentText: string = ''

  aboutToAppear(): void {
    this.currentText = this.data.text

    this.inputs?.value((text) => {
      const newText = String(text)

        if (!this.data.enableTransition) {
          // 禁用动画时直接更新文本
          this.data.text = newText
          this.currentText = newText
        } else {
          // 启用动画时执行渐变动画
          this.startTransition(newText)
        }

    })
  }

  private startTransition(newText: string) {
    // 执行渐变动画
    animateTo({
      duration: this.animationDuration,
      curve: Curve.EaseInOut,
      onFinish: () => {
        this.data.text = newText
        this.currentText = newText
        animateTo({
          duration: this.animationDuration,
          curve: Curve.EaseInOut,
        }, () => {
          this._opacity = 1
        })
      }
    }, () => {
      this._opacity = 0
    })
  }

  build() {
    Column() {
      if(this.data.direction === "horizonal"){
        Text(this.data.text)
          .lineBreakStrategy(LineBreakStrategy.GREEDY)
          .wordBreak(WordBreak.BREAK_WORD)
          .textOverflow({ overflow: this.data.ellipsis ? TextOverflow.Ellipsis : TextOverflow.None })
          .maxLines(this.data.ellipsis ? this.data.maxLines : undefined)
          .halfLeading(true)
          .height('auto')
          .opacity(this.data.enableTransition ? this._opacity : 1)
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
                .opacity(this.data.enableTransition ? this._opacity : 1)
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