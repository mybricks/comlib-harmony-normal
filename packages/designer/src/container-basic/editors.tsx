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
        target: "> .mybricks-container"
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      //兼容老版本容器的「当容器滚动」事件
      output.add({
        id: "onScroll",
        title: "当容器滚动时",
        schema: {
          type: "object",
          properties: {
            xOffset: {
              type: "number"
            },
            yOffset: {
              type: "number"
            },
            scrollTop: {
              type: "number"
            },
            scrollLeft: {
              type: "number"
            }
          }
        },
        editable: true,
        deletable: true,
      });
      cate0.title = "常规";
      cate0.items = [
        {
          title: "布局",
          type: "layout",
          value: {
            get({ data }) {
              return data.layout;
            },
            set({ data, slots }, val) {
              data.layout = val;
              setSlotLayout(slots.get("content"), val);
            },
          },
        },
        {},
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
            outputId: "onScroll"
          }
        }
      ];
    },
  },
};
