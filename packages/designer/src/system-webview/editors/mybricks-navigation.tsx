import setSlotLayout from "../../utils/setSlotLayout";

export default {
  ".mybricks-navigation": {
    title: "导航栏",
    items: [
      {
        title: "导航栏样式",
        type: "select",
        options: [
          {
            label: "默认样式",
            value: "default",
          },
          {
            label: "自定义导航栏",
            value: "custom",
          },
          {
            label: "隐藏导航栏",
            value: "none",
          },
        ],
        value: {
          get({ data }) {
            return data.navigationStyle;
          },
          set({ data, slot }, value) {
            data.navigationStyle = value;

            switch (value) {
              case "default":
                data.navigationStyle = "default";
                data.statusBarStyle = null
                try {
                  slot.remove("header");
                } catch (e) {}
                break;
              case "custom":
                data.navigationStyle = "custom";
                data.statusBarStyle = null
                slot.add("header", "导航栏标题区域");
                break;

              case "none":
                data.navigationStyle = "none";
                data.statusBarStyle = {
                  color: '#000000',
                };
                try {
                  slot.remove("header");
                } catch (e) {}
                break;
            }
          },
        },
      },
      {
        ifVisible({ data }) {
          return data.navigationStyle=== "default";
        },
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
      {
        title: '样式',
        type: "styleNew",
        ifVisible({ data }) {
          return data.navigationStyle === "default" || data.navigationStyle === 'custom';
        },
        options: {
          defaultOpen: true,
          plugins: [
            { type: "background", config: { disableBackgroundImage: true, disableGradient: true } },
            { type: "font", config: { disableTextAlign: true, disableLetterSpacing: true, disableLineHeight: true, disableFontSize: true, disableFontWeight: true, disableFontFamily: true } }
          ],
        },
        value: {
          get({ data }) {
            return data.navigationBarStyle ?? {
              color: '#ffffff',
              backgroundColor: '#464646'
            };
          },
          set({ data }, value) {
            data.navigationBarStyle = value;
          },
        },
      },
      // TODO，暂时无需求
      // {
      //   title: '状态栏样式配置',
      //   type: 'switch',
      //   ifVisible({ data }) {
      //     return data.navigationStyle === "default" || data.navigationStyle === 'custom';
      //   },
      //   value: {
      //     get({ data }) {
      //       return !!data.statusBarStyle;
      //     },
      //     set({ data }, value) {
      //       if (value === false) {
      //         data.statusBarStyle = null
      //       } else {
      //         data.statusBarStyle = {
      //           color: '#000000',
      //           backgroundColor: '#ffffff'
      //         };
      //       }
      //     },
      //   },
      // },
      {
        title: '样式', // 此时其实只是状态栏样式
        type: "styleNew",
        ifVisible({ data }) {
          return !!data.statusBarStyle && (data.navigationStyle === "default" || data.navigationStyle === 'custom');
        },
        options: {
          defaultOpen: true,
          plugins: [
            { type: "background", config: { disableBackgroundImage: true, disableGradient: true } },
            { type: "font", config: { disableTextAlign: true, disableLetterSpacing: true, disableLineHeight: true, disableFontSize: true, disableFontWeight: true, disableFontFamily: true } }
          ],
        },
        value: {
          get({ data }) {
            return data.statusBarStyle
          },
          set({ data }, value) {
            data.statusBarStyle = value;
          },
        },
      },
      {
        title: '状态栏',
        type: "styleNew",
        ifVisible({ data }) {
          return !!data.statusBarStyle && data.navigationStyle === "none";
        },
        options: {
          defaultOpen: true,
          plugins: [
            { type: "font", config: { disableTextAlign: true, disableLetterSpacing: true, disableLineHeight: true, disableFontSize: true, disableFontWeight: true, disableFontFamily: true } }
          ],
        },
        value: {
          get({ data }) {
            return data.statusBarStyle
          },
          set({ data }, value) {
            data.statusBarStyle = value;
          },
        },
      },
      {
        title: '返回按钮',
        type: "switch",
        ifVisible({ data }) {
          return data.navigationStyle === "default";
        },
        value: {
          get({ data }) {
            return data.showBackIcon ?? false
          },
          set({ data }, value) {
            data.showBackIcon = value;
          },
        },
      },
    ],
  },
  ".mybricks-header": {
    title: "导航栏标题区域",
    items: [
      {
        title: "列布局",
        type: "layout",
        value: {
          get({ data, slots }) {
            const { layout = {} } = data.customNavigation;
            const slotInstance = slots.get("header");
            setSlotLayout(slotInstance, layout);
            return layout;
          },
          set({ data, slots }, val: any) {
            if (!data.customNavigation.layout) {
              data.customNavigation.layout = {};
            }
            data.customNavigation.layout = {
              ...data.customNavigation.layout,
              ...val,
            };
            const slotInstance = slots.get("header");
            setSlotLayout(slotInstance, val);
          },
        },
      },
    ],
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
  ".mybricks-navTitle": {
    style: [
      {
        title: "样式",
        options: ["size","color"],
        target: ".mybricks-navTitle",
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
};
