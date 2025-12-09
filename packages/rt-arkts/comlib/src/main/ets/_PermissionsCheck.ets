import { BusinessError } from '@kit.BasicServicesKit'
import { checkPermissionGrant } from './utils/permission'
import { Permissions } from '@kit.AbilityKit';
import { AnyType } from './types'

export type DataType = AnyType

interface SuccessVal {
  code: number
}

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
  onSuccess: (value: SuccessVal) => void
  onFail: (value: BusinessError) => void
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
      const res = await checkPermissionGrant(data.permissions)
      if (res.success) {
        outputs.onSuccess({
          code: res.result!
        });
      } else {
        outputs.onFail(res.error!);
      }
    }
  })
}
