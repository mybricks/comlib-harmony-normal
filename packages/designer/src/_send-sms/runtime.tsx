import * as Taro from "@tarojs/taro";

export default function ({ env, data, inputs, outputs }) {
  if (env.runtime) {
    inputs["send"]((val: string) => {
      Taro.showToast({
        title: "发送短信仅支持真机",
        icon: "none"
      });

      outputs["onSuccess"]?.();
    });
  }
}
