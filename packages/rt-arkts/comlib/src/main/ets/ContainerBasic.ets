import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  layout?: CSSProperties
}

@ObservedV2
export class Data implements DataType {
  @Trace layout?: CSSProperties

  constructor(config: DataType) {
    this.layout = config?.layout ?? {}
  }
}


interface Inputs {

}

interface Outputs {
  onClick: (value?: AnyType) => void
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

  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;

  aboutToAppear(): void {

  }

  build() {
    Column() {
      this.slots({
        id: 'content'
      })
    }
    .alignItems(HorizontalAlign.Start)
    .align(Alignment.Start)
    .height('100%')
    .width('100%')
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(
      new ApplyStyleModifier(this.styles['> .mybricks-container'])
    )
    .onClick(() => {
      this.outputs?.onClick?.()
    })
  }
}
