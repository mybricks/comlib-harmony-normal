import MybricksNavigationEditor from "./editor/mybricks-navigation";
import MybricksTabBarEditor from "./editor/mybricks-tabbar";
import css from "./editors.less";
import { defaultSelectedIconPath, defaultNormalIconPath } from "./const";
import setSlotLayout from "../utils/set-slot-layout";

const Input = window.antd?.Input;
const message = window.antd?.message;

function rgbaToHex(rgba) {
  const result = rgba.match(
    /rgba?\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3}),?\s*(\d*\.?\d+)?\)/
  );

  if (!result) {
    return null;
  }

  const r = parseInt(result[1], 10);
  const g = parseInt(result[2], 10);
  const b = parseInt(result[3], 10);

  const toHex = (c) => ("0" + c.toString(16)).slice(-2);

  return "#" + toHex(r) + toHex(g) + toHex(b);
}
const positionTransform = (position) => {
  switch (position) {
    case "center top":
      return "top";
      break;
    case "center center":
      return "center";
      break;
    case "center bottom":
      return "bottom";
      break;
    case "left center":
      return "left";
      break;
    case "right center":
      return "right";
      break;
    case "left top":
      return "top left";
      break;
    case "left bottom":
      return "bottom left";
      break;
    case "right top":
      return "top right";
      break;
    case "right bottom":
      return "bottom right";
      break;
    default:
      return "top";
      break;
  }
};

const getDefaultTabItem = (id) => {
  return {
    scene: {
      id,
    },
    text: "标签项",
    selectedIconPath: defaultSelectedIconPath,
    selectedIconStyle: {
      width: "22px",
      height: "22px",
    },
    selectedTextStyle: {
      fontSize: 12,
      color: "#FD6A00",
    },
    normalIconPath: defaultNormalIconPath,
    normalIconStyle: {
      width: "22px",
      height: "22px",
    },
    normalTextStyle: {
      fontSize: 12,
      color: "#909093",
    },
  };
};

export default {
  "@init": ({ style, data, env }) => {
    style.width = "100%";
    style.height = '100%'
    data.id = env.canvas.id;

    setTimeout(() => {
      if (!data.useTabBar) return;

      // 如果模式为标签页，且当前页面不在标签页中，则添加到标签页中
      let globalTabBar = window.__tabbar__?.get() ?? [];
      if (!globalTabBar.find((item) => item.scene.id === data.id)) {
        globalTabBar.push(getDefaultTabItem(data.id));
      }

      window.__tabbar__?.set(JSON.parse(JSON.stringify(globalTabBar)));
    }, 0);
  },

  "@delete": ({ data, env }) => {
    console.warn("@delete", data.id);

    let globalTabBar = window.__tabbar__?.get() ?? [];
    globalTabBar = globalTabBar.filter((item) => {
      return item.scene.id != data.id;
    });

    window.__tabbar__?.set(JSON.parse(JSON.stringify(globalTabBar)));
  },
  ":slot": {},
  "@resize": {
    options: ["height"],
  },

  ":root": {
    style: [],
    items: ({ env, data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "页面";
      cate0.items = [
        {
          type: "_homepage",
        },
          MybricksTabBarEditor[".mybricks-tabBar"].items[0],
        {
          title: "顶部栏",
          items: MybricksNavigationEditor[".mybricks-navigation"].items,
        },
        {
          title: "内容区",
          items: [
            {
              title: "布局",
              type: "layout",
              value: {
                get({ data, slots }) {
                  return data.layout;
                },
                set({ data, slots }, value) {
                  data.layout = value;
                  setSlotLayout( slots.get("content"), value);
                },
              },
            },
            {
              title: "背景",
              type: "styleNew",
              options: {
                defaultOpen: true,
                plugins: [
                  { type: "background" }
                ],
              },
              value: {
                get({ data }) {
                  return {
                    backgroundColor: data.backgroundColor,
                    backgroundImage: data.backgroundImage,
                    backgroundPosition: data.backgroundPosition || "center top",
                    backgroundSize: data.backgroundSize,
                    backgroundRepeat: data.backgroundRepeat || "repeat",
                  };
                },
                set({ data }, value) {
                  data.backgroundImage =
                    value?.backgroundImage !== undefined
                      ? value.backgroundImage
                      : data.backgroundImage;
                  let backgroundPosition =
                    value?.backgroundPosition !== undefined
                      ? value.backgroundPosition
                      : data.backgroundPosition;
                  data.backgroundPosition =
                    positionTransform(backgroundPosition);
                  data.backgroundSize =
                    value?.backgroundSize !== undefined
                      ? value.backgroundSize
                      : data.backgroundSize;
                  data.backgroundRepeat =
                    value?.backgroundRepeat !== undefined
                      ? value.backgroundRepeat
                      : data.backgroundRepeat;
                  data.backgroundColor =
                    value?.backgroundColor !== undefined
                      ? value.backgroundColor
                      : data.backgroundColor;
                },
              },
            },
            {
              title: "底部留白",
              type: "text",
              options: {
                type: "number",
                min: 0,
              },
              value: {
                get({ data }) {
                  return data.bottomSpace || 0;
                },
                set({ data }, value) {
                  data.bottomSpace = value;
                },
              },
            },
            // {
            //   title: "禁用页面滚动",
            //   type: "switch",
            //   value: {
            //     get({ data }) {
            //       return data.disableScroll;
            //     },
            //     set({ data }, value) {
            //       data.disableScroll = value;
            //     },
            //   },
            // },
          ],
        },
      ];

      cate1.title = "事件";
      cate1.items = [
        {
          title: "当页面滚动时",
          description:
            "页面级滚动事件",
          type: "_event",
          options: {
            outputId: "onScroll",
          },
        },
        {
          title: "当页面重新显示时",
          description:
            "请注意，当页面第一次显示时，不会触发该事件。仅当页面被打开后，重新显示/切入前台时触发。",
          type: "_event",
          options: {
            outputId: "pageDidShow",
          },
        },
        {
          title: "当页面隐藏时",
          type: "_event",
          options: {
            outputId: "pageDidHide",
          },
        },
        // {
        //   title: "分享",
        //   type: "switch",
        //   value: {
        //     get({ data }) {
        //       return data.enabledShareMessage ?? false;
        //     },
        //     set({ data }, value) {
        //       data.enabledShareMessage = value;
        //     },
        //   },
        // },
        {
          title: "下拉刷新",
          type: "switch",
          value: {
            get({ data }) {
              return data.enabledPulldown;
            },
            set({ data, slots }, value) {
              data.enabledPulldown = value;
            },
          },
        },
        {
          title: "当下拉刷新触发时",
          ifVisible({ data }) {
            return data.enabledPulldown;
          },
          type: "_event",
          options: {
            outputId: "pulldown",
          },
        },
        // {
        //   title: "开启页面 Loading",
        //   type: "switch",
        //   value: {
        //     get({ data }) {
        //       return data.useLoading;
        //     },
        //     set({ data, input }, value) {
        //       data.useLoading = value;

        //       if (value) {
        //         input.add("ready", "初始化完成", { type: "any" });
        //       } else {
        //         input.remove("ready");
        //       }
        //     },
        //   },
        // },
      ];

      // cate2.title = "高级";
      // cate2.items = [
      //   {
      //     title: '升级',
      //     type: 'button',
      //     value: {
      //       set({ output }) {
      //         output.add({
      //           id: 'onScroll',
      //           title: '当页面滚动时',
      //           schema: {
      //             type: 'object'
      //           }
      //         })
      //       }
      //     }
      //   }
      // ]
    },
  },
  ".mybricks-backIcon": {
    style: [
      {
        title: "样式",
        options: ["size"],
        target: ".mybricks-backIcon",
      },
    ],
    items: [
      {
        title: "自定义图标",
        type: "imageselector",
        options: {
          fileSizeLimit: 10,
          useBase64Only: true,
        },
        value: {
          get({ data }) {
            return data.customBackIcon;
          },
          set({ data }, value) {
            data.customBackIcon = value;
          },
        },
      },
    ],
  },

  ...MybricksTabBarEditor,

  ".mybricks-footer": {
    style: [
      {
        title: "页脚容器",
        options: ["background"],
        target: `.mybricks-footer`,
      },
    ],
  },
  ".mybricks-navigation-title": {
    "@dblclick": {
      type: "text",
      value: {
        get(props) {
          const { data, focusArea } = props;
          return data.navigationBarTitleText
        },
        set(props, value) {
          const { data, focusArea } = props;
          data.navigationBarTitleText = value
        },
      },
    }
  },
  ".mybricks-tabbar-text": {
    "@dblclick": {
      type: "text",
      value: {
        get(props) {
          const { data, focusArea } = props;
          let innerText = focusArea.ele.innerText;
          return innerText
        },
        set(props, value) {
          const { data, focusArea } = props;

          let tabBar = JSON.parse(JSON.stringify(data.tabBar));
          tabBar[focusArea.index].text = value;
          data.tabBar = tabBar;
          window.__tabbar__?.set(tabBar);
        },
      },
    }
  }
};
