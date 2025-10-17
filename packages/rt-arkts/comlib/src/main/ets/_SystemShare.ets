import { fileIo as fs } from '@kit.CoreFileKit';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit'
import { image } from '@kit.ImageKit'
import { AnyType } from './types'
import { fileUri } from '@kit.CoreFileKit';

export type DataType = AnyType

interface ShareData {
  title: string,
  content: string,
  description: string,
  thumbnail: string,
}

@ObservedV2
export class Data implements DataType {
  @Trace type: string

  constructor(config?: DataType) {
    this.type = config.string || 'OTHER'
  }
}

interface Inputs {
  share?: (fn: (val: ShareData, relOutputs?: AnyType) => void) => void
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

  inputs?.share?.(async (val: AnyType) => {
    try {
      const windowClass = await window.getLastWindow(getContext());
      const uiContext = windowClass.getUIContext().getHostContext() as common.UIAbilityContext;
      const shareData = await getShareData(data.type, val)
      if (shareData) {
        let controller: systemShare.ShareController = new systemShare.ShareController(shareData);
        controller.show(uiContext, {
          selectionMode: systemShare.SelectionMode.SINGLE,
          previewMode: systemShare.SharePreviewMode.DETAIL,
        }).then(() => {
          outputs?.onSuccess(true)
        }).catch((error: BusinessError) => {
          console.error(`分享错误. code: ${error.code}, message: ${error.message}`);
          outputs?.onFail(error)
        })
      } else {
        outputs?.onFail('数据类型/数据错误')
      }
    } catch (err) {
      outputs?.onFail(err)
    }
  })
}

/**
 * 获取精准的utd类型
 */
function getUtdByExt(ext?: string, type?: string) {
  if (!ext) return undefined
  const res = type ? utd.getUniformDataTypeByFilenameExtension(ext, type) : utd.getUniformDataTypeByFilenameExtension(ext)
  return res
}

/**
 * 缩略图
 */
async function getThumbnail(src: string) {
  if (!src) return undefined
  try {
    const response = await http.createHttp().request(src, {
      method: http.RequestMethod.GET,
      expectDataType: http.HttpDataType.ARRAY_BUFFER
    })
    if (response.responseCode === 200 && response.result) {
      const originBytes = new Uint8Array(response.result as ArrayBuffer)
      const source = image.createImageSource(originBytes.buffer)
      const packer = image.createImagePacker()
      const compressedBuffer = await packer.packToData(source, {
        format: "image/jpeg",
        quality: 40, // 0-100 越低压缩越大
      })
      const compressedBytes = new Uint8Array(compressedBuffer)
      return compressedBytes
    } else {
      console.error('图片下载失败:', response.responseCode)
      return
    }
  } catch (err) {
    console.error('图片加载失败:', err)
    return
  }
}

/**
 * 构造分享数据
 */
async function getShareData(type: string, val: ShareData) {
  try {
    let utdTypeId:string | undefined
    const extIndex = val.content ? val.content.lastIndexOf('.') : -1
    const ext =  extIndex !== -1 ? val.content.slice(extIndex) : undefined
    switch (type) {
      case 'TEXT':
        utdTypeId = utd.UniformDataType.TEXT
        break;
      case 'IMAGE':
        utdTypeId = getUtdByExt(ext, utd.UniformDataType.IMAGE)
        break;
      case 'VIDEO':
        utdTypeId = getUtdByExt(ext, utd.UniformDataType.VIDEO)
        break;
      case 'HYPERLINK':
        utdTypeId = utd.UniformDataType.HYPERLINK
        break;
      default :
        utdTypeId = getUtdByExt(ext)
    }
    if (!utdTypeId) return undefined

    let uri = ''
    if (!['TEXT', 'HYPERLINK'].includes(type)) {
      const windowClass = await window.getLastWindow(getContext());
      const uiContext = windowClass.getUIContext().getHostContext() as common.UIAbilityContext;
      const sandboxPath = uiContext.filesDir + '/' + decodeURIComponent(val.content.split('/').pop() || `${Date.now()}${ext}`)
      const copyRes = await copyToSandbox(val.content, sandboxPath)
      if (!copyRes) return undefined
      uri = fileUri.getUriFromPath(sandboxPath)
    }
    let shareData: systemShare.SharedData = new systemShare.SharedData({
      utd: utdTypeId,
      content: !uri ? val.content : undefined, // 链接/文本类型的内容通过content字段传递
      uri: uri,
      title: val.title,
      description: val.description,
      thumbnail: await getThumbnail(val.thumbnail)
    });
    return shareData
  } catch (err) {
    console.error(err)
    return undefined
  }
}

async function copyToSandbox(srcUri: string, sandboxPath: string) {
  try {
    let res = fs.accessSync(sandboxPath, fs.AccessModeType.EXIST, fs.AccessFlagType.LOCAL)
    if (res) {
      return true
    }
  } catch {}
  try {
    // 打开用户文件
    const srcFile = fs.openSync(srcUri, fs.OpenMode.READ_ONLY);

    // 创建沙箱目标文件
    const destFile = fs.openSync(sandboxPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

    // 执行复制操作
    await fs.copyFile(srcFile.fd, destFile.fd);

    // 关闭文件描述符
    fs.closeSync(srcFile);
    fs.closeSync(destFile);
    return true
  } catch (err) {
    console.error(`复制失败: ${err.code}, ${err.message}`);
    return false
  }
}