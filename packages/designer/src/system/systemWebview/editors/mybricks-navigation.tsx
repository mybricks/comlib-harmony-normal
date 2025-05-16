export default {
  ".mybricks-navigation": {
    title: "导航栏",
    items: [
      {
        title: "导航栏背景颜色",
        type: "colorpicker",
        value: {
          get({ data }) {
            return data.navigationBarBackgroundColor;
          },
          set({ data }, value) {
            data.navigationBarBackgroundColor = value;
          },
        },
      },
      {
        title: "导航栏标题颜色",
        type: "radio",
        options: [
          {
            label: "黑色",
            value: "black",
          },
          {
            label: "白色",
            value: "white",
          },
        ],
        value: {
          get({ data }) {
            return data.navigationBarTextStyle;
          },
          set({ data }, value) {
            data.navigationBarTextStyle = value;
          },
        },
      },
      {
        title: "导航栏标题文字内容",
        type: "text",
        value: {
          get({ data }) {
            return data.navigationBarTitleText;
          },
          set({ data }, value) {
            data.navigationBarTitleText = value;
          },
        },
      },
    ],
  },
};
