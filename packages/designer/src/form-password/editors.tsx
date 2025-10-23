export default {
  "@init": ({ style, data }) => {
    style.width = "100%";
    style.height = 40;
  },
  "@resize": {
    options: ["width", "height"],
  },

  ":root": {
    style: [
      {
        title: "输入框",
        options: ["border", "padding", "background"],
        target: [".mybricks-h5Password", ".mybricks-password"]
      },
      {
        title: "内容文本",
        options: ["font"],
        target: [
          `.mybricks-h5Password .taroify-input .taroify-native-input`,
          `.mybricks-password .taroify-input`,
        ]
      },
      {
        title: "提示内容文本",
        options: ["font"],
        target: [
          `.mybricks-h5Password .taroify-native-input::placeholder`,
          `.mybricks-password .taroify-input__placeholder`,
        ]
      },
    ],
    items({ data, output, style }, cate0, cate1, cate2) {
      cate0.title = "密码框";
      cate0.items = [
        {
          title: "基础属性",
          items: [{
            title: "提示内容",
            description: "该提示内容会在值为空时显示",
            type: "text",
            value: {
              get({ data }) {
                return data.placeholder;
              },
              set({ data }, value) {
                data.placeholder = value;
              },
            },
            binding: {
              with: `data.placeholder`,
              schema: {
                type: 'string'
              }
            }
          },
          {
            title: "最大输入长度",
            description: "密码输入框最大输入长度",
            type: "number",
            value: {
              get({ data }) {
                return data.maxlength || 20;
              },
              set({ data }, value) {
                data.maxlength = value;
              },
            },
            binding: {
              with: `data.maxlength`,
              schema: {
                type: 'number'
              }
            }
          },]
        },

        {
          title: "事件",
          items: [{
            title: "当值变化",
            type: "_event",
            options: {
              outputId: "onChange",
            },
          },
          {
            title: "当失去焦点",
            type: "_event",
            options: {
              outputId: "onBlur",
            },
          },],
        },

      ];
    },
  },
};
