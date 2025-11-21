import ImageFitMode from "./../utils/editors/image-fit-mode";

export default {
  "@init"({ style }) {
    style.width = 200;
    style.height = 200;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
      {
        title: "图片",
        options: ["border", "background", "boxshadow"],
        target: `.mybricks-image`,
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "图片";
      cate0.items = [
        {
          title: "基础属性",
          items: [
            {
              title: "图片链接",
              type: "imageSelector",
              value: {
                get({ data }) {
                  return data.src;
                },
                set({ data }, src: string) {
                  data.src = src;

                  // 如果 src 是 svg 标签，就转为 base64
                  if (src && src.startsWith("<svg")) {
                    let base64 = window.btoa(src);
                    data.svgPolyfill = `data:image/svg+xml;base64,${base64}`;
                  } else {
                    data.svgPolyfill = "";
                  }
                },
              },
              binding: {
                with: "data.src",
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
              title: "展示方式",
              type: "editorRender",
              description:
                "展示方式的区别主要在图片尺寸与配置尺寸对不齐的情况下起作用",
              options: {
                render: ImageFitMode,
              },
              value: {
                get({ data, style }) {
                  return {
                    mode: data.mode,
                    style: style,
                  };
                },
                set({}, value) {
                  data.mode = value;
                },
              },
            },
          ],
        },
        {
          title: "事件",
          items: [
            {
              title: "单击",
              type: "_event",
              options: {
                outputId: "onClick",
              },
            },

            {
              title: "当图片按下",
              type: "_event",
              options: {
                outputId: "onPress",
              },
            },
            {
              title: "加载完毕",
              type: "_event",
              options: {
                outputId: "onLoad",
              },
            },
            {
              title: "加载失败",
              type: "_event",
              options: {
                outputId: "onError",
              },
            },
          ],
        },
      ];
    },
  },
};
