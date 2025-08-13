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

interface Outputs {
  onClick: (value?: AnyType) => void
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
    return styles?.overflowY === 'hidden' || styles?.overflowX === 'hidden'
  }

  build() {
    Column() {
      if (this.shouldScroll) {
        Scroll() {
          this.slots({
            id: 'content'
          })
        }
      } else {
        this.slots({
          id: 'content'
        })
      }
    }
    .alignItems(HorizontalAlign.Start)
    .align(Alignment.Start)
    .height('100%')
    .width('100%')
    .clip(this.shouldClip)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(
      new ApplyStyleModifier(this.styles['> .mybricks-container'])
    )
    .linearGradient(parseLinearGradient(String(this.styles['> .mybricks-container']?.backgroundImage)))
    .parallelGesture(
      TapGesture({ count: 1 }).onAction((event: GestureEvent) => {
        this.outputs?.onClick?.()
      })
    )
  }
}
