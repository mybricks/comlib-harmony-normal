import { CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  content: string
  useDynamic: boolean
}

@ObservedV2
export class Data implements DataType {
  @Trace content: string
  @Trace useDynamic: boolean

  constructor(config?: DataType) {
    this.content = config?.content ?? ''
    this.useDynamic = config?.useDynamic ?? false
  }
}

interface Inputs {
  setDataSource: (fn: (val: string) => void) => void
}

interface Outputs {
}

@ComponentV2
export default struct MyBricksRichText {
  @Param data: Data = new Data()
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined
  @Param outputs?: Outputs = undefined

  @Local ready: boolean = false

  fixMalformedURI(str: string): string {
    try {
      return decodeURIComponent(str)
    } catch (e) {
      return str.split('%')
        .map((s, index) => {
          if (index === 0) return s
          try {
            return decodeURIComponent('%' + s)
          } catch (e) {
            return '%' + s
          }
        })
        .join('')
    }
  }

  replacePx2Vp(content: string): string {
    const pxRegex = /(\d+(\.\d+)?)px/g;
    return content.replace(pxRegex, (match, p1: string) => {
      const newPxValue = vp2px(parseFloat(p1));
      return `${newPxValue}px`;
    });
  }

  @Computed
  get processedContent(): string {
    let result: string

    try {
      result = decodeURIComponent(this.fixMalformedURI(this.data.content))
    } catch (e) {
      result = this.data.content
    }

    result = result.replace(/<img.*?(?:>|\/>)/gi, (match) => {
      const matchResult = match.match(/src=[\'\"]?([^\'\"]*)[\'\"]?/i)
      const src = matchResult ? matchResult[1] : ''
      return match.replace(/<img/gi, `<img data-sid="${src}"`)
    })

    result = result.replace(
      /<img/gi,
      '<img class style="display: block; width: 100%; height: auto;"'
    )

    result = this.replacePx2Vp(result)

    return `<meta name="viewport" content="width=device-width">${result}`
  }

  @Computed
  get shouldDisplay(): boolean {
    if (this.data.useDynamic && !this.ready) {
      return false
    }
    return true
  }

  aboutToAppear() {
    this.inputs?.setDataSource((val) => {
      this.data.content = val
      this.ready = true
    })
  }

  build() {
    Column() {
      if (this.shouldDisplay) {
        RichText(this.processedContent)
          .width('100%')
      }
    }
  }
}