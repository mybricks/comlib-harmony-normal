import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { getStyleValueByPattern, parseMargin } from './utils/StyleMatching'

// Data 接口定义
export interface DataType {
  label: string
  hideLabel: boolean
  name: string
  value: number
  min: number,
  max: number,
  step: number
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
  @Trace step: number
  @Trace disabled: boolean = false

  constructor(config?: Partial<DataType>) {
    // 默认值
    this.label = config?.label ?? '开关'
    this.hideLabel = config?.hideLabel ?? false
    this.name = config?.name ?? '开关'
    this.value = config?.value ?? 0
    this.min = config?.min ?? 0
    this.max = config?.max ?? 999
    this.step = config?.step ?? 1
  }
}

// 其他接口定义保持不变
interface Inputs {
  setValue: (fn: (val: number, outputRels?: void) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  setLabel: (fn: (val: string) => void) => void
  setDisabled: (fn: (val: boolean, outputRels: void) => void) => void
}

interface Outputs {
  onChange: (value: number) => void
  setValueComplete: (value: boolean) => void
  returnValue: (value: number) => void
  resetValueComplete: (value: boolean) => void
  setDisabledComplete: (value: boolean) => void
}

@ComponentV2
export default struct MyBricksFormStepper {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  aboutToAppear(): void {
    this.inputs?.setValue((val, outputRels: AnyType) => {
      this.data.value = val;
      outputRels?.["setValueComplete"]?.(!!val);
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.data.value);
    })

    this.inputs?.resetValue((_: AnyType, outputRels: AnyType) => {
      this.data.value = 0;
      outputRels?.["resetValueComplete"]?.(false);
    })
  }

  build() {
    Column() {
      // CounterComponent({
      //   options: {
      //     type: CounterType.LIST,
      //     numberOptions: {
      //       min: this.data.min,
      //       value: this.data.value,
      //       max: this.data.max,
      //       onChange: (value: number) => {
      //         this.data.value = value
      //         this.outputs?.onChange?.(value)
      //
      //         this.parentSlot?._inputs?.["onChange"]?.({
      //           id: this.uid,
      //           value:this.data.value,
      //         });
      //       }
      //     },
      //   }
      // })

      Row(){
        //减少
        Column(){
          Text("-")
            .lineHeight(25)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.taroify-stepper__decrease'])
                .fontSize(25)
                .fontColor("#fa6400")
            )
        }
        .border({
          width: 1,
          color: "#fa6400",
          radius: 20,
          style: BorderStyle.Solid
        })
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.taroify-stepper__decrease'])
            .backgroundColor(Color.White)
        )
        .width(
          getStyleValueByPattern(
            this.styles,
            ['.taroify-stepper__decrease'],
            'width',
            24
          ))
        .height(
          getStyleValueByPattern(
            this.styles,
            ['.taroify-stepper__decrease'],
            'height',
            24
          ))
        .margin(parseMargin(this.styles['.taroify-stepper__decrease']))
        .onClick(()=>{
          const new_value = this.data.value - this.data.step
          if(new_value >= this.data.min){
            this.data.value = new_value
            this.outputs?.onChange?.(this.data.value)
            this.parentSlot?._inputs?.["onChange"]?.({
              id: this.uid,
              value:this.data.value,
            });
          }
        })
        //数字回显
        Column(){
          Text(String(this.data.value))
            .textAlign(TextAlign.Center)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.taroify-stepper__input input'])
                .fontSize(14)
                .fontColor('#323233')
            )
            .attributeModifier(
              new ApplyStyleModifier(this.styles['.taroify-stepper__input input'])
            )
            .width(
              getStyleValueByPattern(
                this.styles,
                ['.taroify-stepper__input input'],
                'width',
                32
              ))
            .height(
              getStyleValueByPattern(
                this.styles,
                ['.taroify-stepper__input input'],
                'height',
                24
              ))
            .margin(parseMargin(this.styles['.taroify-stepper__input input']))
        }.width("auto")
        //增加
        Column(){
          Text("+")
            .lineHeight(25)
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.taroify-stepper__increase'])
                .fontSize(25)
                .fontColor('#ffffff')
            )
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .border({
          width: 1,
          color: "#fa6400",
          radius: 24,
          style: BorderStyle.Solid
        })
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.taroify-stepper__increase'])
            .backgroundColor("#fa6400")
        )
        .width(
          getStyleValueByPattern(
            this.styles,
            ['.taroify-stepper__increase'],
            'width',
            24
          ))
        .height(
          getStyleValueByPattern(
            this.styles,
            ['.taroify-stepper__increase'],
            'height',
            24
          ))
        .margin(parseMargin(this.styles['.taroify-stepper__increase']))
        .onClick(()=>{
          const new_value = this.data.value + this.data.step
          if(new_value <= this.data.max){
            this.data.value = new_value

            this.outputs?.onChange?.(this.data.value)
            this.parentSlot?._inputs?.["onChange"]?.({
              id: this.uid,
              value:this.data.value,
            });
          }
        })
      }

    }
    .alignItems(HorizontalAlign.End)
    .justifyContent(FlexAlign.Start)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'] || {})
    )
    .attributeModifier(this.modifier)
  }
}