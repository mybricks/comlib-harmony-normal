

export default {
  "@init": ({ data, setDesc, output, outputs, setAutoRun, isAutoRun }) => {
    const autoRun = isAutoRun ? isAutoRun() : false;
    if (autoRun || data.immediate) {
      setAutoRun(true);
      data.immediate = true;
      data.type = 'onPlay'
      setDesc(`音频播放-当播放时`);
    } else {
      data.immediate = false;
      data.type = 'play'
      setDesc(`音频播放-播放`);
    }
  },
  ":root": [
    {
      title: "类型",
      type: "select",
      options: [
        { label: "播放", value: "play" },
        { label: "暂停", value: "pause" },
        { label: "跳转", value: "seek"},
        // { label: "播放指定音频", value: "playAudio" },
        { label: "销毁", value: "destroy" }
      ],
      ifVisible({ data }: EditorResult<Data>) {
        return !data.immediate;
      },
      value: {
        get({ data }) {
          return data.type;
        },
        set({ data }, value) {
          data.type = value;
        },
      }
    },
    {
      title: "类型",
      type: "select",
      options: [
        { label: "当播放时", value: "onPlay" },
        { label: "当暂停时", value: "onPause" },
        { label: "当播放进度变化时", value: "onPlayPosition" },
      ],
      ifVisible({ data }: EditorResult<Data>) {
        return data.immediate;
      },
      value: {
        get({ data }) {
          return data.type;
        },
        set({ data }, value) {
          data.type = value;
        },
      }
    },
    {},
    // {
    //   title: "超时时间",
    //   description: "单位：毫秒, 默认值：60,000",
    //   type: "text",
    //   options: {
    //     type: "number",
    //   },
    //   value: {
    //     get({ data }) {
    //       return data.timeout;
    //     },
    //     set({ data }, timeout) {
    //       data.timeout = timeout;
    //     },
    //   },
    // },
  ],
};
