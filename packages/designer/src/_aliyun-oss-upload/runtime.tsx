//OSS文件上传H5暂未实现，暂只实现了鸿蒙端
export default function ({ env, data, inputs, outputs }) {
  inputs["upload"]((val) => {
    outputs["onSuccess"]?.(val?.filePath);
  });
}
