export default {
  "@init": ({ style, data }) => {
    style.width = "100%";
    style.height = "auto";
  },
  "@resize": {
    options: ["width"],
  },
  ":root": {
    style: [
      {
        title: "星星样式",
        options: ["font"],
        target: ".taroify-icon",
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
    cate0.title = "常规";
    cate0.items = [
      {
        title: "总分值",
        type: "inputnumber",
        options: [{ title: "", width: "100%" }],
        value: {
          get({ data }: any) {
            return [data.count];
          },
          set({ data }: any, value: [number, number]) {
            [data.count] = value;
          },
        },
      },
      {
        title: "允许打半星",
        type: "switch",
        value: {
          get({ data }: any) {
            return data.allowHalf;
          },
          set({ data }: any, value: any) {
            data.allowHalf = value;
          },
        },
      },
      {},
      {
        title: "当值变化",
        type: "_event",
        options: {
          outputId: "onChange",
        },
      },
    ];
  }
}
}
