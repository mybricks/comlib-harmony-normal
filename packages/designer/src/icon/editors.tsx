import IconSelector from "./editors/icon-selector";

export default {
  "@init": ({ style, data }) => {
    style.width = data.fontSize;
    style.height = data.fontSize;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
      {
        title: "图标",
        options: ["border", "padding", "background"],
        target: ".mybricks-icon",
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "常规";
      cate0.items = [
        {
          title: "图标",
          type: "editorRender",
          options: {
            render: (props) => {
              return <IconSelector value={props.editConfig.value}  />;
            },
          },
          value: {
            get({ data }) {
              return data.icon;
            },
            set({ data }, value: string) {
              data.icon = value;
            },
          },
        },
        {
          title: "大小",
          type: "inputnumber",
          options: [{ min: 1 }],
          value: {
            get({ data }) {
              return [data.fontSize];
            },
            set({ data }, value: string) {
              data.fontSize = value?.[0];
            },
          },
        },
        {
          title: "颜色",
          type: "colorpicker",
          value: {
            get({ data }) {
              return data.fontColor?.[0];
            },
            set({ data }, value: string) {
              data.fontColor[0] = value;
            },
          },
        },
        {
          title: "线宽",
          type: "select",
          options: [
            { label: '超细', value: 100 },
            { label: '较细', value: 200 },
            { label: '细', value: 300 },
            { label: '常规', value: 400 },
            { label: '宽', value: 500 },
            { label: '较宽', value: 600 },
            { label: '超宽', value: 800 },
          ],
          value: {
            get({ data }) {
              return data.fontWeight;
            },
            set({ data }, value: number) {
              data.fontWeight = value;
            },
          },
        }
      ];
  
      cate1.title = "样式";
      cate1.items = [];
  
      cate2.title = "动作";
      cate2.items = [
        {
          title: "单击",
          type: "_event",
          options: {
            outputId: "onClick",
          },
        },
      ];
    },
  }
  
};
