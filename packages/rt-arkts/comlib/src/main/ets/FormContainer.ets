
import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
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


@ComponentV2
struct MyBricksFormItem {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

  build() {

  }
}


// 数据类型定义
export interface DataType {
  items: FormItem[]
  skipValidation: boolean | string
  useLoading: boolean
  useSubmitButton: boolean
  submitButtonText: string
  itemLayout: string
}

// Data类实现
@ObservedV2
export class Data implements DataType {
  @Trace items: FormItem[]
  @Trace skipValidation: boolean | string
  @Trace useLoading: boolean
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

@ComponentV2
export default struct MyBricksFormContainer {
  @Param data: Data = new Data();
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

  build() {
    Text('TODO')
  }
}