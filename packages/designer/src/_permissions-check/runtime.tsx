import * as Taro from "@tarojs/taro";

export default function ({ env, data, inputs, outputs }) {
  inputs["onPermissionsCheck"](() => {
    Taro.showToast({
      title: "应用权限授权校验仅支持真机",
      icon: "none",
    });
    outputs["onSuccess"]({
      code: 0,
    });
  });
}
