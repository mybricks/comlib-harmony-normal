import { AnyType } from './types'

enum InputIds {
  Trigger = 'trigger'
}

enum OutputIds {
  Trigger = 'trigger'
}

export interface DataType {
  delay: number,
  isleading?: boolean
}

/**
 * 数据源
 * @param delay 延迟时间
 * @param isleading 是否立即执行
 */
@ObservedV2
class Data implements DataType {
  delay: number = 0
  isleading?: boolean = false

  constructor(config?: DataType) {
    if (config) {
      this.delay = config.delay
      this.isleading = config.isleading
    }
  }
}

interface RuntimeParams<T> {
  env: AnyType
  data: T
  outputs: Record<string, Function>
  inputs: Record<string, Function>
}

export default function(props: RuntimeParams<Data>) {
  const inputs = props.inputs
  const outputs = props.outputs
  const data = props.data
  let timer: number = 0
  let isFirst: boolean = true

  if (inputs) {
    inputs[InputIds.Trigger]?.((val: AnyType) => {
      clearTimeout(timer)
      
      if (data.isleading && isFirst) {
        outputs[OutputIds.Trigger](val)
        isFirst = false
      } else {
        timer = setTimeout(() => {
          outputs[OutputIds.Trigger](val)
          isFirst = true // 重置首次标记
        }, data.delay)
      }
    })
  }
}