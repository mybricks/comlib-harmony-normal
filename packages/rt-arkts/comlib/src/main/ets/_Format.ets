import { isUndef, isString, isNumber, isDate } from './utils/Helper'
import { AnyType } from './types'
import dayjs from 'dayjs'

enum FormatType {
  NONE = 'NONE',
  KEYMAP = 'KEYMAP',
  TIME_TEMPLATE = 'TIME_TEMPLATE',
  TIME_CUSTOM = 'TIME_CUSTOM'
}

enum InputIds {
  Call = 'call'
}

enum OutputIds {
  Success = 'success'
}

interface FormatData {
  formatterName: string
  values: Record<string, AnyType>
  voidHandle?: boolean
  voidTo?: AnyType
}

export interface DataType {
  formatData?: FormatData
}

@ObservedV2
export class Data implements DataType {
  formatData?: FormatData

  constructor(config?: DataType) {
    if (config) {
      this.formatData = config.formatData
    }
  }
}

interface RuntimeParams {
  env: AnyType
  data: DataType
  outputs: Record<string, Function>
  inputs: Record<string, Function>
}

function transfromData(value: AnyType, formatType: FormatType, config: AnyType): AnyType {
  let result: AnyType = value

  if (formatType === FormatType.NONE) {
    return result
  }

  if (formatType === FormatType.KEYMAP) {
    return config?.[result] ?? result
  }

  if (formatType === FormatType.TIME_TEMPLATE || formatType === FormatType.TIME_CUSTOM) {
    return dayjs(value).format(config)
  }

  return result
}

export default function(props: RuntimeParams) {
  const env:AnyType = props.env;
  const data = props.data
  const inputs = props.inputs;
  const outputs = props.outputs;

  if (!env.runtime) {
    return
  }

  inputs[InputIds.Call]?.((inputValue: AnyType) => {
    if (env.runtime) {
      let resValue: AnyType = inputValue

      if (!data.formatData) {
        outputs[OutputIds.Success](resValue)
        return
      }

      const formatterName = data.formatData?.formatterName;
      const values = data.formatData?.values;

      if (isUndef(inputValue) && data?.formatData?.voidHandle) {
        resValue = data?.formatData?.voidTo
        outputs[OutputIds.Success](resValue)
        return
      }

      if (!isString(inputValue) && !isNumber(inputValue) && !isDate(inputValue)) {
        outputs[OutputIds.Success](resValue)
        return
      }

      resValue = transfromData(inputValue, formatterName as FormatType, values?.[formatterName])
      outputs[OutputIds.Success](resValue)
      return
    }
  })
}