import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { getStyleValueByPattern  } from './utils/StyleMatching'

// Data 接口定义
export interface DataType {
  label: string
  hideLabel: boolean
  name: string
  value: number
  min: number
  max: number
  lapValue: number
  openSlot: boolean
  pointerY: number
  disabled: boolean
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

// Data 类实现
@ObservedV2
export class Data implements DataType {
  @Trace label: string
  @Trace hideLabel: boolean
  @Trace name: string
  @Trace value: number
  @Trace min: number
  @Trace max: number
  @Trace lapValue: number
  @Trace disabled: boolean = false
  @Trace openSlot: boolean = false
  @Trace pointerY: number = 0

  constructor(config?: Partial<DataType>) {
    // 默认值
    this.label = config?.label ?? '开关'
    this.hideLabel = config?.hideLabel ?? false
    this.name = config?.name ?? '开关'
    this.value = config?.value ?? 0
    this.min = config?.min ?? 0
    this.max = config?.max ?? 999
    this.lapValue = config?.lapValue ?? 24
    this.openSlot = config?.openSlot ?? false
    this.pointerY = config?.pointerY ?? 0
  }
}

// 其他接口定义保持不变
interface Inputs {
  setValue: (fn: (val: number, outputRels?: void) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  setLabel: (fn: (val: string) => void) => void
  setDisabled: (fn: (val: boolean, outputRels: void) => void) => void
}

interface Outputs {
  onChange: (value: number) => void
  setValueComplete: (value: boolean) => void
  returnValue: (value: number) => void
  setDisabledComplete: (value: boolean) => void
}

export interface SlotsParams {
  id: string,
}
@Builder function emptySlot(params: SlotsParams) {}

@ComponentV2
export default struct MyBricksFormNumberKnob {
  @Param data: Data = new Data();
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

  @Local boxSize: number = 0;
  @Local angle: number = 0;
  @Local value: number = this.data.value
  @Monitor ('data.value')
  onDataValueChange(monitor: IMonitor) {
    if (!this.actioning) {
      this.value = monitor.value()?.now as number
    }
  }

  private startAngle: number = 0;
  private actioning: boolean = false;
  private pointerWidth: number = getStyleValueByPattern(this.styles, ['.mybricks-form-number-knob-pointer'], 'width') ?? 6
  private pointerHeight: number = getStyleValueByPattern(this.styles, ['.mybricks-form-number-knob-pointer'], 'height') ?? 20


  /**
   * 根据触摸点计算相对圆心的角度
   */
  private calcAngle(event: GestureEvent): number {
    let x = event.fingerList![0].localX - this.boxSize/2;
    let y = event.fingerList![0].localY - this.boxSize/2;
    return Math.atan2(y, x) * 180 / Math.PI + 90;
  }

  aboutToAppear(): void {
    this.inputs?.setValue((val, outputRels: AnyType) => {
      this.data.value = val;
      outputRels?.["setValueComplete"]?.(val);
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.data.value);
    })
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Column()
          .borderRadius(3)
          .backgroundColor(Color.Red)
          .offset({ y: (this.pointerHeight - this.boxSize) / 2 + this.data.pointerY })
          .attributeModifier(
            new ApplyStyleModifier(this.styles['.mybricks-form-number-knob-pointer'])
          )
          .width(this.pointerWidth)
          .height(this.pointerHeight)
          .rotate({
            angle: this.angle,
            centerX: this.pointerWidth/2,
            centerY: this.boxSize / 2 - this.data.pointerY
          })

        Column(){
          if (this.data.openSlot) {
            this.slots({
              id: `slot_center`,
            })
          } else {
            Text(Math.ceil(this.value) + '')
          }
        }
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-form-number-knob-center'])
        )
        .width(getStyleValueByPattern(this.styles, ['.mybricks-form-number-knob-center'], 'width') ?? 80)
        .height(getStyleValueByPattern(this.styles, ['.mybricks-form-number-knob-center'], 'height') ?? 80)
      }
      .gesture(
        PanGesture()
          .onActionStart((event: GestureEvent) => {
            if (this.data.disabled) return
            this.startAngle = this.calcAngle(event);
            this.actioning = true
          })
          .onActionUpdate((event: GestureEvent) => {
            if (this.data.disabled) return
            let current = this.calcAngle(event);

            let delta = current - this.startAngle;
            // 调整跨 -180~180 度问题
            if (delta > 180) delta -= 360;
            if (delta < -180) delta += 360;

            this.angle += delta;
            this.startAngle = current;
            const deltaVal = delta / 360 * this.data.lapValue;
            this.value = Math.min(Math.max(this.value + deltaVal, this.data.min), this.data.max);

            if (Math.ceil(this.value) !== this.data.value) {
              this.data.value = Math.ceil(this.value)
            }
          })
          .onActionEnd(() => {
            if (this.data.disabled) return
            this.actioning = false
            this.outputs?.onChange?.(this.data.value)
            this.parentSlot?._inputs?.["onChange"]?.({
              id: this.uid,
              value: this.data.value,
            });
          })
      )
      .backgroundColor('#eee')
      .borderRadius('50%')
      .attributeModifier(
        new ApplyStyleModifier(this.styles['.mybricks-form-number-knob'])
      )
      .width('100%')
      .height(this.boxSize)
      .onAreaChange((oldArea, newArea) => {
        this.boxSize = Number(newArea.width)
      })
    }
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'] || {})
    )
    .attributeModifier(this.modifier)
  }
}