import { BusinessError } from '@kit.BasicServicesKit'
import { reqPermissionsFromUser, RequestResResult } from './utils/permission'
import { Permissions, common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { AnyType } from './types'

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  @Trace permissions?: Permissions

  constructor(config?: DataType) {
    this.permissions = config.permissions
  }
}

interface Inputs {
  onPermissionsCheck?: (fn: (val: AnyType, relOutputs?: AnyType) => void) => void
}

interface Outputs {
  onSuccess: (value: AnyType) => void
  onFail: (value?: RequestResResult) => void
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

  inputs?.onPermissionsCheck?.(async () => {
    if (data.permissions) {
      const windowClass = await window.getLastWindow(getContext());
      const uiContext = windowClass.getUIContext().getHostContext() as common.UIAbilityContext;

      const res = await reqPermissionsFromUser(data.permissions, uiContext)
      if (res.success) {
        outputs.onSuccess(true);
      } else {
        outputs.onFail(res.result);
      }
    }
  })
}
