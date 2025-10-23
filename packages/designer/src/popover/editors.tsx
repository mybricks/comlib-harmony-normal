import setSlotLayout from "../utils/set-slot-layout";

export type Placement = "top" | "bottom" | "left" | "right";
export type Trigger = "longpress" | "click";

export default {
  "@init"({ style }) {
    style.width = 50;
    style.height = 90;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":slot": {},
  ":root": {
    style: [
      {
        title: "容器样式",
        options: ["padding", "border", "background", "overflow", "boxShadow"],
        target: ".mybricks-popover"
      },
      {
        title: "弹出层",
        options: ["padding", "border", "background", "overflow", "boxShadow"],
        target: ".mybricks-carrier"
      },
      {

        title: '标题',
        options: ['font', 'padding', 'border'],
        global: true,
        target: ".mybricks-carrier-title"
      },
      {
        title: '内容',
        options: ['font', 'padding'],
        global: true,
        target: ".mybricks-carrier-content"
      }
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "气泡";
      cate0.items = [
        {
          title: "基础属性",
          items: [
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
            {
              title: '触发方式',
              type: 'Select',
              options: [
                {
                  label: '点击',
                  value: 'click'
                },
                {
                  label: '长按',
                  value: 'longpress'
                }
              ],
              value: {
                get({ data }: EditorResult<Data>) {
                  return data.trigger;
                },
                set({ data }: EditorResult<Data>, val: Trigger) {
                  data.trigger = val;
                }
              }
            },
          ]
        },
        {
          title: "高级属性",
          items: [
            {
              title: '展示方向',
              type: 'select',
              options: [
                {
                  label: '上',
                  value: 'top'
                },
                {
                  label: '下',
                  value: 'bottom'
                },
                {
                  label: '左',
                  value: 'left'
                },
                {
                  label: '右',
                  value: 'right'
                },
              ],
              value: {
                get({ data }: EditorResult<Data>) {
                  return data.placement;
                },
                set({ data }: EditorResult<Data>, val: Placement) {
                  data.placement = val;
                }
              },
              binding: {
                with: `data.placement`,
                schema: {
                  type: 'string'
                }
              }
            },
            {
              title: "点击气泡后关闭",
              type: "switch",
              value: {
                get({ data }: EditorResult<Data>) {
                  return data.closeOnClick;
                },
                set({ data }: EditorResult<Data>, val: boolean) {
                  data.closeOnClick = val;
                }
              }
            }
          ]
        }


        // {
        //   title: '标题自定义',
        //   type: 'switch',
        //   description: '支持自定义标题组件渲染，请拖入组件作为标题',
        //   value: {
        //     get({ data }: EditorResult<Data>) {
        //       return !!data.useTitleSlot;
        //     },
        //     set({ data, slot }: EditorResult<Data>, val: boolean) {
        //       if (val) {
        //         slot.add('title', '标题');
        //       } else {
        //         slot.remove('title');
        //       }
        //       data.useTitleSlot = val;
        //     }
        //   }
        // },
        // {
        //   title: '标题',
        //   type: 'Text',
        //   options: {
        //     locale: true
        //   },
        //   ifVisible({ data }: EditorResult<Data>) {
        //     return !data.useTitleSlot;
        //   },
        //   value: {
        //     get({ data }: EditorResult<Data>) {
        //       return data.title;
        //     },
        //     set({ data }: EditorResult<Data>, val: string) {
        //       data.title = val;
        //     }
        //   }
        // },
        // {
        //   title: '内容自定义',
        //   type: 'switch',
        //   description: '支持自定义内容组件渲染，请拖入组件作为内容',
        //   value: {
        //     get({ data }: EditorResult<Data>) {
        //       return !!data.useContentSlot;
        //     },
        //     set({ data, slot }: EditorResult<Data>, val: boolean) {
        //       if (val) {
        //         slot.add('content', '内容');
        //       } else {
        //         slot.remove('content');
        //       }
        //       data.useContentSlot = val;
        //     }
        //   }
        // },
        // {
        //   title: '内容',
        //   type: 'Text',
        //   options: {
        //     locale: true
        //   },
        //   ifVisible({ data }: EditorResult<Data>) {
        //     return !data.useContentSlot;
        //   },
        //   value: {
        //     get({ data }: EditorResult<Data>) {
        //       return data.content;
        //     },
        //     set({ data }: EditorResult<Data>, val: string) {
        //       data.content = val;
        //     }
        //   }
        // },


      ];

    },
  }
};
