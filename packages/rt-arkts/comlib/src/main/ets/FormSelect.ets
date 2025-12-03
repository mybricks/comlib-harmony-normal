import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'
import { parseMargin } from './utils/StyleMatching';

export interface DataType {
  label?: string;
  name?: string;
  placeholder?: string;
  value?: string;
  options?: Option[];
  arrow?: "right" | "down" | "none"
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

interface Option {
  label: string;
  value: string;
  disabled?: boolean;
  checked?: boolean
}

@ObservedV2
export class Data implements DataType {
  @Trace label?: string
  @Trace name?: string
  @Trace placeholder?: string
  @Trace value?: string
  @Trace options?: Option[]
  @Trace arrow?: 'right' | 'down' | 'none' | undefined

  constructor(config: DataType) {
    this.label = config?.label
    this.name = config?.name
    this.placeholder = config?.placeholder
    this.value = config?.value
    this.options = config?.options
    this.arrow = config?.arrow
  }

  @Computed
  get optionLabels(): string[] {
    return this.options?.map(option => option.label) || []
  }


}

interface Inputs {
  setValue: (fn: (val: string, outputRels?: void) => void) => void
  getValue:  (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: AnyType) => void) => void
  setOptions:  (fn: (val: Option, outputRels?: AnyType) => void) => void
  setDisabled:(fn: (val: boolean, outputRels: void) => void) => void
}

interface Outputs {
  onChange: (value: string) => void
  onCancel: (value: string) => void
  setValueComplete: (value: string) => void
  returnValue: (value: string) => void
  resetValueComplete: (value: string) => void
  setOptionsComplete: (value: string) => void
  setDisabledComplete: (value: string) => void
}

export interface SlotsParams {
  id: string,
  style?: CSSProperties
}

@Builder function emptySlot(params: SlotsParams) {}

@ComponentV2
export default struct MyBricksFormSelect {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;

  @Local selectedIndex?: number = 0

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  aboutToAppear(): void {
    //连线设置下拉框值
    this.inputs?.setValue((val, outputRels: AnyType) => {
      this.data.value = String(val);
      outputRels?.["setValueComplete"]?.(this.data.value);
    })

    this.inputs?.getValue((_: AnyType, outputRels: AnyType) => {
      outputRels?.["returnValue"]?.(this.data.value);
    })

    this.inputs?.resetValue((_: AnyType, outputRels: AnyType) => {
      this.data.value = '';
      outputRels?.["resetValueComplete"]?.(this.data.value);
    })

    this.inputs?.setOptions((_: AnyType, outputRels: AnyType) => {
      this.data.options =  _
      outputRels?.["setOptionsComplete"]?.(this.data.options);
    })
  }

  build() {
    Flex({direction:FlexDirection.Row,alignItems:ItemAlign.Center,justifyContent:FlexAlign.SpaceBetween}) {
      Text(this.data.value || this.data.placeholder)
        .attributeModifier(
          new ApplyFontStyleModifier(this.data.value ? this.styles['.mybricks-input'] : this.styles['.mybricks-placeholder'])
            .fontSize(14)
            .fontColor(this.data.value ?'#000000' : '#C8C9CC')
        )
      if(this.data.arrow != 'none'){
        SymbolGlyph(this.data.arrow === 'right' ? $r('sys.symbol.chevron_right') : $r('sys.symbol.chevron_down'))
          .renderingStrategy(SymbolRenderingStrategy.SINGLE)
          .fontSize(this.styles['.mybricks-arrow'].fontSize ? parseFloat(this.styles['.mybricks-arrow'].fontSize as string) : 14)
          .fontColor([this.styles['.mybricks-arrow'].color ?? '#000000'])
          .fontWeight(this.styles['.mybricks-arrow'].fontWeight ?? 500)
          .attributeModifier(
            new ApplyStyleModifier(this.styles['.mybricks-arrow'])
          )
          .margin(parseMargin(this.styles['.mybricks-arrow']))
      }

    }
    .width("100%")
    .constraintSize({ minHeight: 24 })
    .onClick(()=>{
      TextPickerDialog.show({
        range: this.data.optionLabels,
        selected: this.selectedIndex,
        canLoop:false,
        onAccept: (value: TextPickerResult) => {
          console.log("onAccept",value)

          const _label = this.data?.options?.[Number(value.index)].label
          const _value = this.data?.options?.[Number(value.index)].value
          const _index = value.index

          this.selectedIndex = Number(value.index)

          const result: Option = {
            label:_label,
            value:_value
          }
          // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
          this.data.value = _value
          this.outputs?.onChange(_value)
          this.parentSlot?._inputs?.["onChange"]?.({
            id: this.uid,
            value,
          });

        },
        onCancel: () => {
          this.outputs?.onCancel(this.data.value)
          console.info("TextPickerDialog:onCancel()");
        },
        onChange: (value: TextPickerResult) => {
          console.info("TextPickerDialog:onChange()" + JSON.stringify(value));
        },
        onScrollStop: (value: TextPickerResult) => {
          console.info("TextPickerDialog:onScrollStop()" + JSON.stringify(value));
        },
        onDidAppear: () => {
          console.info("TextPickerDialog:onDidAppear()");
        },
        onDidDisappear: () => {
          console.info("TextPickerDialog:onDidDisappear()");
        },
        onWillAppear: () => {
          console.info("TextPickerDialog:onWillAppear()");
        },
        onWillDisappear: () => {
          console.info("TextPickerDialog:onWillDisappear()");
        }
      });
    })
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-select'])
    )

    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'] || {})
    )
    .attributeModifier(this.modifier)
  }
}
