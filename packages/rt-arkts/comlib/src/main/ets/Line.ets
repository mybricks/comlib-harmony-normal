import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {

}

@ObservedV2
export class Data implements DataType {


  constructor(config: DataType) {

  }
}

interface Inputs {

}

interface Outputs {

}

@ComponentV2
export default struct MyBricksLine {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  aboutToAppear(): void {

  }

  build() {
    Column() {

    }
    .backgroundColor("#FA6400")
    .width("100%")
    .height("100%")
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-line'])
    )
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
