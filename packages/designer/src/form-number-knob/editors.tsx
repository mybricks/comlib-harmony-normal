export default {
  "@init": ({ style, data }) => {
    style.width = "100%";
  },
  "@resize": {
    options: ["width"],
  },
  ":root": {
    style: [
      {
        title: "数字旋钮",
        options: ["background"],
        target: ".mybricks-form-number-knob",
      },
      {
        title: "指针",
        options: ["size", "border", "background"],
        target: ".mybricks-form-number-knob-pointer",
      },
      {
        title: "中心位置",
        options: ["size", "border", "background"],
        target: ".mybricks-form-number-knob-center",
      },
    ],
    items: ({ data, output, style, slots }, cate0, cate1, cate2) => {
      cate0.title = "数字旋钮";
      cate0.items = [
        {
          title: "数据",
          items: [
            {
              title: "数值",
              type: "inputnumber",
              options: [{ title: "", width: "100%" }],
              value: {
                get({ data }: any) {
                  return [data.value];
                },
                set({ data }: any, value: [number, number]) {
                  [data.value] = value;
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
              title: "旋转一圈数值",
              type: "inputnumber",
              options: [{ title: "", width: "100%" }],
              value: {
                get({ data }: any) {
                  return [data.lapValue];
                },
                set({ data }: any, value: [number, number]) {
                  [data.lapValue] = value;
                },
              },
            },
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
          ],
        },
        {
          title: "高级属性",
          items: [
            {
              title: "指针位置",
              description: "设置指针距离外圈的位置",
              type: "inputnumber",
              options: [{ title: "", width: "100%" }],
              value: {
                get({ data }: any) {
                  return [data.pointerY];
                },
                set({ data }: any, value: [number, number]) {
                  [data.pointerY] = value;
                },
              },
            },
            {
              title: "禁用编辑",
              type: "Switch",
              value: {
                get({ data }) {
                  return data.disabled;
                },
                set({ data }, value) {
                  data.disabled = value;
                },
              },
              binding: {
                with: `data.disabled`,
                schema: {
                  type: "boolean",
                },
              },
            },
            {
              title: "开启中心插槽",
              type: "Switch",
              value: {
                get({ data }) {
                  return data.openSlot;
                },
                set({ data }, value) {
                  data.openSlot = value;
                  if (slots.get(`slot_center`) && !value) {
                    slots.remove(`slot_center`);
                  }
                  if (value && !slots.get(`slot_center`)) {
                    slots.add({
                      id: "slot_center",
                      title: "中心插槽",
                    });
                  }
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
