import picker from '@ohos.file.picker';
import { fileIo as fs } from '@kit.CoreFileKit';
import { fileShare } from '@kit.CoreFileKit';

import { AnyType } from './types'
import { JSON } from '@kit.ArkTS';

export type DataType = AnyType
interface TempFile {
  tempFilePath: string,
  filename: string,
  size: number,
  fileType?: string,
  atime: number,
  mtime: number,
  ctime: number,
}
interface UploadResult {
  failedCount: number,
  tempFiles: TempFile[]
}

@ObservedV2
export class Data implements DataType {
  @Trace count?: number
  @Trace fileType?: string[]
  @Trace persist?: boolean

  constructor(config?: DataType) {
    this.count = config.count ?? 1
    this.fileType = formatFileType(config.fileType)
    this.persist = config.persist ?? false
  }
}

interface Inputs {
  chooseMedia?: (fn: (val: AnyType, relOutputs?: AnyType) => void) => void
}

interface Outputs {
  onSuccess: (value?: AnyType) => void
  onFail: (value?: AnyType) => void
  onCancel: () => void
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

  inputs?.chooseMedia?.(() => {

    try {
      const documentPicker = new picker.DocumentViewPicker();
      const options: picker.DocumentSelectOptions = {
        maxSelectNumber: data.count,
        fileSuffixFilters: data.fileType,
      };

      documentPicker.select(options).then(async (FileSelectResult) => {
        if (FileSelectResult) {
          // 获取文件信息
          const res = getFilesInfo(FileSelectResult)
          if (data.persist) {
            // 授权持久化
            try {
              await persistPermission(FileSelectResult)
              outputs?.onSuccess(res)
            } catch (err) {
              outputs?.onFail(err)
            }
          } else {
            // console.log('>>>>文件选择 res', JSON.stringify(res, null, 2))
            outputs?.onSuccess(res)
          }
        } else {
          outputs?.onCancel()
        }
      })

    } catch (err) {
      outputs?.onFail(err)
      console.error('Document picker error:', err);
    }

  })

}


/**
 * 格式化后缀
 */
function formatFileType(arr: string[]): string[] {
  if (arr) {
    return arr.join(',').split(',')
  }
  return []
}

/**
 * 获取文件信息
 */
function getFilesInfo(uris: string[]): UploadResult {
  const tempFiles:TempFile[] = []
  let failedCount = 0
  uris.forEach(uri => {
    const filename = uri.split('/').pop() || ''
    try {
      let file = fs.openSync(uri, fs.OpenMode.READ_ONLY)
      let stat = fs.statSync(file.fd);
      tempFiles.push({
        tempFilePath: uri,
        size: stat.size,
        filename: decodeURIComponent(filename),
        fileType: filename.split('.').pop()?.toLowerCase(),
        atime: stat.atime,
        mtime: stat.mtime,
        ctime: stat.ctime,
      })
    } catch (e) {
      ++failedCount
    }
  })
  return {
    tempFiles,
    failedCount
  }
}

/**
 * 授权持久化
 */
function persistPermission(uris: string[]): Promise<boolean> {
  return new Promise((resolve: Function, reject: Function) => {
    if (canIUse('SystemCapability.FileManagement.AppFileService.FolderAuthorization')) {
      const policies: fileShare.PolicyInfo[] = uris.map(uri => ({
        uri,
        operationMode: fileShare.OperationMode.READ_MODE
      } as fileShare.PolicyInfo))
      fileShare.checkPersistentPermission(policies).then((data: boolean[]) => {
        // console.log('>>>>文件选择 data', JSON.stringify(data, null, 2))
        const policy:Array<fileShare.PolicyInfo> = []
        data.forEach((i, index) => {
          if (!i) {
            policy.push({
              uri: policies[index].uri,
              operationMode: policies[index].operationMode,
            })
          }
        })
        // console.log('>>>>文件选择 policy', JSON.stringify(policy, null, 2))
        fileShare.persistPermission(policy).then(() => {
          // console.log('>>>>文件选择 policy成功')
          resolve(true)
        }).catch((err: BusinessError<Array<fileShare.PolicyErrorResult>>) => {
          reject("文件持久化授权失败: " + err.message + ", error code: " + err.code);
        })
      }).catch((err: BusinessError<Array<fileShare.PolicyErrorResult>>) => {
        reject("校验文件持久化授权失败: " + err.message + ", error code: " + err.code);
      })
    } else {
      reject('无持久化访问文件权限')
    }
  })
}