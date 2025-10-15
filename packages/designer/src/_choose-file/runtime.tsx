import * as Taro from "@tarojs/taro";

export default function ({ env, data, inputs, outputs }) {
  inputs["chooseFile"](() => {
    let params = {
      count: data.count,
    };

    Taro.chooseMedia({
      ...params,
      success(res) {
        outputs["onSuccess"](res);
      },
      fail(err) {
        outputs["onFail"](err);
      },
    });
  });
}
