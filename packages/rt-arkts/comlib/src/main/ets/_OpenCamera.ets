import { promptAction } from '@kit.ArkUI';

import { scanCore, scanBarcode } from '@kit.ScanKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';

import { UIAbility } from '@kit.AbilityKit';
import common from '@ohos.app.ability.common';
import { window, UIContext } from '@kit.ArkUI';

import { camera } from '@kit.CameraKit';

import { AnyType } from './types'

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  @Trace count?: number

  constructor(config?: DataType) {
    this.count = config.count

  }
}

interface Inputs {
  open?: (fn: (val: AnyType, relOutputs?: AnyType) => void) => void
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

const ui_context = getContext(this) as common.UIAbilityContext;


export default (context: IOContext) => {
  const data: Data = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs

  // let windowStage: window.WindowStage | null = null; // 需在生命周期回调中赋值



  // let windowClass: window.Window | undefined = undefined;
  // let uiContext: UIContext | null = null;
  // uiContext = windowClass?.getUIContext();


  inputs?.open?.((val: AnyType) => {
 //   camera.getCameraManager(ui_context)

  })

}