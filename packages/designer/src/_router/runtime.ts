export default function ({ env, data, inputs, outputs, _inputsCallable }) {
  if (!env.runtime) {
    return;
  }

  inputs["goto"]((val) => {

    const config = {
      action: data.action,
      url: data?.url,
      ...(data.dynamicInput ? (val ?? {}) : {}),
    }

    const sceneId = config?.url?.split?.('?')?.[0];
    // 解析出参数
    const params = getParamsFromPath(config.url);

    if (env.runtime.debug) {
      env.canvas.open(sceneId, params, data.action);
    } else {
      // TODO，运行时暂时不需要
    }
  });

  function getParamsFromPath(path) {
    let parts = path.split("?");
    if (parts.length < 2) {
      return {};
    }

    let paramsStr = parts[1] || "";
    let params = {};
    paramsStr.split("&").forEach((item) => {
      let [key, value] = item.split("=");

      // value 可能经过 encodeURIComponent 编码，需要解码
      try {
        value = decodeURIComponent(value);
      } catch (e) { }

      try {
        value = JSON.parse(value);
      } catch (e) { }

      params[key] = value;
    });

    return params;
  }
}
