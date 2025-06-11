import { petalMaps } from '@kit.MapKit'
import { AnyType } from './types'

export type DataType = AnyType

type ActionType = 'openMapPoiDetail' | 'openMapRoutePlan' | 'openMapNavi'

@ObservedV2
export class Data implements DataType {
  @Trace type: ActionType = 'openMapPoiDetail'

  constructor(config?: DataType) {
    this.type = config?.type ?? 'openMapPoiDetail'
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

export default (context: IOContext) => {
  const data: Data = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs

  try {
    inputs?.call?.((inputParams: AnyType) => {
      switch (data.type) {
        case 'openMapPoiDetail': {
          if (!inputParams?.latitude || !inputParams?.longitude) {
            return
          }
          petalMaps.openMapPoiDetail(getContext(), {
            destinationPosition: {
              longitude: inputParams.longitude,
              latitude: inputParams.latitude,
            },
            destinationName: inputParams.name
          }).then((res) => {
            outputs?.onSuccess?.();
          }).catch((reason: AnyType) => {
            outputs?.onFail?.(reason?.message || reason);
          })
          return
        }

        case 'openMapRoutePlan': {
          if (!inputParams?.destination || !inputParams.latitude || !inputParams.longitude) {
            return
          }
          petalMaps.openMapRoutePlan(getContext(), {
            originPosition: {
              longitude: inputParams?.origin?.longitude,
              latitude: inputParams?.origin?.latitude,
            },
            originName: inputParams?.origin?.name,
            destinationPosition: {
              longitude: inputParams?.destination?.longitude,
              latitude: inputParams?.destination?.latitude,
            },
            destinationName: inputParams?.destination?.name,
          }).then((res) => {
            outputs?.onSuccess?.();
          }).catch((reason: AnyType) => {
            outputs?.onFail?.(reason?.message || reason);
          })
          return
        }

        case 'openMapNavi': {
          if (!inputParams?.latitude || !inputParams?.longitude) {
            return
          }
          petalMaps.openMapNavi(getContext(), {
            destinationPosition: {
              longitude: inputParams.longitude,
              latitude: inputParams.latitude,
            },
            destinationName: inputParams.name
          }).then((res) => {
            outputs?.onSuccess?.();
          }).catch((reason: AnyType) => {
            outputs?.onFail?.(reason?.message || reason);
          })
          return
        }
      }
    });
  } catch (e) {
    outputs?.onFail?.(`执行错误 ${e?.message || e}`);
  }
}

