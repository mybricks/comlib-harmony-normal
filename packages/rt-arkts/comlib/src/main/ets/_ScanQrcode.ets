import { promptAction } from '@kit.ArkUI';

import { scanCore, scanBarcode } from '@kit.ScanKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

import { AnyType } from './types'

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  constructor(config?: DataType) {
  }
}

interface Inputs {
  scan?: (fn: (number: DataType, relOutputs?: AnyType) => void) => void
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

  inputs?.scan?.((val: AnyType) => {
    // 定义扫码参数options
    let options: scanBarcode.ScanOptions = { scanTypes: [scanCore.ScanType.ALL], enableMultiMode: true, enableAlbum: true };
    try {
      scanBarcode.startScanForResult(getContext(context), options).then((result: scanBarcode.ScanResult) => {
        hilog.info(0x0001, '[Scan Sample]',
          `Succeeded in getting ScanResult by promise with options, result is ${JSON.stringify(result)}`);
        outputs?.onSuccess(`${result}`)
      }).catch((error: BusinessError) => {
        hilog.error(0x0001, '[Scan Sample]',
          `Failed to get ScanResult by promise with options. Code: ${error.code}, message: ${error.message}`);
        outputs?.onFail(`Code: ${error.code}, message: ${error.message}`)
      });
    } catch (error) {
      hilog.error(0x0001, '[Scan Sample]', `Failed to startScanForResult. Code: ${error.code}, message: ${error.message}`);
    }

  })

}