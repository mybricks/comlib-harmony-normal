import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

import { getStyleValueByPattern, parseLinearGradient } from './utils/StyleMatching'

export interface DataType {
  total?: number
  current?: number

  blockColor?: string
  trackColor?: string
  selectedColor?: string
  blockSize?: number
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
  @Trace total: number = 60
  @Trace current: number = 0

  @Trace blockColor: string = "#FA6400"
  @Trace trackColor: string = "#E5E5E5"
  @Trace selectedColor: string = "#FA6400"
  @Trace blockSize: number = 12

  constructor(config: DataType) {
    const total = config.total ?? this.total
    this.total = total * 1000
    const current = config.current ?? this.current
    this.current = current * 1000

    this.blockColor = config.blockColor ?? this.blockColor
    this.trackColor = config.trackColor ?? this.trackColor
    this.selectedColor = config.selectedColor ?? this.selectedColor
    this.blockSize = config.blockSize ?? this.blockSize
  }
}

interface Inputs {
  setTotal: (fn: (val: number) => void) => void
  setCurrent: (fn: (val: number) => void) => void
  play: (fn: () => void) => void
  pause: (fn: () => void) => void
  reset: (fn: () => void) => void
}

interface Outputs {
  onChange: (value: number) => void
  onEnd: () => void
}

@ComponentV2
export default struct MyBricksPlayProgress {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Param _env?: _Env = undefined
  @Param env?: Env = undefined
  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  private intervalNum: number = 0;
  private step: number = 50

  @Local remainingDuration: number = this.data.total;
  @Local isSliding: boolean = false;

  handlePlay() {
    if (this.intervalNum) {
      clearInterval(this.intervalNum)
      this.intervalNum = 0
    }
    this.intervalNum = setInterval(() => {
      if (this.step + this.data.current >= this.data.total) {
        clearInterval(this.intervalNum)
        this.intervalNum = 0
        this.outputs?.onEnd?.();
      }
      this.data.current = this.step + this.data.current
    }, this.step)
  }

  handlePause() {
    clearInterval(this.intervalNum)
    this.intervalNum = 0
  }

  handleReset() {
    this.data.current = 0
  }

  aboutToAppear(): void {
    this.inputs?.setTotal((value) => {
      if (this.isSliding) {
        return
      }
      const total = value ?? 60
      this.data.total = total * 1000;
      this.remainingDuration = this.data.total;
    })

    this.inputs?.setCurrent((value) => {
      if (this.isSliding) {
        return
      }
      const current = value ?? 0
      this.data.current = current * 1000;
      this.remainingDuration = this.data.total - this.data.current;

      if (!this.remainingDuration) {
        this.outputs?.onEnd();
      }
    })

    this.inputs?.play(() => {
      this.handlePlay()
    })
    this.inputs?.pause(() => {
      this.handlePause()
    })
    this.inputs?.reset(() => {
      this.handleReset()
    })
  }

  build() {
    Column() {
      Slider({
        value: $$this.data.current,
        min: 0,
        max: this.data.total,
        step: 1,
        style: SliderStyle.OutSet
      })
        // 滑块的颜色
        .blockColor(this.data.blockColor)
        // 滑轨的背景颜色
        .trackColor(this.data.trackColor)
        // 滑轨的已滑动部分颜色
        .selectedColor(this.data.selectedColor)
        // 滑块大小
        .blockSize({
          width: this.data.blockSize,
          height: this.data.blockSize
        })
        .width('100%')
        .onChange((value: number, mode: SliderChangeMode) => {
          if (mode === SliderChangeMode.Begin) {
            this.isSliding = true;
          } else if (mode === SliderChangeMode.Moving) {
            this.data.current = value;
            this.remainingDuration = this.data.total - this.data.current;
          } else if (mode === SliderChangeMode.End) {
            this.isSliding = false;
            this.data.current = value;
            this.remainingDuration = this.data.total - this.data.current;
            this.outputs?.onChange?.(value);
          }
        })

      Row() {
        Text(this.formatTime(this.data.current))
          .attributeModifier(
            new ApplyStyleModifier(this.styles['.mybricks-play-progress-text'])
          )
          .attributeModifier(
            new ApplyFontStyleModifier(this.styles['.mybricks-play-progress-text'])
              .fontSize(12)
              .fontColor('#666')
          )
        Text(this.formatTime(this.remainingDuration))
          .attributeModifier(
            new ApplyStyleModifier(this.styles['.mybricks-play-progress-text'])
          )
          .attributeModifier(
            new ApplyFontStyleModifier(this.styles['.mybricks-play-progress-text'])
              .fontSize(12)
              .fontColor('#666')
          )
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
  }

  private formatTime(milliseconds: number, showMillisecond?: boolean): string {
    if (!isFinite(milliseconds) || milliseconds < 0) {
      return '00:00:00'
    }
    const hour = Math.floor(milliseconds / (60*60*1000))
    const min = Math.floor((milliseconds % (60*60*1000)) / (60*1000))
    const sec = Math.floor((milliseconds % (60*1000)) / 1000)
    const ms = Math.floor(milliseconds % 1000).toString().padStart(3, '0')
    const defaultStr = [hour, min, sec].map(i => i.toString().padStart(2, '0')).join(':')
    if (!showMillisecond) return defaultStr
    return `${defaultStr}.${ms}`
  }
}
