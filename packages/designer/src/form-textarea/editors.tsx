export default {
  "@init": ({ style, data }) => {
    style.width = "100%";
    style.height = 100;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
      {
        title: "输入框",
        options: ["size", "border", "padding", "background"],
        target: ".taroify-textarea__wrapper",
      },
      {
        title: "内容文本",
        options: ["font"],
        target:[
          ".taroify-textarea__wrapper .mybricks-h5Textarea .taroify-native-textarea",
          ".taroify-textarea__wrapper .mybricks-textarea",
        ]
      },
      {
        title: "提示内容文本",
        options: ["font"],
        target:[
          ".taroify-textarea__wrapper .mybricks-h5Textarea .taroify-native-textarea::placeholder",
          ".taroify-textarea__wrapper .taroify-textarea__placeholder",
        ]
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "常规";
      cate0.items = [
        {
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
          title: "限制字数",
          description: "限制字数后会在右下角展示字数统计",
          type: "inputnumber",
          options: [{ title: "", width: "100%", min: 0 }],
          value: {
            get({ data }: any) {
              return [data.limit];
            },
            set({ data }: any, value: [number, number]) {
              [data.limit] = value;
            },
          },
          binding: {
            with: `data.limit`,
            schema: {
              type: 'number'
            }
          }
        },
        {
          title: "展示字数统计",
          description: "开启后，右下角会展示字数统计",
          type: "switch",
          ifVisible({ data }: EditorResult<Data>) {
            return data.limit > 0;
          },
          value: {
            get({ data }: any) {
              return data.showCount;
            },
            set({ data }: any, value: [number, number]) {
              data.showCount = value;
            },
          },
          binding: {
            with: `data.showCount`,
            schema: {
              type: 'boolean'
            }
          }
        },
        {
          title: "自动高度",
          description: "开启后，输入框的高度会随着输入内容的增多自动增高",
          type: "switch",
          value: {
            get({ data }: any) {
              return data.autoHeight;
            },
            set({ data }: any, value: [number, number]) {
              data.autoHeight = value;
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
              type: 'boolean'
            }
          }
        },
        {
          title: "当值变化",
          type: "_event",
          options: {
            outputId: "onChange",
          },
        },
        {
          title: "当聚焦输入",
          type: "_event",
          options: {
            outputId: "onFocus",
          },
        },
        {
          title: "当失去焦点",
          type: "_event",
          options: {
            outputId: "onBlur",
          },
        },
      ];
    },
  },
};
