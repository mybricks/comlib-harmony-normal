import { promptAction } from '@kit.ArkUI';
import { call, observer } from '@kit.TelephonyKit'
import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { abilityAccessCtrl } from '@kit.AbilityKit';


import { AnyType } from './types'

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  constructor(config?: DataType) {
  }
}

interface Inputs {
  get?: (fn: (number: DataType, relOutputs?: AnyType) => void) => void
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

  inputs.get?.((val: AnyType) => {

    abilityAccessCtrl.createAtManager().requestPermissionsFromUser(getContext(), [
      'ohos.permission.LOCATION', 'ohos.permission.APPROXIMATELY_LOCATION']).then(() => {
      // 权限申请通过后， 获取当前位置
      try {
        geoLocationManager.getCurrentLocation((err: BusinessError, location: geoLocationManager.Location) => {
          if (err) {
            console.error(`定位失败: 错误码 ${err.code}, 信息: ${err.message}`);
            outputs?.onFail(err)
            return;
          }
          console.info(`当前位置: ${location}`);
          outputs?.onSuccess(location)

        });
      } catch (error) {
        outputs?.onFail(error)
        console.error(`调用异常: ${error.code}, ${error.message}`);
      }
    })
      .catch((err:AnyType)=>{
        console.log("err",err)
      });
  })

}