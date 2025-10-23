import setSlotLayout from "../utils/set-slot-layout";

export default {
  "@init"({ style }) {
    style.width = "100%";
    style.height = 500;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":slot": {},
  ":root": {
    style: [
      // {
      //   title: "样式",
      //   options: ["padding", "border", "background", "overflow", "boxShadow"],
      //   target: "> .mybricks-container"
      // },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "AI音乐播放器";
      cate0.items = [
        // {
        //   title: "布局",
        //   type: "layout",
        //   value: {
        //     get({ data }) {
        //       return data.layout;
        //     },
        //     set({ data, slots }, val) {
        //       data.layout = val;
        //       setSlotLayout(slots.get("content"), val);
        //     },
        //   },
        // },
        {
          title: "事件",
          items: [
            {
              title: "当点击播放列表",
              type: "_event",
              options: {
                outputId: "onPlayListClick",
              },
            },
            {
              title: "当点击修改时",
              type: "_event",
              options: {
                outputId: "onEditClick",
              },
            },
          ],
        },
      ];
    },
  },
};
