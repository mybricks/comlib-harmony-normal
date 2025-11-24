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
        ifVisible({ data }) {
          return data.type === "switch" || !data.type;
        },
        title: "尺寸",
        options: ["size"],
        target: ".taroify-switch",
      },
      {
        ifVisible({ data }) {
          return data.type === "switch" || !data.type;
        },
        title: "滑块",
        options: [
          { type: "size", config: { disableHeight: true } },
          {
            type: "background",
            config: { disableBackgroundImage: true, disableGradient: true },
          },
        ],
        target: ".taroify-switch__node::after",
      },
      {
        ifVisible({ data }) {
          return data.type === "switch" || !data.type;
        },
        title: "滑轨未激活样式",
        options: ["background"],
        target: ".taroify-switch:not(.taroify-switch--checked)",
      },
      {
        ifVisible({ data }) {
          return data.type === "switch" || !data.type;
        },
        title: "滑轨激活样式",
        options: ["background"],
        target: ".taroify-switch--checked",
      },
      {
        ifVisible({ data }) {
          return data.type === "checkbox";
        },
        title: "尺寸",
        options: ["size"],
        target: ".taroify-icon",
      },
      {
        ifVisible({ data }) {
          return data.type === "checkbox";
        },
        title: "未激活样式",
        options: [
          {
            type: "background",
            config: { disableBackgroundImage: true, disableGradient: true },
          },
        ],
        target: `.mybricks-inactive .taroify-icon`,
      },
      {
        ifVisible({ data }) {
          return data.type === "checkbox";
        },
        title: "激活样式",
        options: [
          {
            type: "background",
            config: { disableBackgroundImage: true, disableGradient: true },
          },
        ],
        target: `.mybricks-active .taroify-icon`,
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "开关";
      cate0.items = [
        {
          title: "数据",
          items: [
            {
              title: "数据值",
              type: "switch",
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
                  type: "boolean",
                },
              },
            },
          ],
        },
        {
          title: "基础属性",
          items: [
            {
              title: "外观",
              type: "radio",
              options: [
                { label: "开关", value: "switch" },
                { label: "选择框", value: "checkbox" },
              ],
              value: {
                get({ data }) {
                  return data.type || "switch";
                },
                set({ data }, value) {
                  data.type = value;
                },
              },
              binding: {
                with: `data.type`,
                schema: {
                  type: "string",
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
