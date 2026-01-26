import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

import { getStyleValueByPattern, parseLinearGradient } from './utils/StyleMatching'

export interface DataType {
  layout?: CSSProperties
  overflowVisible?: boolean
}

@ObservedV2
export class Data implements DataType {
  @Trace layout?: CSSProperties
  @Trace overflowVisible?: boolean

  constructor(config: DataType) {
    this.layout = config?.layout ?? {}
    this.overflowVisible = config?.overflowVisible ?? false
  }
}


interface Inputs {

}

interface ScrollParams {
  xOffset: number,
  yOffset: number,
  scrollTop: number,
  scrollLeft: number
}

interface Outputs {
  onClick: (value?: AnyType) => void
  onScroll: (p: ScrollParams) => void
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

export interface SlotsParams {
  id: string,
  style?: CSSProperties
}

@Builder function emptySlot(params: SlotsParams) {}

@ComponentV2
export default struct MyBricksContainerBasic {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {

  }

  @Computed
  get shouldScroll (): boolean {
    const styles = this.styles?.['> .mybricks-container'];
    return styles?.overflowY === 'scroll' || styles?.overflowY === 'auto' || styles?.overflowX === 'scroll' || styles?.overflowX === 'auto'
  }

  @Computed
  get shouldClip (): boolean {
    const styles = this.styles?.['> .mybricks-container'];
    //没有配置overflowY overflowX默认为超出部分隐藏
    if(!styles?.overflowY || !styles?.overflowX){
      console.log("styles",styles)
      return true
    }
    return styles?.overflowY === 'hidden' || styles?.overflowX === 'hidden'
  }

  build() {
    Column() {
      if (this.shouldScroll) {
        Scroll(this.scroller) {
          this.slots({
            id: 'content',
            style: this.data.layout
          })
        }
        .onWillScroll((xOffset, yOffset) => {
          if (this.outputs?.onScroll) {
            const cur = this.scroller.currentOffset()
            this.outputs?.onScroll({ xOffset, yOffset, scrollTop: cur.yOffset, scrollLeft: cur.xOffset })
          }
        })
      } else {
        this.slots({
          id: 'content',
          style: this.data.layout
        })
      }
    }
    .alignItems(HorizontalAlign.Start)
    .align(Alignment.Start)
    .clip(this.shouldClip)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(
      new ApplyStyleModifier(this.styles['> .mybricks-container'],this.styles['root'])
    )
    .linearGradient(parseLinearGradient(String(this.styles['> .mybricks-container']?.backgroundImage)))
    .parallelGesture(
      TapGesture({ count: 1 }).onAction((event: GestureEvent) => {
        this.outputs?.onClick?.()
      })
    )
    .attributeModifier(this.modifier)
  }
}
