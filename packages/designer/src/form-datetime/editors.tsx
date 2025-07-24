import DatePicker from "./editor/date-picker";

export default {
  "@init": ({ style, data }) => {
    style.width = "100%";
    style.height = "auto";
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":slot": {},
  ":root": {
    style: [
      {
        title: "样式",
        options: ["border", "background"],
        target: `.mybricks-datetime`,
      }
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "常规";
      cate0.items = [
        {
          title: "开启清空按钮",
          type: "switch",
          value: {
            get({ data }) {
              return data.clearable;
            },
            set({ data }, value) {
              data.clearable = value;
            },
          }
        },
        {
          title: "配置为插槽",
          type: "switch",
          value: {
            get({ data }) {
              return data.isSlot;
            },
            set({ data, slot, style }, value) {
              data.isSlot = value;
              if (value) {
                style.height = 50;
                style.width = 50;
              } else {
                style.height = 24;
                style.width = 375;
              }
            },
          },
        },
        {
          title: "提示内容",
          description: "该提示内容会在值为空时显示",
          type: "text",
          ifVisible({ data }) {
            return !data.isSlot;
          },
          value: {
            get({ data }) {
              return data.placeholder;
            },
            set({ data }, value) {
              data.placeholder = value;
            },
          },
        },
        {
          title: "时间类型",
          type: "select",
          options: [
            { label: "日期", value: "date" },
            { label: "时间", value: "time" },
            { label: "年", value: "year" },
            { label: "年-月", value: "year-month" },
          ],
          value: {
            get({ data }) {
              return data.type;
            },
            set({ data }, value) {
              data.type = value;
            },
          },
        },
        {
          title:"输出日期格式",
          type: "select",
          ifVisible({ data }) {
            return data.type == "date";
          },
          options:[
            {label: "时间戳", value: "timestamp"},
            {label: "YYYY-MM-DD", value: "YYYY-MM-DD"}
          ],
          value: {
            get({ data }) {
              return data.outputType;
            },
            set({ data }, value) {
              data.outputType = value;
            },
          }
        },
        {
          title: "时间范围",
          items: [
            {
              title: "可选的最小时间",
              type: "editorRender",
              options: {
                render: DatePicker,
              },
              value: {
                get({ data }) {
                  return data.min;
                },
                set({ data }, value) {
                  data.min = value;
                },
              },
            },
            {
              title: "可选的最大时间",
              type: "editorRender",
              options: {
                render: DatePicker,
              },
              value: {
                get({ data }) {
                  return data.max;
                },
                set({ data }, value) {
                  data.max = value;
                },
              },
            },
          ],
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
        },
        {
          title: "当值变化",
          type: "_event",
          options: {
            outputId: "onChange",
          },
        },
      ];
    },
  },
};
