import { AnyType } from './types'

export type DataType = AnyType

interface Connector {
  id: string | number
  title: string
  type: string
  script: AnyType
  inputSchema?: AnyType
  outputSchema?: AnyType,
  timeout?: number
}

@ObservedV2
export class Data implements DataType {
  @Trace immediate: boolean = false
  @Trace timeout?: number
  @Trace connector?: Connector
  @Trace outputSchema?: AnyType
  @Trace dynamicConfig?: Connector

  constructor(config?: DataType) {
    this.immediate = config?.immediate ?? false
    this.connector = config?.connect
    this.outputSchema = config?.outputSchema
    this.dynamicConfig = config?.dynamicConfig
    this.timeout = config?.timeout
  }
}

interface Inputs {
  call?: (fn: (config: AnyType, relOutputs?: AnyType) => void) => void
}

type Outputs = AnyType

interface IOContext {
  data: DataType
  inputs: Inputs
  outputs: Outputs,
  env: AnyType
}

type QueryParams = AnyType

export default (context: IOContext, queryParams: QueryParams) => {
  const data: Data = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs
  const env: AnyType = context.env

  try {
    let connectConfig: Connector = data.connector ?? {} as Connector
    if (data?.outputSchema) {
      connectConfig.outputSchema = data.outputSchema
    }
    if (data?.dynamicConfig) {
      connectConfig = data?.dynamicConfig
    }
    // 设置超时时间
    if (data.timeout) {
      connectConfig.timeout = data.timeout
    }

    // 开始调用接口
    if (data.immediate) { // 立即执行的情况
      env?.callConnector?.(connectConfig, queryParams)
        .then((val: AnyType) => {
          outputs?.[val?.__OUTPUT_ID__ ?? "then"](
            val?.__ORIGIN_RESPONSE__ ?? val
          );
        })
        .catch((err: Error) => {
          outputs?.catch?.(err?.message || err);
        });
    } else { // 被调用的情况
      inputs?.call?.((inputParams: AnyType) => {
        env?.callConnector?.(connectConfig, inputParams)
          .then((val: AnyType) => {
            outputs?.[val?.__OUTPUT_ID__ ?? "then"](
              val?.__ORIGIN_RESPONSE__ ?? val
            );
          })
          .catch((err: Error) => {
            outputs?.catch?.(err?.message || err);
          });
      });
    }
  } catch (e) {
    outputs?.catch?.(`执行错误 ${e?.message || e}`);
  }
}

