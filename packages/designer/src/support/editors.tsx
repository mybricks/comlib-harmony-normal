export default {
  "@init"({ style, data }) {
    style.width = 200;
    style.height = "auto";
  },
  "@resize": {
    options: ["width"],
  },
  ":root": {
    style: [
      {
        title: "样式",
        options: ["border", "background", "padding", "boxShadow", "font"],
        target: `.mybricks-support`,
      },
    ],
    items({ data, slot }, cate0, cate1, cate2) {
      cate0.title = "技术支持";
      cate0.items = [
        {
          title: "基础属性",
          items: [
            {
              title: "技术支持",
              type: "text",
              value: {
                get({ data }) {
                  return data.copyright;
                },
                set({ data }, value: string) {
                  data.copyright = value;
                },
              },
              binding: {
                with: `data.copyright`,
                schema: {
                  type: "string",
                },
              },
            },
          ],
        },
      ];
    },
  },
};
