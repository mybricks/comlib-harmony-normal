export default {
  "@init"({ style }) {
    style.width = 100;
    style.height = "fit-content";
  },
  "@resize": {
    options: ["width"],
  },
  ":root"({ data, output, style }, cate0, cate1, cate2) {
    cate0.title = "二维码";
    cate0.items = [
      {
        items: [
          {
            title: "基础属性",
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
                binding: {
                  with: `data.text`,
                  schema: {
                    type: "string",
                  },
                },
              },
            ],
          },
        ],
      },
    ];
  },
};
