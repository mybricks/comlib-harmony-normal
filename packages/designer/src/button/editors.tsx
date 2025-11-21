export default {
  "@init"({ style, data, output }) {
    style.width = 120;
    style.height = 42;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    "@dblclick": {
      type: "text",
      value: {
        get({ data }) {
          return data.text;
        },
        set({ data }, val) {
          data.text = val;
        },
      },
    },
    style: [
      {
        items: [
          {
            title: "按钮",
            catelog: "默认",
            options: ["font", "border", "background", "boxshadow", "padding"],
            target: ".mybricks-button",
            defaultOpen: true,
          },
          {
            title: "按钮",
            catelog: "禁用",
            options: ["font", "border", "background", "boxshadow", "padding"],
            target: ".mybricks-button-disable",
            defaultOpen: true,
          },
        ],
      },
    ],

    items: [
      {
        title: "基础属性",
        items: [
          {
            title: "按钮文案",
            type: "text",
            value: {
              get({ data }) {
                return data.text;
              },
              set({ data, outputs }, value: string) {
                data.text = value;
              },
            },
            binding: {
              with: "data.text",
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
            title: "单击",
            type: "_event",
            options: {
              outputId: "onClick",
            },
          },
        ],
      },
    ],
  },
};
