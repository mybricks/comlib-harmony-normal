import { ButtonType } from "./constant";
import css from "./style.less";

const MAP = {
  getPhoneNumber: {
    title: "手机号快速验证",
    output: [
      {
        id: "getPhoneNumberSuccess",
        title: "获取动态令牌成功",
        schema: {
          type: "object",
          properties: {
            code: {
              type: "string",
            },
            errMsg: {
              type: "string",
            },
          },
        },
      },
      {
        id: "getPhoneNumberFail",
        title: "获取动态令牌失败",
        schema: {
          type: "object",
          properties: {
            errno: {
              type: "number",
            },
            errMsg: {
              type: "string",
            },
          },
        },
      },
    ],
  },
  openSetting: {
    title: "打开设置页面",
    output: [
      {
        id: "openSetting",
        title: "打开设置页面",
        schema: {
          type: "any",
        },
      }
    ]
  },
  getRealtimePhoneNumber: {
    title: "手机号实时验证",
    output: [
      {
        id: "getRealtimePhoneNumberSuccess",
        title: "获取动态令牌成功",
        schema: {
          type: "object",
          properties: {
            code: {
              type: "string",
            },
            errMsg: {
              type: "string",
            },
          },
        },
      },
      {
        id: "getRealtimePhoneNumberFail",
        title: "获取动态令牌失败",
        schema: {
          type: "object",
          properties: {
            errno: {
              type: "number",
            },
            errMsg: {
              type: "string",
            },
          },
        },
      },
    ],
  },
  share: {
    title: "触发用户转发",
    output: [
      {
        id: "share",
        title: "用户转发",
        schema: {
          type: "any",
        },
      },
    ],
  },
  contact: {
    title: "打开客服会话",
    output: [
      {
        id: "onContact",
        title: "客服消息回调",
        schema: {
          type: "any",
        },
      },
    ],
  },
  feedback: {
    title: "打开意见反馈页面",
    output: [],
  },
  chooseAvatar: {
    title: "选择头像成功",
    output: [
      {
        id: "chooseAvatarSuccess",
        title: "选择头像成功",
        schema: {
          type: "string"
        }
      }]
  }
};

function clearOutput(openType, output) {
  switch (true) {
    case openType === "getPhoneNumber":
      output.remove("getRealtimePhoneNumberSuccess");
      output.remove("getRealtimePhoneNumberFail");
      output.remove("share");
      output.remove("onContact");
      output.remove("feedback");
      output.remove("openSetting");
      output.remove("onClick");
      output.remove("chooseAvatarSuccess");
      break;

    case openType === "getRealtimePhoneNumber":
      output.remove("getPhoneNumberSuccess");
      output.remove("getPhoneNumberFail");
      output.remove("share");
      output.remove("onContact");
      output.remove("feedback");
      output.remove("openSetting");
      output.remove("onClick");
      output.remove("chooseAvatarSuccess");
      break;

    case openType === "share":
      output.remove("getPhoneNumberSuccess");
      output.remove("getPhoneNumberFail");
      output.remove("getRealtimePhoneNumberSuccess");
      output.remove("getRealtimePhoneNumberFail");
      output.remove("onContact");
      output.remove("feedback");
      output.remove("openSetting");
      output.remove("onClick");
      output.remove("chooseAvatarSuccess");
      break;

    case openType === "contact":
      output.remove("getPhoneNumberSuccess");
      output.remove("getPhoneNumberFail");
      output.remove("getRealtimePhoneNumberSuccess");
      output.remove("getRealtimePhoneNumberFail");
      output.remove("share");
      output.remove("feedback");
      output.remove("openSetting");
      output.remove("onClick");
      output.remove("chooseAvatarSuccess");
      break;

    case openType === "feedback":
      output.remove("getPhoneNumberSuccess");
      output.remove("getPhoneNumberFail");
      output.remove("getRealtimePhoneNumberSuccess");
      output.remove("getRealtimePhoneNumberFail");
      output.remove("share");
      output.remove("onContact");
      output.remove("openSetting");
      output.remove("onClick");
      output.remove("chooseAvatarSuccess");
      break;

    case openType === "openSetting":
      output.remove("getPhoneNumberSuccess");
      output.remove("getPhoneNumberFail");
      output.remove("getRealtimePhoneNumberSuccess");
      output.remove("getRealtimePhoneNumberFail");
      output.remove("share");
      output.remove("onContact");
      output.remove("feedback");
      output.remove("onClick");
      output.remove("chooseAvatarSuccess");
      break;

    case openType === "chooseAvatar":
      output.remove("getPhoneNumberSuccess");
      output.remove("getPhoneNumberFail");
      output.remove("getRealtimePhoneNumberSuccess");
      output.remove("getRealtimePhoneNumberFail");
      output.remove("share");
      output.remove("onContact");
      output.remove("feedback");
      output.remove("openSetting");
      output.remove("onClick");
      break;

    // onClick
    default:
      output.remove("getPhoneNumberSuccess");
      output.remove("getPhoneNumberFail");
      output.remove("getRealtimePhoneNumberSuccess");
      output.remove("getRealtimePhoneNumberFail");
      output.remove("share");
      output.remove("onContact");
      output.remove("feedback");
      output.remove("openSetting");
      output.remove("chooseAvatarSuccess");
      break;
  }
}

export default {
  "@init"({ style, data, output }) {
    style.width = 120;
    style.height = 42;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    "@dblclick": {
      type: "text",
      value: {
        get({ data }) {
          return data.text;
        },
        set({ data }, val) {
          data.text = val;
        },
      },
    },
    style: [
      {
        items: [
          {
            title: "按钮",
            catelog: "默认",
            options: ["font", "border", "background"],
            target: ".mybricks-button",
            defaultOpen: true,
          },
          {
            title: "按钮",
            catelog: "禁用",
            options: ["font", "border", "background"],
            target: ".mybricks-button-disable",
            defaultOpen: true,
          },
        ],
      },
    ],
    items: [
      {
        title: "按钮文案",
        type: "text",
        value: {
          get({ data }) {
            return data.text;
          },
          set({ data, outputs }, value: string) {
            data.text = value;
          },
        },
        // binding: {
        //   with: 'data.text',
        //   scheme: {
        //     type: 'string'
        //   }
        // }
      },
      // {
      //   title: "前置图标",
      //   type: "switch",
      //   value: {
      //     get({ data }) {
      //       return data.useBeforeIcon;
      //     },
      //     set({ data }, value) {
      //       data.useBeforeIcon = value;
      //     },
      //   },
      // },
      // {
      //   title: "图标地址",
      //   type: "imageSelector",
      //   ifVisible({ data }) {
      //     return data.useBeforeIcon;
      //   },
      //   value: {
      //     get({ data }) {
      //       return data.beforeIconUrl;
      //     },
      //     set({ data }, value) {
      //       data.beforeIconUrl = value;
      //     }
      //   }
      // },
      // {
      //   title: "后置图标",
      //   type: "switch",
      //   value: {
      //     get({ data }) {
      //       return data.useAfterIcon;
      //     },
      //     set({ data }, value) {
      //       data.useAfterIcon = value;
      //     },
      //   },
      // },
      // {
      //   title: "图标地址",
      //   type: "imageSelector",
      //   ifVisible({ data }) {
      //     return data.useAfterIcon;
      //   },
      //   value: {
      //     get({ data }) {
      //       return data.afterIconUrl;
      //     },
      //     set({ data }, value) {
      //       data.afterIconUrl = value;
      //     }
      //   }
      // },
      // {
      //   title: "禁用按钮",
      //   type: "switch",
      //   value: {
      //     get({ data }) {
      //       return data.disabled;
      //     },
      //     set({ data }, value) {
      //       data.disabled = value;
      //     },
      //   },
      // },
      {
        title: "事件",
        items: [
          {
            ifVisible({ data }) {
              return !data.openType;
            },
            title: "单击",
            type: "_event",
            options: {
              outputId: "onClick",
            },
          },
        ],
      },
    ],
  },
  ".mybricks-beforeIcon": {
    style: [
      {
        title: "前置图标",
        options: ["size", "margin"],
        target: ".mybricks-beforeIcon",
      },
    ],
    items: [
      {
        title: "图片",
        type: "imageSelector",
        value: {
          get({ data }) {
            return data.beforeIconUrl;
          },
          set({ data }, value) {
            data.beforeIconUrl = value;
          },
        },
      },
    ],
  },
  ".mybricks-afterIcon": {
    style: [
      {
        title: "后置图标",
        options: ["size", "margin"],
        target: ".mybricks-afterIcon",
      },
    ],
    items: [
      {
        title: "图片",
        type: "imageSelector",
        value: {
          get({ data }) {
            return data.afterIconUrl;
          },
          set({ data }, value) {
            data.afterIconUrl = value;
          },
        },
      },
    ],
  },
};
