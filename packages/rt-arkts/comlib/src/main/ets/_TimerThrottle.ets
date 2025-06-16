import { AnyType } from './types'

enum InputIds {
  Trigger = 'trigger'
}

enum OutputIds {
  Trigger = 'trigger'
}

export interface DataType {
  delay: number,
  leading?: boolean,
  trailing?: boolean
}

/**
 * 数据源
 * @param delay 延迟时间
 * @param leading 是否立即执行
 * @param trailing 是否延迟执行
 */
@ObservedV2
class Data implements DataType {
  delay: number = 0
  leading?: boolean = true
  trailing?: boolean = true

  constructor(config?: DataType) {
    if (config) {
      this.delay = config.delay
      this.leading = config.leading
      this.trailing = config.trailing
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
  const env: AnyType = props.env
  
  let lastTime: number = 0
  let timer: number = 0

  const throttleOutput = (val: AnyType) => {
    const now = Date.now()
    const remaining = data.delay - (now - lastTime)

    // 清除现有定时器
    if (timer) {
      clearTimeout(timer)
      timer = 0
    }

    // 首次调用或者已经超过节流时间
    if (lastTime === 0 || remaining <= 0) {
      if (data.leading !== false) {
        lastTime = now
        outputs[OutputIds.Trigger](val)
      }
    } 
    // 未超过节流时间且允许结尾调用
    else if (data.trailing !== false) {
      timer = setTimeout(() => {
        lastTime = data.trailing ? Date.now() : 0
        outputs[OutputIds.Trigger](val)
      }, remaining)
    }
  }

  if (env?.runtime && inputs) {
    inputs[InputIds.Trigger]?.((val: AnyType) => {
      throttleOutput(val)
    })
  }
}