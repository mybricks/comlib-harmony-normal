export default {
  "@init": ({ style, data }) => {
    style.width = "100%";
    style.height = 40;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
      {
        title: "输入框",
        options: ["border", "padding", "background"],
        target:[`.mybricks-h5Input .taroify-native-input`, `.mybricks-input`]
      },
      {
        title: "内容文本",
        options: ["font"],
        target: [`.mybricks-h5Input .taroify-native-input`, `.mybricks-input`]
      },
      {
        title: "提示内容文本",
        options: ["font"],
        target:[
          `.mybricks-h5Input .taroify-native-input::placeholder`,
          `.mybricks-input .taroify-input__placeholder`,
        ]
      },
    ],
    items: ({ data, inputs, output, style }, cate0, cate1, cate2) => {
      cate0.title = "常规";
      cate0.items = [
        {
          title: "提示内容",
          description: "该提示内容会在值为空时显示",
          type: "text",
          value: {
            get({ data }) {
              return data.placeholder;
            },
            set({ data }, value) {
              data.placeholder = value;
            },
          },
          binding: {
            with: `data.placeholder`,
            schema: {
              type: 'string'
            }
          }
        },
        {
          title: "内容类型",
          type: "Select",
          options: [
            { value: "text", label: "文本" },
            { value: "idcard", label: "身份证号" },
            { value: "phone", label: "手机号" },
            { value: "number_decimal", label: "数字(支持小数)" },
          ],
          value: {
            get({ data }) {
              return data.type;
            },
            set({ data }, value) {
              return (data.type = value);
            },
          },
        },
        {
          title: "文本对齐方式",
          description: "文本对齐方式，需要真机预览",
          type: "select",
          options: [
            { label: "左对齐", value: "left" },
            { label: "右对齐", value: "right" },
          ],
          value: {
            get({ data }) {
              return data.inputAlign;
            },
            set({ data }, value) {
              data.inputAlign = value;
            },
          },
        },
        {
          title: "最大长度",
          type: "InputNumber",
          description: "可输入的内容最大长度, -1 为不限制",
          options: [{ min: -1 }],
          value: {
            get({ data }) {
              return [data.maxlength];
            },
            set({ data }, value: number) {
              data.maxlength = value[0];
            },
          },
          binding: {
            with: `data.maxlength`,
            schema: {
              type: 'number'
            }
          }
        },
        {
          title: "显示字数",
          type: "switch",
          description: "是否展示字数",
          value: {
            get({ data }) {
              return data.showCount;
            },
            set({ data }, value: boolean) {
              data.showCount = value;
            },
          },
          binding: {
            with: `data.showCount`,
            schema: {
              type: 'number'
            }
          }
        },
        {
          title: "禁用编辑",
          type: "Switch",
          value: {
            get({ data }) {
              return data.disabled;
            },
            set({ data }, value) {
              data.disabled = value;
            },
          },
          binding: {
            with: `data.disabled`,
            schema: {
              type: 'boolean'
            }
          }
        },
        {
          title: "展示清除图标",
          description: "当输入框有内容时可点击图标清除所有文字",
          type: "Switch",
          value: {
            get({ data }) {
              return data.clearable;
            },
            set({ data }, value) {
              data.clearable = value;
            },
          },
          binding: {
            with: `data.disabled`,
            schema: {
              type: 'boolean'
            }
          }
        },
        {
          title: "事件",
          items: [
            {
              title: "当值变化",
              type: "_event",
              options: {
                outputId: "onChange",
              },
            },
            {
              title:"当得到焦点",
              type:"_event",
              options: {
                outputId: "onFocus"
              }
            },
            {
              title: "当失去焦点",
              type: "_event",
              options: {
                outputId: "onBlur",
              },
            },
            {
              title: "当点击确定",
              type: "_event",
              options: {
                outputId: "onConfirm",
              },
            },
          ],
        },
      ];
      // cate1.title = "高级";
      // cate1.items =[
      // {
      //   title: "升级",
      //   type: "button",
      //   value: {
      //     set({ output }) {
      //       output.add({
      //         id: "onFocus",
      //         title: "当得到焦点",
      //         "schema": {
      //           "type": "string"
      //         }
      //       });
      //     }
      //   }
      // }
      // ]
    },
  },
};
