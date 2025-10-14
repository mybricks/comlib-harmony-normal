export default {
  "@init"({ style }) {
    style.width = "100%";
    style.height = "auto";
  },
  ":root": {
    style: [
      {
        title: "进度文本",
        options: ["font", "margin"],
        target: ".mybricks-play-progress-text",
      },
    ],
    items: ({ data, inputs, output, style }, cate0, cate1) => {
      cate0.title = "常规";
      cate0.items = [
        {
          title: "总时长(秒)",
          type: "inputnumber",
          options: [{ min: 1, step: 1 }],
          value: {
            get({ data }) {
              return [data.total];
            },
            set({ data }, value: number) {
              data.total = value;
            },
          },
        },
        {
          title: "滑块",
          items: [
            {
              title: "颜色",
              type: "colorpicker",
              value: {
                get({ data }) {
                  return data.blockColor;
                },
                set({ data }, value: string) {
                  data.blockColor = value;
                },
              },
            },
            {
              title: "大小",
              type: "inputnumber",
              options: [{ title: "", width: "100%", min: 12, max: 28 }],
              value: {
                get({ data }: any) {
                  return [data.blockSize];
                },
                set({ data }: any, value: [number, number]) {
                  [data.blockSize] = value;
                },
              },
            },
          ],
        },
        {
          title: "滑轨",
          items: [
            {
              title: "背景颜色",
              type: "colorpicker",
              value: {
                get({ data }) {
                  return data.trackColor;
                },
                set({ data }, value: string) {
                  data.trackColor = value;
                },
              },
            },
            {
              title: "已滑动部分颜色",
              type: "colorpicker",
              value: {
                get({ data }) {
                  return data.selectedColor;
                },
                set({ data }, value: string) {
                  data.selectedColor = value;
                },
              },
            },
          ],
        },
        {
          title: "事件",
          items: [
            {
              title: "当拖动进度后",
              type: "_event",
              options: {
                outputId: "onChange",
              },
            },
            {
              title: "当播放结束后",
              type: "_event",
              options: {
                outputId: "onEnd",
              },
            },
          ],
        },
      ];
    },
  },
};
