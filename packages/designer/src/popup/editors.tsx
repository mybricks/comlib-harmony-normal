import setSlotLayout from "../utils/set-slot-layout";

export default {
  "@init"({ data, style }) {
    style.width = "100%";
    style.height = "100%";
  },
  ":slot": {},
  ":root": {
    style: [
      {
        title: "遮罩样式",
        options: ["background"],
        target: ".mybricks-overlay",
      },
      {
        title: "主要内容区域",
        items: [
          {
            title: "布局",
            type: "layout",
            value: {
              get({ data }) {
                return data.layout || {};
              },
              set({ data, slots }, val: any) {
                console.warn("set layout", val);

                data.layout = val;
                setSlotLayout(slots.get("content"), val);
              },
            },
          },
          {
            title: "样式",
            options: [
              "size",
              "padding",
              "border",
              "background",
              "overflow",
              "boxShadow",
            ],
            target: ".mybricks-content",
          },
        ],
      },
    ],
    items({ data, output, style }, cate0, cate1, cate2) {
      cate0.title = "常规";
      cate0.items = [
        {
          title: "弹出位置",
          type: "Select",
          options: [
            { value: "center", label: "居中" },
            { value: "top", label: "顶部弹出" },
            { value: "bottom", label: "底部弹出" },
            { value: "left", label: "左侧弹出" },
            { value: "right", label: "右侧弹出" },
          ],
          value: {
            get({ data }) {
              return data.position;
            },
            set({ data }, val) {
              data.position = val;
            },
          },
        },
        {
          title: "点击蒙层关闭",
          type: "switch",
          value: {
            get({ data }) {
              return data.maskClose;
            },
            set({ data }, val) {
              data.maskClose = val;
            },
          },
        },
        {
          ifVisible({ data }) {
            return !!data.maskClose;
          },
          title: "点击蒙层关闭时",
          type: "_event",
          options: {
            outputId: "onClickOverlay",
          },
        },
      ];
    },
  },
};
