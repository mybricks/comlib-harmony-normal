import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import dayjs from 'dayjs'

type DateType = 'date' | 'time' | 'year-month' | 'year'

export interface DataType {
  value: number | undefined
  placeholder: string
  disabled: boolean
  type: DateType
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
  @Trace min: string | undefined
  @Trace max: string | undefined
  @Trace selectorTitle: string
  @Trace isSlot: boolean

  constructor(config?: DataType) {
    this.value = config?.value ?? undefined
    this.placeholder = config?.placeholder ?? '请选择'
    this.disabled = config?.disabled ?? false
    this.type = config?.type ?? 'date'
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
  onChange: (value: number) => void
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

  aboutToAppear(): void {
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
  //
  // @Builder
  // TimePickerContent() {
  //   Column() {
  //     DatePicker({
  //       start: new Date(this.getRange().min),
  //       end: new Date(this.getRange().max),
  //       selected: this.valueInDate || new Date()
  //     })
  //       .onChange((value: DatePickerResult) => {
  //         const date = new Date(value.year, value.month, value.day)
  //         this.outputs?.onChange?.(date.valueOf())
  //       })
  //       .attributeModifier(
  //         new ApplyStyleModifier(this.styles['.picker-content'])
  //       )
  //   }
  // }

  build() {
    Column() {
      Row() {
        Text(this.formatTimeDisplay(this.data.value) || this.data.placeholder)
          .fontSize(14)
          .fontColor(this.data.value ? '#000000' : '#999999')
        // Image($r('app.media.ic_arrow_right'))
        //   .width(16)
        //   .height(16)
      }
      .width('100%')
      .height(44)
      .backgroundColor(Color.White)
      .padding({ left: 16, right: 16 })
      .onClick(() => {
        TimePickerDialog.show({
          onAccept: (value: TimePickerResult) => {
            // 设置selectTime为按下确定按钮时的时间，这样当弹窗再次弹出时显示选中的为上一次确定的时间
            if (value.hour != undefined && value.minute != undefined) {
              // this.selectTime.setHours(value.hour, value.minute);
              console.info("TimePickerDialog:onAccept()" + JSON.stringify(value));
            }
          },
          onCancel: () => {
            console.info("TimePickerDialog:onCancel()");
          },
        })
      })
      .attributeModifier(
        new ApplyRootStyleModifier(this.styles['root'])
      )

      // if (this.showPicker) {
      //   Panel() {
      //     this.TimePickerContent()
      //   }
      //   .mode(PanelMode.Full)
      //   .dragBar(true)
      //   .onChange((width: number, height: number, mode: PanelMode) => {
      //     if (mode === PanelMode.Mini) {
      //       this.showPicker = false
      //     }
      //   })
      // }
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