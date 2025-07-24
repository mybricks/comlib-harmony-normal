export default {
  "@init"({ style }) {
    style.width = 100;
    style.height = "fit-content";
  },
  "@resize": {
    options: ["width"],
  },
  ":root"({ data, output, style }, cate0, cate1, cate2) {
    cate0.title = "常规";
    cate0.items = [
      {
        items: [
          {
            title: "二维码内容",
            type: "text",
            value: {
              get({ data }) {
                return data.text;
              },
              set({ data }, text: string) {
                data.text = text;
              },
            },
          },
        ],
      },
    ];
  },
};
