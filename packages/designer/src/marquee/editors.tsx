import { autoCdnCut } from "./../utils/image";

const Schemas = {
  ImageDataSource: {
    type: 'array'
  },
  CustomDataSource: {
    type: 'array'
  }
}

export default {
  "@init": ({ style, data }) => {
    style.width = "fit-content";
    style.height = "fit-content";
  },
  ":slot": {},
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
    ],
    items({ data, output, style, slots }, cate0, cate1, cate2) {
      cate0.title = "常规";
      cate0.items = [
        {
          title: "排列方向",
          type: "select",
          options: [
            { label: "竖向排列", value: 'column' },
            { label: "横向排列", value: 'row' },
          ],
          value: {
            get({ data }) {
              return data.direction ?? 'column';
            },
            set({ data }, value) {
              data.direction = value;
            },
          }
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
        },
        {
          title: "播放设置",
          ifVisible({ data }: EditorResult<Data>) {
            return data.contentType !== 'custom';
          },
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
              binding: {
                with: `data.autoplay`,
                schema: {
                  type: 'boolean'
                }
              }
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
              binding: {
                with: `data.circular`,
                schema: {
                  type: 'boolean'
                }
              }
            },
            {
              title: "动画时长(ms)",
              type: "text",
              value: {
                get({ data }) {
                  return data.duration ?? 6000;
                },
                set({ data }, value) {
                  data.duration = value;
                },
              },
              binding: {
                with: `data.duration`,
                schema: {
                  type: 'number'
                }
              }
            },
          ],
        },
        // {
        //   title: "事件",
        //   items: [
        //     {
        //       title: "当滚动到顶部",
        //       type: "_event",
        //       options: {
        //         outputId: "onReachStart",
        //       },
        //     },
        //   ],
        // },
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
          binding: {
            with: `data.rowKey`,
            schema: {
              type: 'string'
            }
          }
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
  },
};


function computedActions(params) {
  let before = params.before || [];
  let after = params.after || [];
  let actions: any = [];
  
  // 创建 id 到 item 的映射对象
  let beforeMap = {};
  let afterMap = {};
  
  // 构建 before 映射
  before.forEach(function(item) {
    beforeMap[item._id] = item;
  });
  
  // 构建 after 映射
  after.forEach(function(item) {
    afterMap[item._id] = item;
  });
  
  // 处理删除的项
  for (let id in beforeMap) {
    if (beforeMap.hasOwnProperty(id)) {
      if (!afterMap[id]) {
        actions.push({
          name: "remove",
          value: beforeMap[id]
        });
      }
    }
  }
  
  // 处理新增的项
  for (let id in afterMap) {
    if (afterMap.hasOwnProperty(id)) {
      if (!beforeMap[id]) {
        actions.push({
          name: "add",
          value: afterMap[id]
        });
      }
    }
  }
  
  // 处理更新的项
  for (let id in afterMap) {
    if (afterMap.hasOwnProperty(id)) {
      if (beforeMap[id] && JSON.stringify(beforeMap[id]) !== JSON.stringify(afterMap[id])) {
        actions.push({
          name: "update",
          value: afterMap[id]
        });
      }
    }
  }
  
  return actions;
}