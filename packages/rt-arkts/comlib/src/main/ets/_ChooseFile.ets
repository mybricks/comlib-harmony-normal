import { promptAction } from '@kit.ArkUI';

import { scanCore, scanBarcode } from '@kit.ScanKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import picker from '@ohos.file.picker';

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
      const documentPicker = new picker.DocumentViewPicker();
      const options: picker.DocumentSelectOptions = {
        maxSelectNumber: data.count,
        fileSuffixFilters: ['.doc', '.docx', '.pdf', '.txt'], // 限制文件类型
      };

      documentPicker.select(options).then((FileSelectResult) => {
        outputs?.onSuccess(FileSelectResult)
      })

    } catch (err) {
      outputs?.onFail(err)
      console.error('Document picker error:', err);
    }

  })

}