import { promptAction } from '@kit.ArkUI';
import { call, observer } from '@kit.TelephonyKit'
import { BusinessError } from '@kit.BasicServicesKit';
import Client, { EObjectAcl, ESignVersion, FilePath, RequestError } from '@aliyun/oss';

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

export default (context: IOContext) => {
  const data: Data = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs

  inputs.upload?.((val: AnyType) => {
    // // 创建OSS客户端实例
    const client = new Client({
      accessKeyId: val.AccessKeyId || "",
      accessKeySecret: val.AccessKeySecret || "",
      securityToken: val.SecurityToken || "",
      region: val?.Region || "oss-cn-hangzhou",
      signVersion:ESignVersion.V4
    });
    //
    // // 指定要上传的对象（文件）名称，请替换为您实际要上传的对象名称
    const key = 'yourObjectName';
    const bucket:AnyType = val?.Bucket || "ai-social-img"
    //
    //
    const putObjectWithObjectAcl = async () => {
      try {
        //调用putObject方法上传数据，并设置对象的访问权限为PRIVATE
        const res = await client.putObject({
          bucket, // Bucket名称
          key,    // 对象（文件）名称
          data: new FilePath(val?.filePath), // 要上传的数据，这里是一个简单的字符串
          objectAcl: EObjectAcl.PUBLIC_READ, // 设置对象的访问权限为PRIVATE
        });

        // 打印上传结果
        console.log(JSON.stringify(res));
        outputs?.onSuccess(res)
      } catch (err) {
        //捕获请求过程中的异常信息
        if (err instanceof RequestError) {
          // 如果是已知类型的错误，则打印错误代码、错误消息、请求ID、状态码、EC码等信息
          console.log('code: ', err.code); // 错误代码
          console.log('message: ', err.message); // 错误消息
          console.log('requestId: ', err.requestId); // 请求ID
          console.log('status: ', err.status); // HTTP状态码
          console.log('ec: ', err.ec); // 错误码
        } else {
          // 打印其他未知类型的错误
          console.log('unknown error: ', err);
        }

        outputs?.onFail(err)
      }
    };

    putObjectWithObjectAcl();



  })

}