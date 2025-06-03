import { promptAction } from '@kit.ArkUI';

import vibrator from '@ohos.vibrator';
import { BusinessError } from '@ohos.base';

import { AnyType } from './types'

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  constructor(config?: DataType) {
  }
}

interface Inputs {
  vibrate?: (fn: (number: DataType, relOutputs?: AnyType) => void) => void
}

interface Outputs {
  onSuccess: (value?: AnyType) => void
  onFail: (value?: AnyType) => void
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

  inputs?.vibrate?.((val: AnyType) => {
    try {
      // 触发马达振动
      vibrator.startVibration({
        type: 'time',
        duration: 1000,
      }, {
        id: 0,
        usage: 'alarm'
      }, (error: BusinessError) => {
        if (error) {
          outputs?.onFail(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`)
          console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
          return;
        }
        outputs?.onSuccess('Succeed in starting vibration')
        console.info('Succeed in starting vibration');
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
      outputs?.onFail(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`)
    }

  })

}