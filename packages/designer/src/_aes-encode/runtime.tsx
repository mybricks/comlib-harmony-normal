import * as Taro from "@tarojs/taro";
import CryptoJS from "crypto-js";

export default function ({ env, data, inputs, outputs }) {
  inputs["call"]((val: string) => {
    //
    if (!val || !data.key || !data.iv) {
      outputs["result"]("");
      return;
    }

    // 将密钥转换为WordArray
    const key = CryptoJS.enc.Utf8.parse(data.key);
    // 使用相同的密钥作为IV（
    const iv = CryptoJS.enc.Utf8.parse(data.iv);

    // 使用AES-128-CFB模式加密
    const encrypted = CryptoJS.AES.encrypt(val, key, {
      iv: iv,
      mode: CryptoJS.mode.CFB,
      padding: CryptoJS.pad.NoPadding,
      keySize: 128 / 32
    });

    // 返回 Base64 编码的密文
    const encryptedBase64 = encrypted.toString();

    // 输出加密结果
    outputs["result"](encryptedBase64);
  });
}
