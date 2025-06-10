import * as Taro from "@tarojs/taro";

export default function ({ env, data, inputs, outputs }) {
  if (env.runtime) {
    inputs["vibrate"]((val: string) => {
      Taro.showToast({
        title: "地图相关功能仅支持真机触发",
        icon: "none"
      })

      outputs["onSuccess"]?.(true);
    });
  }
}
