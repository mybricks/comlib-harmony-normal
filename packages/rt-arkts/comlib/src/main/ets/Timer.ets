import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { parseMargin, parseSize } from './utils/StyleMatching'

export interface DataType {
  clockType?: "realtime" | "countdown" | "timer" | string,
  countdown?: string,
  startImmediately?: boolean
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
  @Trace clockType?: string
  @Trace countdown?: string
  @Trace startImmediately?: boolean

  constructor(config: DataType) {
    this.clockType = config.clockType
    this.countdown = config.countdown
    this.startImmediately = config.startImmediately
  }
}

interface Inputs {
  countDownTimeStamp?: (fn: (p: AnyType) => void) => void
  setTimerStartTimeStamp?:(fn: (val: AnyType, outputRels: void) => void) => void
  start?: (fn: (p?: AnyType) => void) => void
  pause?: (fn: (p?: AnyType) => void) => void
  finish?: (fn: (p?: AnyType) => void) => void
}

interface Outputs {
  currentTime: (value?: AnyType) => void
  finishCountDown: (value?: AnyType) => void
  setTimerStartTimeStampComplete: (value?: AnyType) => void
}

@ComponentV2
export default struct MyBricksTimer {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Local showTime: string = "--:--:--"
  @Local countDown: string = ""
  private timerID: number = -1
  private elapsedTime: number = 0
  private isFinished: boolean = true
  private hasCustomStartTime: boolean = false // 新增：标记是否设置了自定义起始时间

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined
  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

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
    if(timeString == undefined){
      return 0
    }
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

  updateTimer(updateElapsedTime: boolean = true) {
    if (updateElapsedTime) {
      this.elapsedTime += 1000
    }
    this.showTime = this.formatTimeDiff(this.elapsedTime)
    this.outputs?.currentTime?.(this.elapsedTime.toString())
  }

  updateCountDown(updateElapsedTime: boolean = true) {
    if (updateElapsedTime) {
      this.elapsedTime += 1000
    }
    const countDownStamp = this.timeStringToTimestamp(this.countDown)
    const remainingTime = countDownStamp - this.elapsedTime

    if (remainingTime >= 0) {
      this.showTime = this.formatTimeDiff(remainingTime)
      this.outputs?.currentTime?.(remainingTime.toString())
    } else {
      this.finishTimer()
      this.outputs?.finishCountDown?.(countDownStamp.toString())
    }
  }

  startTimer() {
    if (this.isFinished) {
      // 只有在没有设置自定义起始时间时才重置为0
      if (!this.hasCustomStartTime) {
        this.elapsedTime = 0
      }
      this.isFinished = false
    }

    if (this.timerID !== -1) {
      clearInterval(this.timerID)
    }

    switch (this.data.clockType) {
      case "timer":
        this.updateTimer(false)
        this.timerID = setInterval(() => {
          this.updateTimer()
        }, 1000)
        break
      case "countdown":
        this.updateCountDown(false)
        this.timerID = setInterval(() => {
          this.updateCountDown()
        }, 1000)
        break
    }
  }

  pauseTimer() {
    if (this.timerID !== -1) {
      clearInterval(this.timerID)
      this.timerID = -1
    }
  }

  finishTimer() {
    if (this.timerID !== -1) {
      clearInterval(this.timerID)
      this.timerID = -1
    }
    this.isFinished = true
    this.elapsedTime = 0
    this.hasCustomStartTime = false // 重置自定义起始时间标记
  }

  aboutToAppear(): void {
    // 添加控制接口
    this.inputs?.start?.(() => {
      this.startTimer()
    })

    this.inputs?.pause?.(() => {
      this.pauseTimer()
    })

    this.inputs?.finish?.(() => {
      this.finishTimer()
    })

    // 设置输入监听
    this.inputs?.countDownTimeStamp?.((text: string) => {
      this.countDown = text
    })

    // 新增：设置计时器起始时间
    this.inputs?.setTimerStartTimeStamp?.((ds: string, rel: AnyType) => {
      const timeStamp = this.timeStringToTimestamp(ds)
      this.elapsedTime = timeStamp
      this.hasCustomStartTime = true // 标记已设置自定义起始时间
      this.showTime = this.formatTimeDiff(this.elapsedTime)
      rel?.["setTimerStartTimeStampComplete"]?.(this.elapsedTime.toString())
    })

    // 初始化定时器
    if (this.data.clockType) {
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
        case "countdown":
          if (this.data.startImmediately !== false) {
            this.countDown = this.data.countdown || ""
            this.elapsedTime = 0
            this.isFinished = false
            this.startTimer()
          }
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
          Text(this.showTime?.split(':')?.[0] || '--')
            .halfLeading(true)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks_timer_unit'])
                .fontSize(12)
            )
        }.attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks_timer_unit_background'])
            .backgroundColor('#EFEFEF')
            .borderRadius(2)
            .padding({
              top: 1,
              bottom: 1,
              left: 1,
              right: 1
            })
        )
        .width(parseSize(this.styles['.mybricks_timer_unit_background']?.width) || 20)
        .height(parseSize(this.styles['.mybricks_timer_unit_background']?.height) || 'auto')

        Column(){
          Text(":")
            .halfLeading(true)
            .width(12)
            .textAlign(TextAlign.Center)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks_timer_separator'])
            )
            .margin(parseMargin(this.styles['.mybricks_timer_separator']))
        }

        Column(){
          Text(this.showTime?.split(':')?.[1] || '--')
            .halfLeading(true)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks_timer_unit'])
                .fontSize(12)
            )
        }.attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks_timer_unit_background'])
            .backgroundColor('#EFEFEF')
            .borderRadius(2)
            .padding({
              top: 1,
              bottom: 1,
              left: 1,
              right: 1
            })
        )
        .width(parseSize(this.styles['.mybricks_timer_unit_background']?.width) || 20)
        .height(parseSize(this.styles['.mybricks_timer_unit_background']?.height) || 'auto')

        Column(){
          Text(":")
            .halfLeading(true)
            .width(12)
            .textAlign(TextAlign.Center)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks_timer_separator'])
            )
            .margin(parseMargin(this.styles['.mybricks_timer_separator']))
        }

        Column(){
          Text(this.showTime?.split(':')?.[2] || '--')
            .halfLeading(true)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks_timer_unit'])
                .fontSize(12)
            )
        }.attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks_timer_unit_background'])
            .backgroundColor('#EFEFEF')
            .borderRadius(2)
            .padding({
              top: 1,
              bottom: 1,
              left: 1,
              right: 1
            })
        )
        .width(parseSize(this.styles['.mybricks_timer_unit_background']?.width) || 20)
        .height(parseSize(this.styles['.mybricks_timer_unit_background']?.height) || 'auto')
      }.width("100%").justifyContent(FlexAlign.SpaceAround).alignItems(VerticalAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks_timer'])
    )
    .attributeModifier(this.modifier)
  }
}