import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import dayjs from 'dayjs'

type DateType = 'date' | 'time' | 'year-month' | 'year'

export interface DataType {
  value: number | undefined
  placeholder: string
  disabled: boolean
  type: DateType
  outputType?: string
  min: string | undefined
  max: string | undefined
  selectorTitle: string
  isSlot: boolean
}

@ObservedV2
export class Data implements DataType {
  @Trace value: number | undefined
  @Trace placeholder: string
  @Trace disabled: boolean
  @Trace type: DateType
  @Trace outputType?: string
  @Trace min: string | undefined
  @Trace max: string | undefined
  @Trace selectorTitle: string
  @Trace isSlot: boolean

  constructor(config?: DataType) {
    this.value = config?.value ?? undefined
    this.placeholder = config?.placeholder ?? '请选择'
    this.disabled = config?.disabled ?? false
    this.type = config?.type ?? 'date'
    if (config?.outputType) {
      this.outputType = config.outputType
    }
    this.min = config?.min ?? undefined
    this.max = config?.max ?? undefined
    this.selectorTitle = config?.selectorTitle ?? '选择时间'
    this.isSlot = config?.isSlot ?? false
  }
}

interface Inputs {
  setValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  setPlaceholder: (fn: (val: string) => void) => void
  setDisabled: (fn: (val: boolean) => void) => void
  setLabel: (fn: (val: string) => void) => void
}

interface Outputs {
  onChange: (value: number | string) => void
  onConfirm: (value: number) => void
  setValueComplete: (value: AnyType) => void
  resetValueComplete: (value: AnyType) => void
  returnValue: (value: number | undefined) => void
}

const FORMAT_MAP: AnyType = {
  date: "YYYY-MM-DD",
  time: "HH:mm",
  "year-month": "YYYY-MM",
  year: "YYYY"
}

const LAST_TEN_YEAR = new Date(new Date().setFullYear(new Date().getFullYear() - 10))
const AFTER_TEN_YEAR = new Date(new Date().setFullYear(new Date().getFullYear() + 10))

@ComponentV2
export default struct MyBricksFormDateTime {
  @Param data: Data = new Data()
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined
  @Param outputs?: Outputs = undefined
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Local showPicker: boolean = false
  @Local valueInDate: Date | undefined = undefined

  dialogController: CustomDialogController | null = null

  aboutToAppear(): void {
    this.dialogController = new CustomDialogController({
      builder: DateDialog({
        confirm: (val: Date) => {
          this.onSelect(val)
        },
        selectedDate: new Date(this.data.value ?? '')
      }),
      autoCancel: true,
      onWillDismiss:(dismissDialogAction: DismissDialogAction)=> {
        if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
          dismissDialogAction.dismiss();
        }
        if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
          dismissDialogAction.dismiss();
        }
      },
      alignment: DialogAlignment.Center,
      customStyle: false,
      cornerRadius: 32,
    })
    if (this.data.type === 'time') {
      this.dialogController = new CustomDialogController({
        builder: TimeDialog({
          confirm: (val: Date) => {
            this.onSelect(val)
          },
          selectedDate: new Date(this.data.value ?? '')
        }),
        autoCancel: true,
        onWillDismiss:(dismissDialogAction: DismissDialogAction)=> {
          if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
            dismissDialogAction.dismiss();
          }
          if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
            dismissDialogAction.dismiss();
          }
        },
        alignment: DialogAlignment.Center,
        customStyle: false,
        cornerRadius: 32,
      })
    }

    this.inputs?.setValue((val: AnyType, outputRels: AnyType) => {
      if (!val) {
        this.data.value = undefined
      } else if (typeof val === 'string') {
        const value = dayjs(val).valueOf()
        this.data.value = isNaN(value) ? undefined : value
      } else if (typeof val === 'number') {
        this.data.value = val
      } else if (val instanceof Date) {
        this.data.value = val.valueOf()
      }
      outputRels?.["setValueComplete"]?.(val)
    })

    this.inputs?.resetValue((_: AnyType, outputRels: AnyType) => {
      this.data.value = undefined
      outputRels?.["resetValueComplete"]?.()
    })

    this.inputs?.setPlaceholder((val) => {
      this.data.placeholder = val
    })

    this.inputs?.setDisabled((val) => {
      this.data.disabled = val
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.data.value)
    })
  }

  onSelect(newDate: Date) {
    // 检查解析后的日期是否有效
    if (isNaN(newDate.valueOf())) {
      console.error("Invalid date format:", newDate);
      return;
    }

    let selectDate: string | number;
    if (this.data.type === 'date' && this.data.outputType == "YYYY-MM-DD") {
      selectDate = dayjs(newDate.valueOf()).format("YYYY-MM-DD");
    } else {
      selectDate = newDate.valueOf()
    }

    this.data.value = newDate.valueOf()

    // 通知表单容器
    this.parentSlot?._inputs?.["onChange"]?.({
      id: this.uid,
      value: selectDate,
    });
    // 触发输出
    this.outputs?.onChange?.(selectDate);
  }

  private getRange(): AnyType {
    const format = (input: string) => {
      if (input === 'now') {
        return new Date()
      }
      return new Date(input)
    }

    return {
      min: !this.data.min ? LAST_TEN_YEAR : format(this.data.min),
      max: !this.data.max ? AFTER_TEN_YEAR : format(this.data.max)
    }
  }

  build() {
    Column() {
      Row() {
        Text(this.formatTimeDisplay(this.data.value) || this.data.placeholder)
          .fontSize(14)
          .layoutWeight(1)
          .fontColor(this.data.value ? '#000000' : '#999999')
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontSize(16)
          .renderingStrategy(SymbolRenderingStrategy.SINGLE)
          .fontColor(['#000000', Color.White])
      }
      .width('100%')
      .height(44)
      .backgroundColor(Color.White)
      .padding({ left: 16, right: 16 })
      .onClick(() => {
        this.dialogController?.open()
      })
      .attributeModifier(
        new ApplyRootStyleModifier(this.styles['root'])
      )
    }
  }

  private formatTimeDisplay(timestamp?: number): string {
    if (!timestamp) return ''
    const date = new Date(timestamp)
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')

    switch(this.data.type) {
      case 'date':
        return `${year}年${month}月${day}日`
      case 'year-month':
        return `${year}年${month}月`
      case 'year':
        return `${year}年`
      case 'time':
        return `${date.getHours()}:${date.getMinutes()}`
      default:
        return `${year}-${month}-${day}`
    }
  }
}

@CustomDialog
@Component
struct DateDialog {
  controller?: CustomDialogController;

  cancel: () => void = () => {
  }
  confirm: (val: Date) => void = () => {
  }

  @Prop selectedDate: Date = new Date()

  @Builder renderPicker() {
    DatePicker({
      start: LAST_TEN_YEAR,
      end: AFTER_TEN_YEAR,
    })
      .lunar(false)
      .onDateChange((value: Date) => {
        this.selectedDate = value
      })
  }

  build() {
    Column() {
      this.renderPicker()
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close();
              this.cancel();
            }
          }).backgroundColor(Color.Transparent)
            .fontColor('#FF0A59F7')
        Button('确认')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close();
              this.confirm(this.selectedDate);
            }
          })
          .backgroundColor(Color.Transparent)
          .fontColor('#FF0A59F7')
      }.margin({
        top: 16,
      })
    }
      .padding({
        top: 24,
        left: 24,
        right: 24,
        bottom: 8
      })
  }
}

@CustomDialog
@Component
struct TimeDialog {
  controller?: CustomDialogController;

  cancel: () => void = () => {
  }
  confirm: (val: Date) => void = () => {
  }

  @Prop selectedDate: Date = new Date()

  @Builder renderPicker() {
    TimePicker({
      selected: this.selectedDate
    })
      .useMilitaryTime(true)
      .onChange((value: TimePickerResult) => {
        if(value.hour >= 0) {
          const resultDate = new Date()
          resultDate.setHours(value.hour, value.minute);
          this.selectedDate = resultDate
        }
      })
  }

  build() {
    Column() {
      this.renderPicker()
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close();
              this.cancel();
            }
          }).backgroundColor(Color.Transparent)
          .fontColor('#FF0A59F7')
        Button('确认')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close();
              this.confirm(this.selectedDate);
            }
          })
          .backgroundColor(Color.Transparent)
          .fontColor('#FF0A59F7')
      }.margin({
        top: 16,
      })
    }
    .padding({
      top: 24,
      left: 24,
      right: 24,
      bottom: 8
    })
  }
}

