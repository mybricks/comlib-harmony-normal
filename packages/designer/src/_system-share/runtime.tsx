import * as Taro from "@tarojs/taro";

export default function ({ env, data, inputs, outputs }) {
  inputs["share"](() => {
    Taro.showToast({
      title: "系统分享仅支持真机触发",
      icon: "none",
    });

    outputs["onSuccess"]?.(true);
  });
}
