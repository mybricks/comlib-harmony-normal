import setSlotLayout from "../utils/set-slot-layout";

export default {
  "@init"({ style }) {
    style.width = "100%";
    style.height = 160;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":slot": {},
  ":root": {
    style: [
      {
        title: "样式",
        options: ["padding", "border", "background", "overflow", "boxShadow"],
        target: "> .mybricks-container",
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "容器";
      cate0.items = [
        {
          title: "基础属性",
          items: [
            {
              title: "布局",
              type: "layout",
              value: {
                get({ data, style, slots }) {
                  return style.slots.content.layout || {
                    position:"smart"
                  };
                },
                set({ data,style, slots }, val) {
                  data.layout = val;
                  style.slots.content.layout = val;
                  setSlotLayout(slots.get("content"), val);
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
              title: "当容器滚动时",
              type: "_event",
              options: {
                outputId: "onScroll",
              },
            },
          ],
        },
      ];
    },
  },
};
