export default function ({ data, input, output }) {
    // 兼容老组件没有onFocus事件的问题
    if (!output.get("onScroll")) {
        output.add({
            id: "onScroll",
            title: "当容器滚动时",
            schema: {
                type: "object",
                properties: {
                    xOffset: {
                        type: "number"
                    },
                    yOffset: {
                        type: "number"
                    },
                    scrollTop: {
                        type: "number"
                    },
                    scrollLeft: {
                        type: "number"
                    }
                }
            }
        });
    }

    return true
}
