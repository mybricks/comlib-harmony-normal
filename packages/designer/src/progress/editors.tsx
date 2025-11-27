export default {
  "@init"({ style }) {
    style.width = 200;
    style.height = 10;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
      {
        title: "背景",
        options: ["border", "background", "boxShadow"],
        target: ".mybricks-progress-bg",
      },
      {
        title: "进度条",
        options: ["border", "background"],
        target: ".mybricks-progress-bar",
      },
    ],
    items({ data, slot }, cate0, cate1, cate2) {
      cate0.title = "进度条";
      cate0.items = [
        {
          title: "基础属性",
          items: [
            {
              title: "初始进度",
              type: "inputnumber",
              options: [{ min: 1 }],
              value: {
                get({ data }) {
                  return [data.initValue];
                },
                set({ data }, value: string) {
                  if (Array.isArray(value)) {
                    data.initValue = value?.[0];
                  } else {
                    data.initValue = value;
                  }
                },
              },
              binding: {
                with: `data.initValue`,
                schema: {
                  type: "number",
                },
              },
            },
          ],
        },
        {
          title: "事件",
          items: [
            {
              title: "当进度结束时",
              type: "_event",
              options: {
                outputId: "onEnded",
              },
            },
          ],
        },
      ];
    },
  },
};
