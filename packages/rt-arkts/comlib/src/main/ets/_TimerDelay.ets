import { AnyType } from './types'

enum InputIds {
  Trigger = 'trigger',
  Cancel = 'cancel'
}

enum OutputIds {
  Trigger = 'trigger'
}

export interface DataType {
  id: string,
  delay: number,
  useCancel?: boolean
}

/**
 * 数据源
 * @param id 定时器ID
 * @param delay 延迟时间
 * @param useCancel 开启取消
 */
@ObservedV2
export class Data implements DataType {
  id: string = ''
  delay: number = 0
  useCancel?: boolean = false

  constructor(config?: DataType) {
    if (config) {
      this.id = config.id
      this.delay = config.delay
      this.useCancel = config.useCancel
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

  if (inputs) {
    // 处理触发事件
    inputs[InputIds.Trigger]?.((val: AnyType) => {
      clearTimeout(timer)
      timer = setTimeout(() => {
        outputs[OutputIds.Trigger](val)
      }, data.delay)
    })

    // 处理取消事件
    inputs[InputIds.Cancel]?.(() => {
      clearTimeout(timer)
    })
  }
}