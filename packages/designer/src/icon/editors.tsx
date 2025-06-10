import IconSelector from "./editors/icon-selector";

export default {
  "@init": ({ style, data }) => {
    style.width = "auto";
    style.height = "auto";
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "常规";
      cate0.items = [
        {
          title: "图标设置",
          items: [
            {
              title: "图标",
              description: "设置徽标内容时请注意为组件设置合适的尺寸",
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
          ],
        },
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
