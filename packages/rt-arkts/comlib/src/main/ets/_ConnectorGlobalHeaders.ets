import { AnyType } from './types';

interface Env {
  runtime?: AnyType
  appContext?: AnyType
}

export interface DataType {
  dynamic?: boolean
  header?: AnyType,
}

interface IOContext {
  env: Env
  data: DataType
  inputs: Inputs
  outputs: Outputs
}

interface Inputs {
  call?: (callback: (val: AnyType, relOutputs?: AnyType) => void) => void
}

type Outputs = AnyType


@ObservedV2
export class Data implements DataType {
  @Trace dynamic?: boolean = true
  @Trace header?: AnyType = {}

  constructor(config?: DataType) {
    this.dynamic = config?.dynamic ?? this.dynamic
    this.header = config?.header ?? this.header ?? {}
  }
}

export default (context: IOContext) => {
  const data: DataType = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs
  const env: Env = context.env

  inputs?.call?.((val: AnyType, outputRels: AnyType) => {
    try {
      if (!env.appContext) {
        // 环境变量不存在
        return
      }

      if (data.dynamic !== false) { // 如果不走动态输入，则写入配置
        if (typeof val === "object" && val !== null && !Array.isArray(val)) {
          env.appContext['_MYBRICKS_GLOBAL_HEADERS_'] = val
          outputRels?.then?.(val);
        }
      } else { // 动态配置，将输入的配置写入
        if (typeof val === "object" && val !== null && !Array.isArray(val)) {
          env.appContext['_MYBRICKS_GLOBAL_HEADERS_'] = data.header
          outputRels?.then?.(data.header);
        }
      }
    } catch (e) {
    }
  })
}

