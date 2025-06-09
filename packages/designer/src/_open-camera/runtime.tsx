import * as Taro from "@tarojs/taro";

export default function ({ env, data, inputs, outputs }) {
  if (env.runtime) {
    inputs["open"]((val: string) => {

      Taro.showToast({
        title: "打开相机仅支持真机",
        icon: "none"
      });

      outputs?.["onSuccess"]()

    });
  }
}
