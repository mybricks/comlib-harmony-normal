import { window } from '@kit.ArkUI';
import Client, { EObjectAcl, ESignVersion, FilePath, RequestError } from '@aliyun/oss';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { AnyType } from './types'
export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  constructor(config?: DataType) {
  }
}

interface Inputs {
  upload?: (fn: (val: DataType, relOutputs?: AnyType) => void) => void
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

// 实现MediaDataHandler来处理图片数据
class MediaDataHandler implements photoAccessHelper.MediaAssetDataHandler<ArrayBuffer> {
  private client: Client;
  private bucket: string;
  private key: string;
  private outputs: Outputs;

  constructor(client: Client, bucket: string, key: string, outputs: Outputs) {
    this.client = client;
    this.bucket = bucket;
    this.key = key;
    this.outputs = outputs;
  }

  onDataPrepared = async (data: ArrayBuffer) => {
    if (data === undefined) {
      console.error('Error occurred when preparing data');
      this.outputs.onFail('Data preparation failed');
      return;
    }

    try {
      const res = await this.client.putObject({
        bucket: this.bucket,
        key: this.key,
        data: data,
        objectAcl: EObjectAcl.PUBLIC_READ,
      });
      const resUrl:AnyType = res?.origRes?.request?.url
      //输出上传后的图片地址URL
      this.outputs.onSuccess(resUrl.href);
    } catch (err) {
      console.log('oss error: ', err);
      this.outputs.onFail(err);
    }
  }
}

export default (context: IOContext) => {
  const data: Data = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs

  inputs.upload?.((val: AnyType) => {
    window.getLastWindow(getContext()).then(async (windowClass) => {
      const uiContext = windowClass.getUIContext().getHostContext();
      let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(uiContext);

      // 创建OSS客户端实例
      const client = new Client({
        accessKeyId: val.AccessKeyId || "",
        accessKeySecret: val.AccessKeySecret || "",
        securityToken: val.SecurityToken || "",
        region: val?.Region || "oss-cn-hangzhou",
        signVersion: ESignVersion.V4
      });

      const bucket: string = val?.Bucket || "ai-social-img";
      const key:AnyType = val?.objectKey || `upload_${Date.now()}.jpg`;

      try {
        // 设置查询条件
        let predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo(photoAccessHelper.PhotoKeys.URI, val.filePath);

        let fetchOptions: photoAccessHelper.FetchOptions = {
          fetchColumns: [photoAccessHelper.PhotoKeys.TITLE],
          predicates: predicates
        };

        // 获取图片资源
        let fetchResult = await phAccessHelper.getAssets(fetchOptions);
        let photoAsset = await fetchResult.getFirstObject();

        if (!photoAsset) {
          outputs.onFail('Photo asset not found');
          return;
        }
        // 请求图片数据
        let requestOptions: photoAccessHelper.RequestOptions = {
          deliveryMode: photoAccessHelper.DeliveryMode.HIGH_QUALITY_MODE,
        };
        // 创建处理器并请求图片数据
        const handler = new MediaDataHandler(client, bucket, key, outputs);
        await photoAccessHelper.MediaAssetManager.requestImageData(
          uiContext,
          photoAsset,
          requestOptions,
          handler
        );

        fetchResult.close();
      } catch (err) {
        console.error('Process failed with error: ', err);
        outputs.onFail(err);
      }
    }).catch((err:AnyType) => {
      console.error('Failed to get window context: ', err);
      outputs.onFail(err);
    });
  });
}