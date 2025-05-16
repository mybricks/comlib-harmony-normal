import { promptAction } from '@kit.ArkUI';
import { AnyType } from './types'

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  @Trace dynamic: boolean = false
  @Trace title?: string
  @Trace duration?: number | string = 1000
  @Trace mask?: boolean = false
  @Trace asynchronous?: boolean = false

  constructor(config?: DataType) {
    this.title = config?.title
    this.dynamic = config?.dynamic
    this.duration = config?.duration
    this.mask = config?.mask
    this.asynchronous = config?.asynchronous ?? false
  }
}

interface Inputs {
  showToast?: (fn: (config: DataType, relOutputs?: AnyType) => void) => void
}

interface Outputs {
  afterShowToast: (value?: AnyType) => void
}

interface IOContext {
  data: DataType
  inputs: Inputs
  outputs: Outputs
}

export default (context: IOContext) => {
  const data: Data = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs

  inputs.showToast?.((val: DataType) => {
    if (data?.dynamic) {
      // 动态输入
      try {
        promptAction.showToast({
          message: typeof val === 'string' ? val : data.title,
          duration: Number(val?.duration ?? data.duration ?? 1000)
        })
        if (data.asynchronous) {
          setTimeout(() => {
            outputs.afterShowToast(val);
          }, Number(val?.duration ?? data.duration ?? 1000)); //提示结束后触发
        } else {
          outputs.afterShowToast(val);
        }
      } catch {}

    } else {
      // 非动态输入
      try {
        promptAction.showToast({
          message: data.title,
          duration: Number(data.duration || 1000)
        })
        if (data.asynchronous) {
          setTimeout(() => {
            outputs.afterShowToast(val);
          }, Number(data.duration || 1000)); //提示结束后触发
        } else {
          outputs.afterShowToast(val);
        }
      } catch (error) {};
    }
  })

}