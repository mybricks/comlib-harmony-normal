export default function ({ data, input, output }) {
    // onScroll 事件兼容老组件的问题
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
