

export default {
  "@init": ({ data, setDesc, output, outputs, setAutoRun, isAutoRun }) => {
    const autoRun = isAutoRun ? isAutoRun() : false;
    if (autoRun || data.immediate) {
      setAutoRun(true);
      data.immediate = true;
      data.type = 'onChange'
      setDesc(`音乐播放器-当变化时`);
    } else {
      data.immediate = false;
      data.type = 'play'
      setDesc(`音乐播放器-播放`);
    }
  },
  ":root": [
    {
      title: "类型",
      type: "select",
      options: [
        { label: "播放", value: "play" },
        { label: "暂停", value: "pause" },
        { label: "播放指定歌曲", value: "playSong" },
        { label: "设置播放列表", value: "setPlayList" },
        { label: "修改歌曲信息", value: "editSong" }
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
        { label: "当歌曲切换时", value: "onChange" },
        { label: "当播放时", value: "onPlay" },
        { label: "当暂停时", value: "onPause" }
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
