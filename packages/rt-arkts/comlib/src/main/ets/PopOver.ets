import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
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


interface Inputs {}

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

@Builder
function emptySlot(params: SlotsParams) {
}

@ComponentV2
export default struct MyBricksPopOver {
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

  aboutToAppear(): void {

  }

  @Computed
  get shouldScroll(): boolean {
    const styles = this.styles?.['> .mybricks-container'];
    return styles?.overflowY === 'scroll' || styles?.overflowY === 'auto' || styles?.overflowX === 'scroll' ||
      styles?.overflowX === 'auto'
  }

  @Computed
  get shouldClip(): boolean {
    const styles = this.styles?.['> .mybricks-container'];
    //没有配置overflowY overflowX默认为超出部分隐藏
    if (!styles?.overflowY || !styles?.overflowX) {
      console.log("styles", styles)
      return true
    }
    return styles?.overflowY === 'hidden' || styles?.overflowX === 'hidden'
  }

  @Builder
  MenuBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      this.slots({
        id: 'carrier',
        style: this.data.layout
      })
    }.attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-carrier'])
    )
  }

  build() {
    Stack() {
      Column() {
        if (this.shouldScroll) {
          Scroll() {
            this.slots({
              id: 'content',
              style: this.data.layout
            })
          }
        } else {
          this.slots({
            id: 'content',
            style: this.data.layout
          })
        }
      }
      .width("100%")
      .height("100%")

      //透明覆盖层（用于触发菜单），因为如果直接加在slots层级是不生效的
      Row()
        .width("100%")
        .height("100%")
        .backgroundColor(Color.Transparent)
        .bindMenu(this.MenuBuilder,{
          backgroundColor: Color.Transparent,
          backgroundBlurStyle: BlurStyle.NONE
        })
    }
    .align(Alignment.Start)
    .clip(this.shouldClip)
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-popover'])
    )
    .linearGradient(parseLinearGradient(String(this.styles['.mybricks-popover']?.backgroundImage)))
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(this.modifier)

  }
}
