import { url } from '@kit.ArkTS';
import { AnyType } from './types'

interface DesignCanvas {
  open: (sceneId: string, params: object, action?: string) => void
}

interface Env {
  runtime?: AnyType
  canvas?: DesignCanvas
  appRouter: AnyType
}

type ActionType = 'back' | 'backToPage'


export interface DataType {
  action?: ActionType
  url?: string,
  delta?: number
  dynamicInput?: boolean
}


interface IOContext {
  env: Env
  data: DataType
  inputs: Inputs
  outputs: Outputs
}

interface Inputs {
  call?: (callback: (val: string) => void) => void
}

type Outputs = AnyType

@ObservedV2
export class Data implements DataType {
  @Trace action?: ActionType
  @Trace url?: string
  @Trace delta?: number = 1
  @Trace dynamicInput?: boolean

  constructor(config?: DataType) {
    this.action = config?.action ?? 'back'
    this.url = config?.url
    this.delta = config?.delta ?? 1
    this.dynamicInput = config?.dynamicInput ?? false
  }
}

export default (context: IOContext) => {
  const env: Env = context.env
  const data: DataType = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs

  inputs?.call?.((val: AnyType) => {
    try {
      const config: AnyType = !!data.dynamicInput ? {
        action: data.action,
        url: val?.url
      } : {
        action: data.action,
        url: data?.url
      }
      const result = getUrlInfo(config.url)
      if (config.action === 'back') {
        env.appRouter?.pop(data.delta)
      } else if (config.action === 'backToPage') {
        env.appRouter?.popToName?.(result.name)
      }
    } catch (e) {
      outputs?.catch?.(e?.message || e)
    }
  })
}

interface UrlInfo {
  params: AnyType,
  name: string
}
/** 获取url参数和地址 */
function getUrlInfo (urlString: string): UrlInfo {
  let urlObject: url.URL
  let params: AnyType = {}
  urlObject = url.URL.parseURL(`https://test.com/${urlString}`)
  const searchParams = urlObject.params.values();
  const values = Array.from(searchParams);
  for (let value of values) {
    params[value[0]] = value[1]
  }
  return {
    params,
    name: urlObject.pathname.replace('/', '')
  }
}