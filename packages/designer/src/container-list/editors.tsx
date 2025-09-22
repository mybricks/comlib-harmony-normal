import { Direction } from "./constant";

export default {
  "@init": ({ style, data, output }) => {
    style.width = 375;
    style.height = "auto";
  },
  ":slot": {},
  "@resize": {
    options: ["width", "height"],
  },
  "@inputConnected"({ data, input, output, slots }, fromPin, toPin) {
    if (toPin.id === "dataSource") {
      let itemSchema = {};
      if (fromPin.schema.type === "array") {
        itemSchema = fromPin.schema.items;
        input.get("dataSource").setSchema(fromPin.schema);
        slots.get("item").inputs.get("itemData").setSchema(itemSchema);
      }
    }
  },
  ":root"({ data, output, style }, cate0, cate1, cate2) {
    cate0.title = "常规";
    cate0.items = [
      {
        title: "排列方向",
        type: "select",
        options: [
          { label: "竖向排列", value: Direction.Column },
          { label: "横向排列", value: Direction.Row },
        ],
        value: {
          get({ data }) {
            return data.direction ?? Direction.Column;
          },
          set({ data }, value) {
            data.direction = value;
          },
        },
      },
      {
        title: "间距",
        description: "当竖向排列时，为垂直间距；当横向排列时，为水平间距",
        type: "text",
        options: {
          type: "number",
        },
        value: {
          get({ data }) {
            return data.spacing;
          },
          set({ data }, value) {
            data.spacing = value;
          },
        },
        binding: {
          with: `data.spacing`,
          schema: {
            type: 'number'
          }
        }
      },
      {
        title: "开启换行",
        type: "switch",
        ifVisible({ data }) {
          return data.direction === Direction.Row;
        },
        value: {
          get({ data }) {
            return data.wrap;
          },
          set({ data }, value) {
            data.wrap = value;
          },
        },
      },
      {
        title: "显示滚动条",
        type: "switch",
        value: {
          get({ data }) {
            return data.scrollBar;
          },
          set({ data }, value) {
            data.scrollBar = value;
          },
        },
      },
      {
        title: "事件",
        items: [
          {
            title: "当滚动到顶部",
            type: "_event",
            options: {
              outputId: "onReachStart",
            },
          },
        ],
      },
    ];
    cate1.title = "样式";
    cate1.items = [];
    cate2.title = "高级";
    cate2.items = [
      {
        title: "唯一主键",
        type: "text",
        value: {
          get({ data }) {
            return data.rowKey;
          },
          set({ data }, value) {
            data.rowKey = value;
          },
        },
      },
      // {
      //   title: "升级",
      //   type: "button",
      //   value: {
      //     set({ output }) {
      //       output.add({
      //         id: "onReachStart",
      //         title: "当滚动到顶部",
      //         "schema": {
      //           "type": "string"
      //         }
      //       });
      //     }
      //   }
      // }
    ];
  },
};
