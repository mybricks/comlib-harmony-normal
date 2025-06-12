import * as Taro from "@tarojs/taro";

export default function ({ env, data, inputs, outputs }) {
  inputs["call"]((val) => {
    let delta = data.delta;

    if (val?.delta) {
      delta = val.delta;
    }

    delta = isNaN(parseInt(delta)) ? 1 : parseInt(delta);

    // 在引擎内，使用 mock 方法
    if (env.runtime.debug) {
      env.canvas.back(-delta);
      return;
    }

    //runtime
    Taro.navigateBack({
      delta: delta,
    });
  });
}
