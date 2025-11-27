export default {
  "@init": ({ style, data }) => {
    style.width = "100%";
    style.height = "auto";
  },
  "@resize": {
    options: ["width"],
  },
  ":slot": {},
  ":root": {
    style: [
      {
        title: "卡片尺寸",
        options: ["size", "border", "background", "boxShadow", "margin"],
        target: ".mybricks-square",
      },
      {
        title: "选择图标",
        options: ["font"],
        target: ".mybricks-icon",
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "图片上传";
      cate0.items = [
        {
          title: "数据",
          items: [
            {
              title: "数据源",
              type: "json",
              options: {
                minimap: {
                  enabled: false,
                },
                height: 80,
                autoSave: false,
                encodeValue: false,
              },
              value: {
                get({ data }: EditorResult<Data>) {
                  return data.value ?? [];
                },
                set({ data }: EditorResult<Data>, value: any) {
                  if (!Array.isArray(value)) {
                    return;
                  }
                  data.value = value;
                },
              },
              binding: {
                with: `data.value`,
                schema: {
                  type: "array",
                },
              },
            },
          ],
        },
        {
          title: "基础属性",
          items: [
            {
              title: "最大上传数量",
              type: "text",
              options: {
                plugins: ["number"],
              },
              value: {
                get({ data }) {
                  return data.maxCount;
                },
                set({ data }, value) {
                  data.maxCount = value;
                },
              },
              binding: {
                with: `data.maxCount`,
                schema: {
                  type: "number",
                },
              },
            },
            {
              title: "提示内容",
              type: "text",
              value: {
                get({ data }) {
                  return data.placeholderText;
                },
                set({ data }, value) {
                  data.placeholderText = value;
                },
              },
              binding: {
                with: `data.placeholderText`,
                schema: {
                  type: "string",
                },
              },
            },
          ],
        },
        {
          title: "高级属性",
          items: [
            {
              title: "示例图",
              type: "imageSelector",
              options: {
                fileSizeLimit: 2,
              },
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
                  type: "string",
                },
              },
            },
            {
              title: "开启占位插槽",
              type: "Switch",
              value: {
                get({ data }) {
                  return data.iconSlot;
                },
                set({ data }, value) {
                  data.iconSlot = value;
                },
              },
            },
            {
              title: "格式化为字符串",
              description: "仅在最大上传数量为1时有效",
              type: "switch",
              value: {
                get({ data }) {
                  return data.useValueString;
                },
                set({ data }, value) {
                  data.useValueString = value;
                },
              },
            },
          ],
        },
        {
          title: "事件",
          items: [
            {
              title: "值变化",
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
