import { promptAction } from '@kit.ArkUI';

import { scanCore, scanBarcode } from '@kit.ScanKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';

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
  chooseMedia?: (fn: (val: AnyType, relOutputs?: AnyType) => void) => void
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



  inputs?.chooseMedia?.((val: AnyType) => {

    try {
      let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      PhotoSelectOptions.maxSelectNumber = data.count;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
        //遍历上传的图片本地路径
        console.log("PhotoSelectResult",PhotoSelectResult.photoUris)

        outputs?.onSuccess(PhotoSelectResult.photoUris)

      }).catch((err: BusinessError) => {
        outputs?.onFail(err)
        console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      outputs?.onFail(err)
      console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    }

  })

}