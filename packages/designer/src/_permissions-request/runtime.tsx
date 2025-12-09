import * as Taro from "@tarojs/taro";

export default function ({ env, data, inputs, outputs }) {
  inputs["onPermissionsCheck"](() => {
    Taro.showToast({
      title: "授权应用权限仅支持真机",
      icon: "none",
    });
    outputs["onSuccess"](true);
  });
}
