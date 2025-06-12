import * as Taro from "@tarojs/taro";

export default function ({ env, data, inputs, outputs }) {
  inputs["call"]((val: string) => {
    Taro.makePhoneCall({
      phoneNumber: String(val),
      success: ({ errMsg }) => {
        outputs["onSuccess"]?.(true);
      },
      fail: ({ errMsg }) => {
        outputs["onFail"]?.({ errMsg });
      },
    });
  });
}
