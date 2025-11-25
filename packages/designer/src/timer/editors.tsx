export default {
  "@init"({ style }) {
    style.width = "auto";
    style.height = "auto";
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
      {
        title: "容器",
        options: ["background", "border", "padding", "boxShadow"],
        target: ".mybricks_timer",
      },
      {
        title: "数字",
        options: ["font"],
        target: ".mybricks_timer_unit",
      },
      {
        title: "数字背景",
        options: ["background", "size", "border", "padding", "boxShadow"],
        target: ".mybricks_timer_unit_background",
      },
      {
        title: "分割符",
        options: ["font", "margin"],
        target: ".mybricks_timer_separator",
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "计时器";
      cate0.items = [
        {
          items: [
            {
              title: "基础属性",
              items: [
                {
                  title: "时钟类型",
                  type: "select",
                  options: [
                    { label: "当前时间", value: "realtime" },
                    { label: "倒计时", value: "countdown" },
                    { label: "计时器", value: "timer" },
                  ],
                  value: {
                    get({ data }) {
                      return data.clockType;
                    },
                    set({ data }, value: string) {
                      data.clockType = value;
                    },
                  },
                  binding: {
                    with: `data.clockType`,
                    schema: {
                      type: "string",
                    },
                  },
                },
                {
                  title: "启动后立即开始",
                  type: "switch",
                  ifVisible: ({ data }) => {
                    return data.clockType !== "realtime";
                  },
                  value: {
                    get({ data }) {
                      return data.startImmediately ?? true;
                    },
                    set({ data }, value: boolean) {
                      data.startImmediately = value;
                    },
                  },
                },
                {
                  title: "倒计时",
                  type: "textinput",
                  ifVisible: ({ data }) => {
                    return data.clockType === "countdown";
                  },
                  value: {
                    get({ data }) {
                      return data.countdown;
                    },
                    set({ data }, value: string) {
                      data.countdown = value;
                    },
                  },
                },
              ],
            },
            {
              title: "事件",
              items: [
                {
                  title: "当前时间",
                  type: "_event",
                  options: {
                    outputId: "currentTime",
                  },
                },
                {
                  title: "倒计时结束触发",
                  ifVisible: ({ data }) => {
                    return data.clockType === "countdown";
                  },
                  type: "_event",
                  options: {
                    outputId: "finishCountDown",
                  },
                },
              ],
            },
          ],
        },
      ];
    },
  },
};
