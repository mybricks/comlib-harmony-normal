import { autoCdnCut } from "./../utils/image";

export default {
  "@init": ({ style, data }) => {
    style.width = "100%";
    style.height = 98;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
      {
        title: "轮播",
        options: ["border"],
        target: ".mybricks-swiper-wrapper",
      },
      {
        title: "默认指示器",
        options: [
          { type: "background", config: { disableBackgroundImage: true } },
        ],
        target: ".mybricks-swiper-wrapper .indicator:not(.indicator-active)",
      },
      {
        title: "高亮指示器",
        options: [
          { type: "background", config: { disableBackgroundImage: true } },
        ],
        target: ".mybricks-swiper-wrapper .indicator.indicator-active",
      },
    ],
    items({ data, output, style }, cate0, cate1, cate2) {
      cate0.title = "常规";
      cate0.items = [
        {
          title: "轮播项",
          type: "array",
          options: {
            getTitle: (item, index) => {
              return [
                <div style={{ display: "flex", alignItems: "center" }}>
                  轮播图：
                  <img
                    style={{ display: "block", height: 30 }}
                    src={autoCdnCut(
                      { url: item.thumbnail, height: 50 },
                      { quality: 85 }
                    )}
                  />
                </div>,
              ];
            },
            selectable: true,
            onSelect: (_id, index) => {
              if (index !== -1) {
                if (!data?.edit) {
                  data?.edit = {};
                }
                data?.edit?.current = index;
              }
            },
            onAdd() {
              return {
                thumbnail:
                  "data:image/png;base64,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",
              };
            },
            items: [
              {
                title: "图片",
                type: "imageSelector",
                value: "thumbnail",
              },
            ],
          },
          value: {
            get({ data }) {
              return data.items;
            },
            set({ data }, value) {
              data.items = value;
            },
          },
        },
        {
          title: "播放设置",
          items: [
            {
              title: "自动播放",
              type: "switch",
              value: {
                get({ data }) {
                  return data.autoplay;
                },
                set({ data }, value) {
                  data.autoplay = value;
                },
              },
            },
            {
              title: "自动切换时间间隔(ms)",
              type: "text",
              options: {
                type: "number",
              },
              value: {
                get({ data }) {
                  return data.interval ?? 5000;
                },
                set({ data }, value) {
                  data.interval = value;
                },
              },
            },
            {
              title: "循环轮播",
              description: "滑动到最后一项后可以继续滑动到第一项",
              type: "switch",
              value: {
                get({ data }) {
                  return data.circular ?? true;
                },
                set({ data }, value) {
                  data.circular = value;
                },
              },
            },
            // {
            //   title: "动画时长(ms)",
            //   type: "text",
            //   value: {
            //     get({ data }) {
            //       return data.duration ?? 500;
            //     },
            //     set({ data }, value) {
            //       data.duration = value;
            //     },
            //   },
            // },
          ],
        },
        {
          title: "展示指示器",
          type: "switch",
          value: {
            get({ data }) {
              return data.showIndicator ?? true;
            },
            set({ data }, value) {
              data.showIndicator = value;
            },
          },
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
          ],
        },
      ];
    },
  },
};
