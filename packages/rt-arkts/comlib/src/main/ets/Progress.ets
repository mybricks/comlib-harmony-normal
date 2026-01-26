import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

import { getStyleValueByPattern, parseLinearGradient } from './utils/StyleMatching'

export interface DataType {
  initValue?: number
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
  @Trace initValue: number = 30

  constructor(config: DataType) {
    this.initValue = config.initValue ?? this.initValue
  }
}

interface Inputs {
  setPercent: (fn: (val: number) => void) => void
}

interface Outputs {
  onEnded: (value: string) => void
}

@ComponentV2
export default struct MyBricksProgress {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  @Local percent?: number

  aboutToAppear(): void {
    this.inputs?.setPercent((value) => {
      this.percent = value;
    })
  }

  build() {
    Column() {
      Column() {}
      .width(`${this.percent ?? this.data.initValue}%`)
      .height('100%')
      .attributeModifier(
        new ApplyStyleModifier(this.styles['.mybricks-progress-bar'])
          .backgroundColor('#fa6400')
          .borderRadius(5)
      )
      .linearGradient(parseLinearGradient(getStyleValueByPattern(this.styles,['.mybricks-progress-bar'],'backgroundImage')))
    }
    .alignItems(HorizontalAlign.Start)
    .width("100%")
    .height("100%")
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-progress-bg'],this.styles['root'])
        .backgroundColor('#ebedf0')
        .borderRadius(5)
    )
    .linearGradient(parseLinearGradient(getStyleValueByPattern(this.styles,['.mybricks-progress-bg'],'backgroundImage')))
    .attributeModifier(this.modifier)
  }
}
