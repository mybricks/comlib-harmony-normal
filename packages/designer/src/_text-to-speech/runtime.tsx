import * as Taro from "@tarojs/taro";

export default function ({ env, data, inputs, outputs }) {
  if (env.runtime) {
    inputs["text"]((val: string) => {
      Taro.showToast({
        title: "语音播报仅支持真机",
        icon:"none"
      })
      outputs["onComplete"]?.();
    });
  }
}
