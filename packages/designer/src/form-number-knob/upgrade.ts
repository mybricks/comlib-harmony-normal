export default function ({ data, input, output }) {
  // onPress 事件兼容老组件的问题
  if (!output.get("onPress")) {
    output.add({
      id: "onPress",
      title: "当按钮按下",
      schema: {
        type: "boolean",
      },
    });
  }

  return true;
}
