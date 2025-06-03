import { promptAction } from '@kit.ArkUI';
import { call, observer } from '@kit.TelephonyKit'
import { BusinessError } from '@kit.BasicServicesKit';

import { AnyType } from './types'

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  constructor(config?: DataType) {
  }
}

interface Inputs {
  call?: (fn: (number: DataType, relOutputs?: AnyType) => void) => void
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

  inputs.call?.((val: AnyType) => {
    // 调用查询能力接口
    let isSupport = call.hasVoiceCapability();
    if (isSupport) {
      // 如果设备支持呼叫能力，则继续跳转到拨号界面，并显示拨号的号码
      // 从API15开始支持tel格式电话号码，如："tel:13xxxx"
      call.makeCall(val, (err: BusinessError) => {
        if (!err) {
          console.log("make call success.");
          outputs?.onSuccess(val)
        } else {
          console.log("make call fail, err is:" + JSON.stringify(err));
          outputs?.onFail("make call fail, err is:" + JSON.stringify(err))
        }
      });
      // 订阅通话业务状态变化（可选）
      class SlotId {slotId: number = 0}
      class CallStateCallback {
        state: call.CallState = call.CallState.CALL_STATE_UNKNOWN;
        number: string = "";
      }
      let slotId: SlotId = {slotId: 0}
      observer.on("callStateChange", slotId, (data: CallStateCallback) => {
        console.log("call state change, data is:" + JSON.stringify(data));
      });
    }

  })

}