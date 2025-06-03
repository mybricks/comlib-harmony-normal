import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { ObjectUtils, isObject } from './utils/Helper'
import { AnyType } from './types'

interface FormItem {
  id: string
  name: string
  label: string
  rules?: AnyType[]
  hidden?: boolean
  hideLabel?: boolean
  icon?: string
  itemLayout?: string
  visible?: boolean
  index?: number
  comName?: string
}

@Builder
function emptyContent() {
}

@ComponentV2
export struct MyBricksFormItem {
  @Param @Require label?: string
  @Param layout: string = 'horizontal'
  @Param required: boolean = false
  @Consumer() formLayout: string = 'null';
  @BuilderParam content: () => void = emptyContent;

  @Computed
  get isHorizontal() {
    const layout = this.formLayout !== 'null' ? this.formLayout : this.layout;
    return layout === 'horizontal'
  }

  build() {
    Flex({
      direction: this.isHorizontal ? FlexDirection.Row : FlexDirection.Column
    }) {
      Row() {
        if (!!this.label) {
          if (this.required) {
            Text("*")
              .position({
                x: 0,
                y: 0
              })
          }
          Text(this.label) {
          }
          .width('auto')
          .margin({
            right: 12
          })
          .fontSize(14)
        }
        Column() {
          this.content()
        }
        .width('auto')
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
    }.padding({
      top: 10,
      bottom: 10,
      left: 16,
      right: 16
    })
  }
}


// 数据类型定义
export interface DataType {
  items?: FormItem[]
  skipValidation?: boolean | string
  useLoading?: boolean
  useSubmitButton?: boolean
  submitButtonText?: string
  itemLayout?: string
}

// Data类实现
@ObservedV2
export class Data implements DataType {
  @Trace items: FormItem[]
  @Trace skipValidation?: boolean | string
  @Trace useLoading?: boolean
  @Trace useSubmitButton: boolean
  @Trace submitButtonText: string
  @Trace itemLayout: string

  constructor(config?: DataType) {
    this.items = config?.items ?? []
    this.skipValidation = config?.skipValidation ?? false
    this.useLoading = config?.useLoading ?? false
    this.useSubmitButton = config?.useSubmitButton ?? true
    this.submitButtonText = config?.submitButtonText ?? '提交'
    this.itemLayout = config?.itemLayout ?? 'horizontal'
  }
}

// 输入接口定义
interface Inputs {
  submit: (fn: (val: AnyType, outputRels: AnyType) => void) => void
  submitAndMerge: (fn: (val: AnyType, outputRels: AnyType) => void) => void
  resetFields: (fn: (val: AnyType, outputRels: AnyType) => void) => void
  finishLoading: (fn: () => void) => void
  setFieldsValue: (fn: (val: Record<string, AnyType>) => void) => void
  getFieldsValue: (fn: (val: AnyType, outputRels: AnyType) => void) => void
}

// 输出接口定义
interface Outputs {
  onSubmit: (values: Record<string, AnyType>) => void
  onMergeSubmit: (values: Record<string, AnyType>) => void
  onReset: () => void
  returnValues: (values: Record<string, AnyType>) => void
}


interface ItemWarp {
  wrap: WrappedBuilder<AnyType[]>
  params: AnyType
}

export interface SlotsParams {
  id: string,
  style?: CSSProperties
  _inputs?: AnyType,
  itemWrap: (p: AnyType) => ItemWarp
}

@Builder
function emptySlot(params: SlotsParams) {
}

enum RuleKeys {
  REQUIRED = 'required',
  MIN = 'min',
  MAX = 'max',
  MIN_LENGTH = 'minLength',
  MAX_LENGTH = 'maxLength',
  REG_EXP = 'regExp'
}

// 基础规则接口
interface BaseRule {
  key: RuleKeys;
  status: boolean;
  visible: boolean;
  title: string;
  message: string;
}

// 必填规则
interface RequiredRule extends BaseRule {
  key: RuleKeys.REQUIRED;
}

// 正则表达式规则
interface RegExpRule extends BaseRule {
  key: RuleKeys.REG_EXP;
  regExr: string;
}

// 最小长度规则
interface MinLengthRule extends BaseRule {
  key: RuleKeys.MIN_LENGTH;
  limitMinLength: number[];
}

// 最大长度规则
interface MaxLengthRule extends BaseRule {
  key: RuleKeys.MAX_LENGTH;
  limitMaxLength: number[];
}

// 最小值规则
interface MinValueRule extends BaseRule {
  key: RuleKeys.MIN;
  limitMinValue: number[];
}

// 最大值规则
interface MaxValueRule extends BaseRule {
  key: RuleKeys.MAX;
  limitMaxValue: number[];
}

// 规则联合类型
type Rule = RequiredRule | RegExpRule | MinLengthRule | MaxLengthRule | MinValueRule | MaxValueRule;

interface RuleErrorInfo {
  name: string;
  message: string;
}

interface ValidateResult {
  values: Record<string, AnyType>,
  errorInfos: RuleErrorInfo[]
}

interface FieldValue {
  id: string,
  name: string,
  value: AnyType
}

@ObservedV2
class FormValuesController {
  @Trace values: Map<string, AnyType> = new Map();
  @Trace errors: RuleErrorInfo[] = [];
  private rules: Map<string, Rule[]> = new Map();

  setValues(values: Record<string, AnyType>): void {
    Object.keys(values).forEach((key) => {
      this.values.set(key, values[key]);
    })
  }

  initValues(values: Record<string, AnyType>): void {
    this.values.clear();
    this.setValues(values);
  }

  resetValues(): void {
    this.values.clear();
    this.errors = [];
  }

  getValues(): Record<string, AnyType> {
    const result: AnyType = {};
    this.values.forEach((value: AnyType, key) => {
      result[key] = value;
    });
    return result;
  }

  setFieldValue(name: string, value: AnyType): void {
    this.values.set(name, value);
  }

  setFieldRule(name: string, rules: Rule[]): void {
    this.rules.set(name, rules);
  }

  private async validateField(name: string, value: AnyType): Promise<boolean> {
    const rules = this.rules.get(name);
    if (!rules) {
      return true;
    }

    for (const rule of rules) {
      if (!rule.status) {
        continue;
      }

      switch (rule.key) {
        case RuleKeys.REQUIRED:
          if (value === undefined || value === null || value === '') {
            this.errors.push({ name, message: rule.message });
            return false;
          }
          break;

        case RuleKeys.REG_EXP:
          if (!new RegExp(rule.regExr).test(String(value))) {
            this.errors.push({ name, message: rule.message });
            return false;
          }
          break;

        case RuleKeys.MIN_LENGTH:
          if (String(value).length < rule.limitMinLength[0]) {
            this.errors.push({ name, message: rule.message });
            return false;
          }
          break;

        case RuleKeys.MAX_LENGTH:
          if (String(value).length > rule.limitMaxLength[0]) {
            this.errors.push({ name, message: rule.message });
            return false;
          }
          break;

        case RuleKeys.MIN:
          if (Number(value) < rule.limitMinValue[0]) {
            this.errors.push({ name, message: rule.message });
            return false;
          }
          break;

        case RuleKeys.MAX:
          if (Number(value) > rule.limitMaxValue[0]) {
            this.errors.push({ name, message: rule.message });
            return false;
          }
          break;
      }
    }
    return true;
  }

  async validate(): Promise<ValidateResult> {
    this.errors = [];
    const validationPromises: Array<Promise<boolean>> = [];

    this.values.forEach((value: AnyType, name) => {
      validationPromises.push(this.validateField(name, value));
    });

    const results: boolean[] = await Promise.all(validationPromises);
    // 如果校验正确
    if (results.every((result: boolean) => result === true)) {
      return {
        values: this.getValues(),
        errorInfos: []
      }
    }
    // 如果校验失败
    return {
      values: this.getValues(),
      errorInfos: this.errors
    }
  }
}

@ComponentV2
export default struct MyBricksFormContainer {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;
  @Provider() formLayout: string = 'null'
  /** 按钮loading */
  @Local loading: boolean = false
  @Local formInstance: FormValuesController = new FormValuesController()

  aboutToAppear(): void {
    // this.formLayout = this.data.itemLayout
    this.formLayout = 'vertical'


    this.inputs?.submit?.((val: AnyType, outputRels: AnyType) => {
      this.formInstance.validate().then((values) => {
        outputRels?.['onSubmit']?.(values)
      })
    })

    this.inputs?.submitAndMerge?.((val: object, outputRels: AnyType) => {
      const _val: AnyType = isObject(val) ? val : {};

      this.formInstance.validate()
        .then((res) => {
          outputRels?.["onMergeSubmit"]?.(ObjectUtils.assign({}, res, _val));
        })
        .catch(() => {
        });
    });

    this.inputs?.getFieldsValue?.((val: AnyType, outputRels: AnyType) => {
      const values = this.formInstance.getValues();
      outputRels?.['returnValues']?.(values)
    })


  }

  getFormItem(change: FieldValue) {
    return this.data.items.find(item => {
      item.id === change.id
    })
  }

  slotsInputs = (): AnyType => {
    return {
      onChange: (changeAction: FieldValue) => {
        const formItem = this.getFormItem(changeAction)
        if (formItem) {
          this.formInstance.setFieldValue(formItem.name || formItem.label, changeAction.value);
        }
      },
      // setProps: () => {}
    }
  }

  @Builder
  submitButton() {
    if (this.data.useSubmitButton) {
      Button() {
        Text(this.data.submitButtonText)
          .attributeModifier(
            new ApplyFontStyleModifier(this.styles['.mybricks-submit .taroify-button'])
              .fontColor('#ffffff')
              .fontSize(14)
          )
      }
        .width('100%')
        .height(44)
        .onClick(() => {
          // 异步提交中
          if (this.data.useLoading && this.loading) {
            return;
          }

          if (this.data.useLoading) {
            this.loading = true
          }

          switch (this.data.skipValidation) {
            case false:
            case 'hidden':
            case "all":
              // 校验所有表单项
              this.formInstance
              ?.validate()
                .then((res) => {
                  this.outputs?.onSubmit?.(res);
                })
                .catch((err: AnyType) => {
                  // 遇到异常，自动回滚 loading 状态
                  this.loading = false;
                });
              break;
            case true:
            case 'none':
              // 不校验所有的表单项
              this.outputs?.onSubmit?.(this.formInstance?.getValues());
              break;
          }
        })
        .type(ButtonType.Normal)
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-submit .taroify-button'])
            .borderRadius(5)
            .backgroundColor('#FA6400')
        )
    }
  }

  build() {
    Column() {
      this.slots({
        id: 'content',
        _inputs: this.slotsInputs,
        itemWrap: (com: AnyType): AnyType => {
          return {
            wrap: wrapBuilder(FormItemWrap),
            params: {
              label: '表单项'
            } as AnyType
          }
        }
      })
      this.submitButton()
    }
  }
}

@Builder
function FormItemWrap(build: WrappedBuilder<AnyType>, params: AnyType) {
  MyBricksFormItem({
    label: '表单'
  }) {
    build.builder(params)
  }
}

