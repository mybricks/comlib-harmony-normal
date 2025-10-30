export default function ({ data, input, output }) {
    if (!input.get("setTimerStartTimeStamp")) {
        input.add({
            id: "setTimerStartTimeStamp",
            title: "设置计时器开始时间",
            schema: {
                type: "string"
            },
            rels: [
                "setTimerStartTimeStampComplete"
            ]
        });
    }

    if (!output.get("setTimerStartTimeStampComplete")) {
        output.add({
            id: "setTimerStartTimeStampComplete",
            title: "设置计时器开始时间完成",
            schema: {
                type: "string"
            }
        });
    }

    return true
}
