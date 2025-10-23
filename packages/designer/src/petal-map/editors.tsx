// import GeoConfig from './editor/geoConfig'

export default {
  "@init": ({ style, data }) => {
    style.width = "100%";
    style.height = 300;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
      {
        title: "样式",
        options: ["border", "background"],
        target: `.mybricks-map`,
      },
    ],
    items({ data, output, style }, cate0, cate1, cate2) {
      cate0.title = "地图";
      cate0.items = [
        {
          title: "基础属性",
          items: [
            {
              title: "展示比例尺",
              type: "switch",
              value: {
                get({ data }) {
                  return data.showScale;
                },
                set({ data }, val) {
                  data.showScale = val;
                },
              },
              binding: {
                with: `data.showScale`,
                schema: {
                  type: "boolean",
                },
              },
            },
            {
              title: "展示指南针",
              type: "switch",
              value: {
                get({ data }) {
                  return data.showCompass;
                },
                set({ data }, val) {
                  data.showCompass = val;
                },
              },
              binding: {
                with: `data.showCompass`,
                schema: {
                  type: "boolean",
                },
              },
            },
            {
              title: "支持缩放",
              type: "switch",
              value: {
                get({ data }) {
                  return data.enableZoom;
                },
                set({ data }, val) {
                  data.enableZoom = val;
                },
              },
              binding: {
                with: `data.enableZoom`,
                schema: {
                  type: "boolean",
                },
              },
            },
            {
              title: "支持拖动",
              type: "switch",
              value: {
                get({ data }) {
                  return data.enableScroll;
                },
                set({ data }, val) {
                  data.enableScroll = val;
                },
              },
              binding: {
                with: `data.enableScroll`,
                schema: {
                  type: "boolean",
                },
              },
            },
          ],
        },
        {
          title: "高级属性",
          items: [
            {
              title: "展示实时路况",
              type: "switch",
              value: {
                get({ data }) {
                  return data.enableTraffic;
                },
                set({ data }, val) {
                  data.enableTraffic = val;
                },
              },
              binding: {
                with: `data.enableTraffic`,
                schema: {
                  type: "boolean",
                },
              },
            },
          ],
        },
        // {
        //   title: "事件",
        //   items: [
        //     {
        //       title: "单击",
        //       type: "_event",
        //       options: {
        //         outputId: "onClick",
        //       },
        //     },
        //   ],
        // },
      ];
    },
  },
};
