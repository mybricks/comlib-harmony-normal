import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  clockType?: "realtime" | "countdown" | "timer" | string,
  countdown?: string
}

@ObservedV2
export class Data implements DataType {
  @Trace clockType?: string
  @Trace countdown?: string

  constructor(config: DataType) {
    this.clockType = config.clockType
    this.countdown = config.countdown
  }
}

interface Inputs {
  countDownTimeStamp: (fn: (timestamp: string) => void) => void
}

interface Outputs {
  finishCountDown: (value: string) => void,
  currentTime: (value: string) => void,
}

@ComponentV2
export default struct MyBricksText {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Local showTime: string = "--:--:--"
  @Local initTime: number = new Date().getTime()
  @Local countDown: string = ""
  private timerID: number = -1

  formatTime(date: Date): string {
    const hours = String(date.getHours()).padStart(2, '0')
    const minutes = String(date.getMinutes()).padStart(2, '0')
    const seconds = String(date.getSeconds()).padStart(2, '0')
    return `${hours}:${minutes}:${seconds}`
  }

  formatTimeDiff(timeDiff: number): string {
    const hours = Math.floor(timeDiff / (1000 * 60 * 60))
    const minutes = Math.floor((timeDiff % (1000 * 60 * 60)) / (1000 * 60))
    const seconds = Math.floor((timeDiff % (1000 * 60)) / 1000)
    return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
  }

  timeStringToTimestamp(timeString: string): number {
    const timeParts = timeString.split(':')
    const hours = Number(timeParts[0])
    const minutes = Number(timeParts[1])
    const seconds = Number(timeParts[2])
    return (hours * 60 * 60 + minutes * 60 + seconds) * 1000
  }

  updateCurrentTime() {
    const currentTime = new Date()
    this.showTime = this.formatTime(currentTime)
    this.outputs?.currentTime?.(currentTime.getTime().toString())
  }

  updateTimer() {
    const currentTime = new Date().getTime()
    const timeDiff = currentTime - this.initTime
    this.showTime = this.formatTimeDiff(timeDiff)
    this.outputs?.currentTime?.(timeDiff.toString())
  }

  updateCountDown() {
    let countDownStamp = this.timeStringToTimestamp(this.countDown)
    let endTimeStamp = this.initTime + countDownStamp
    let currentTimeStamp = new Date().getTime()
    let timeDiff = endTimeStamp - currentTimeStamp

    if (timeDiff >= 0) {
      this.showTime = this.formatTimeDiff(timeDiff)
      this.outputs?.currentTime?.(timeDiff.toString())
    } else {
      clearInterval(this.timerID)
      this.outputs?.finishCountDown?.(countDownStamp.toString())
    }
  }

  aboutToAppear(): void {
    // 设置输入监听
    this.inputs?.countDownTimeStamp((text) => {
      this.countDown = text
    })

    // 初始化定时器
    if (this.data.clockType) {
      // 清除之前的定时器
      if (this.timerID !== -1) {
        clearInterval(this.timerID)
      }

      switch (this.data.clockType) {
        case "realtime":
          this.updateCurrentTime()
          this.timerID = setInterval(() => {
            this.updateCurrentTime()
          }, 1000)
          break

        case "timer":
          this.updateTimer()
          this.timerID = setInterval(() => {
            this.updateTimer()
          }, 1000)
          break

        case "countdown":
          this.countDown = this.data.countdown || ""
          this.updateCountDown()
          this.timerID = setInterval(() => {
            this.updateCountDown()
          }, 1000)
          break
      }
    }
  }

  aboutToDisappear(): void {
    if (this.timerID !== -1) {
      clearInterval(this.timerID)
    }
  }

  build() {
    Column() {
      Row() {
        Column(){
          Text(this.showTime.substring(0, 2))
            .halfLeading(true)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks_timer_unit'])
            )
        }.attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks_timer_unit_background'])
        )

        Column(){
          Text(":")
            .halfLeading(true)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks_timer_separator'])
            )
        }


        Column(){
          Text(this.showTime.substring(3, 5))
            .halfLeading(true)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks_timer_unit'])
            )
        }.attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks_timer_unit_background'])
        )

        Column(){
          Text(":")
            .halfLeading(true)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks_timer_separator'])
            )
        }


        Column(){
          Text(this.showTime.substring(6, 8))
            .halfLeading(true)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks_timer_unit'])
            )
        }.attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks_timer_unit_background'])
        )
      }.width("100%").justifyContent(FlexAlign.SpaceAround).alignItems(VerticalAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks_timer'])
    )
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}