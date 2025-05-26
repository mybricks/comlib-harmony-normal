import { cryptoFramework } from "@kit.CryptoArchitectureKit";
import { util } from "@kit.ArkTS";
import { AnyType } from './types';

class AESEntryUtil {
  static encryptMessage(plainText: string, screctKey: string): string {
    const aesGenerator = cryptoFramework.createSymKeyGenerator('AES128');
    const secret = AESEntryUtil.stringToUnit8Array(screctKey);
    let symKey = aesGenerator.convertKeySync({
      data: secret
    });

    let ivParamsSpec: cryptoFramework.IvParamsSpec = {
      algName: "IvParamsSpec",
      iv: {
        data: secret
      }
    };
    let cipher = cryptoFramework.createCipher('AES128|CFB|NoPadding');
    cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, ivParamsSpec);
    let cipherData = cipher.doFinalSync({
      data: AESEntryUtil.stringToUnit8Array(plainText)
    });

    let base64Helper = new util.Base64Helper();
    return base64Helper.encodeToStringSync(cipherData.data);
  }

  static stringToUnit8Array(msg: string): Uint8Array {
    const encoder = new util.TextEncoder();
    return encoder.encodeInto(msg);
  }
}

interface Env {
  runtime?: AnyType
}

export interface DataType {
  key?: string
  iv?: string,
}


interface IOContext {
  env: Env
  data: DataType
  inputs: Inputs
  outputs: Outputs
}

interface Inputs {
  call?: (callback: (val: string) => void) => void
}

type Outputs = AnyType

@ObservedV2
export class Data implements DataType {
  @Trace key?: string
  @Trace iv?: string

  constructor(config?: DataType) {
    this.key = config?.key
    this.iv = config?.iv
  }
}

export default (context: IOContext) => {
  const data: DataType = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs

  inputs?.call?.((val: AnyType) => {
    try {
      if (!val || !data.key || !data.iv) {
        outputs["result"]?.("");
        return;
      }
      outputs["result"]?.(AESEntryUtil.encryptMessage(val, data.key));
    } catch (e) {
      outputs?.catch?.(e?.message || e)
    }
  })
}

