export default {
  "@init": ({ style, data }) => {
    style.width = "100%";
    style.height = "auto";
  },
  "@resize": {
    options: ["width"],
  },
  ":root": {
    style: [
      {
        title: "增加按钮样式",
        options: ["border", "background", "font"],
        target: `.taroify-stepper__increase`,
      },
      {
        title: "减少按钮样式",
        options: ["border", "background", "font"],
        target: `.taroify-stepper__decrease`,
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "数字输入";
      cate0.items = [
        {
          title: "数据",
          items: [
            {
              title: "数值",
              type: "inputnumber",
              options: [{ title: "", width: "100%" }],
              value: {
                get({ data }) {
                  return data.value;
                },
                set({ data }, value) {
                  data.value = value;
                },
              },
              binding: {
                with: `data.value`,
                schema: {
                  type: "number",
                },
              },
            },
          ],
        },
        {
          title: "基础属性",
          items: [
            {
              title: "范围",
              type: "inputnumber",
              description: "设置可调整的数字范围",
              options: [
                { title: "最小值", width: 100 },
                { title: "最大值", width: 100 },
              ],
              value: {
                get({ data }: any) {
                  return [data.min, data.max];
                },
                set({ data }: any, value: [number, number]) {
                  [data.min, data.max] = value;
                },
              },
            },
            {
              title: "步长",
              type: "inputnumber",
              description: "每一次点击增加和减少调整的数值",
              options: [{ title: "", width: "100%" }],
              value: {
                get({ data }: any) {
                  return [data.step];
                },
                set({ data }: any, value: [number, number]) {
                  [data.step] = value;
                },
              },
              binding: {
                with: `data.step`,
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
              title: "当值变化",
              type: "_event",
              options: {
                outputId: "onChange",
              },
            },
          ],
        },
      ];
    },
  },
};
