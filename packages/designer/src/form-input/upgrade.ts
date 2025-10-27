export default function ({ data, input, output }) {
    // 兼容老组件没有onFocus事件的问题
    if (!output.get("onFocus")) {
        output.add({
            id: "onFocus",
            title: "当得到焦点",
            schema: {
                type: "string",
            },
        });
    }

    return true
}
