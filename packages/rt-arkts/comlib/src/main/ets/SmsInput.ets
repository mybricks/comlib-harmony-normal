import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  value: string,
  length: number,
  gutter: number,
  countdown: number,
  countDownText: string,
  retryText: string,
  buttonAvailable: boolean,
  counting: boolean,
  currentCount: number,
  isError: boolean,
  desc: string
}

@ObservedV2
export class Data implements DataType {
  @Trace value: string
  @Trace length: number
  @Trace gutter: number
  @Trace countdown: number
  @Trace countDownText: string
  @Trace retryText: string
  @Trace buttonAvailable: boolean
  @Trace counting: boolean
  @Trace currentCount: number
  @Trace isError: boolean
  @Trace desc: string

  constructor(config?: Partial<DataType>) {
    this.value = config?.value ?? '' //已加
    this.length = config?.length ?? 6
    this.gutter = config?.gutter ?? 10  //已加：间距
    this.countdown = config?.countdown ?? 60 //已加：倒计时秒数
    this.countDownText = config?.countDownText ?? 's后重新获取验证码' //已加
    this.retryText = config?.retryText ?? '重新获取验证码' //已加
    this.buttonAvailable = config?.buttonAvailable ?? true //已加
    this.counting = config?.counting ?? false //已加
    this.currentCount = config?.currentCount ?? 0 //已加
    this.isError = config?.isError ?? false
    this.desc = config?.desc ?? "收不到验证码？"//已加
  }
}

interface Inputs {
  startCountdown: (fn: (val: AnyType, outputRels?: AnyType) => void) => void //已加
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void  //已加
  resetValue: (fn: (val: AnyType,outputRels?: AnyType) => void) => void  //已加
}

interface Outputs {
  onChange: (value: string) => void  //已加
  onComplete: (value: string) => void //已加
  onSendSMS: (value: string) => void //已加，重新发送验证码
  startCountdownDone: (value: string) => void //已加
  resetValueDone: (value: string) => void //已加
  returnValue: (value: string) => void //已加
  onClickDesc:  (value: string) => void
}

@ComponentV2
export default struct SmsInput {
  @Param data: Data = new Data()
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined
  @Param outputs?: Outputs = undefined

  @Local code: string[] = ["", "", "", ""]
  @Local currentIndex: number = 0
  @Local cursorVisible: boolean = true
  @Local alpha:number = 0

  private timer: number = -1
  private countdownTimer: number = -1

  // 动画控制器
  private animateTo() {
    animateTo({
      duration: 400,      // 动画时长（毫秒）
      curve: Curve.EaseOut // 动画曲线
    }, () => {
      this.alpha = this.cursorVisible ? 1 : 0
    })
  }

  aboutToAppear() {


    this.timer = setInterval(() => {
      this.cursorVisible = !this.cursorVisible
      this.animateTo()
    }, 500)

    this.inputs?.startCountdown((val: AnyType, outputRels: AnyType) => {
      this.handleRetryClick()
      outputRels?.["startCountdownDone"]?.(val);
    })

    this.inputs?.getValue((val: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.data.value);
    })

    this.inputs?.resetValue((val: AnyType, outputRels: AnyType) => {
      this.data.value = ""
      this.code = ["","","",""]
      outputRels?.["resetValueDone"]?.(this.data.value);
    })
  }

  aboutToDisappear() {
    clearInterval(this.timer)
    this.clearCountdownTimer()
  }

  private clearCountdownTimer() {
    if (this.countdownTimer !== -1) {
      clearInterval(this.countdownTimer)
      this.countdownTimer = -1
    }
  }

  // 处理重新获取验证码点击
  private handleRetryClick() {
    if (this.data.counting || !this.data.buttonAvailable) return

    // 触发发送验证码回调
    if (this.outputs?.onSendSMS) {
      this.outputs.onSendSMS(this.code.join(''))
    }

    // 初始化倒计时状态
    this.data.counting = true
    this.data.currentCount = this.data.countdown

    // 启动倒计时
    this.clearCountdownTimer()
    this.countdownTimer = setInterval(() => {
      if (this.data.currentCount > 0) {
        this.data.currentCount--
      } else {
        this.clearCountdownTimer()
        this.data.counting = false
        this.data.currentCount = 0
      }
    }, 1000)
  }


  @Builder
  CodeCell(index: number) {
    Column() {
      // 光标动画
      if (this.currentIndex === index ) {
        Divider()
          .color('#333333')
          .strokeWidth(4)
          .height(30)
          .vertical(true)
          .opacity(this.alpha)
      }else{
        // 显示输入内容
        Text(this.code[index] || '') // 处理undefined情况
          .fontSize(35)
          .fontColor('#424242')
          .fontWeight("600")
        // .backgroundColor('#C8C8C8')
      }
    }
    // .width(60)
    .layoutWeight(1)
    .height(60)
    .justifyContent(FlexAlign.Center)
    .border({
      width: { bottom: 1.5 },
      color:this.currentIndex >= index ? '#333333' : '#F6F6F6'
    })
    .onClick(() => {
      console.log("onclick",this.currentIndex,index)
      if(this.currentIndex === index){
        this.currentIndex = Math.min(index, this.code.filter(c => c).length)
        focusControl.requestFocus('sms-code-input')
      }

    })
  }

  build() {
    Column() {
      // 隐藏的输入框
      TextInput({ text: this.code.join('') })
        .width(0)
        .height(0)
        .backgroundColor(Color.Transparent)
        .maxLength(4)
        .type(InputType.Number)
        .key('sms-code-input')
        .onChange((value: string) => {
          this.data.value = value
          // 更新用来显示的code数组
          this.code = value.padEnd(4, ' ').split('').slice(0, 4)
          // 更新当前焦点位置
          this.currentIndex = value.length

          console.log("onchange",this.code,this.currentIndex,value)

          this.outputs?.onChange?.(this.data.value);
          if (this.code.length === this.currentIndex) {
            this.outputs?.onComplete?.(this.data.value)
          }

        })
        .onFocus(() => {
          this.currentIndex = Math.min(this.code.join('').length, 4) // 允许最大到4
          console.log("onfocus",this.currentIndex,this.code)
        })

      // 验证码显示区域
      Row({ space: this.data.gutter }) {
        ForEach(this.code, (_:AnyType, index) => {
          this.CodeCell(index)
        }, (_:AnyType, index) => index.toString())
      }
      .margin({ top: 0 })
      .width('100%')

      Row(){
        Text(this.data.counting ? `${this.data.currentCount}${this.data.countDownText}` :this.data.retryText)
          .fontColor(this.data.counting ? '#787878' : '#548CFF')
          .fontSize(14)
          .onClick(()=>{
            this.handleRetryClick()
          })

        Text(this.data.counting ? "":this.data.desc)
          .fontColor('#4B4B4B')
          .fontSize(14)
          .onClick(()=>{
            this.outputs?.onClickDesc?.(this.data.value)
          }
          )
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({top:25})

    }

    .attributeModifier(new ApplyRootStyleModifier(this.styles['root']))
  }
}