export default {
   "@init": ({ data, setDesc, output, setAutoRun, isAutoRun }) => {
    const autoRun = isAutoRun ? isAutoRun() : false;
    if (autoRun) {
      setAutoRun(true);
      data.immediate = true;
      setDesc("输出音频「PCM流/振幅」");

      output.get("then").setTitle("PCM流");
      output.add("amplitude", "振幅", {
        type: "number"
      });
    }
  },
  ":root": [
    {
      title: "调用类型",
      type: "select",
      options: [
        { label: "开始", value: "start" },
        { label: "暂停", value: "pause" },
        { label: "结束", value: "stop" },
      ],
      ifVisible({ data }: EditorResult<Data>) {
        return !data.immediate;
      },
      value: {
        get({ data }) {
          return data.callType;
        },
        set({ data }, value) {
          data.callType = value;
        },
      }
    },
  ],
};
