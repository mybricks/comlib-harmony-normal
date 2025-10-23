import setSlotLayout from "../../utils/set-slot-layout";

export default {
  ".mybricks-navigation": {
    title: "导航栏",
    items: [
      {
        ifVisible({ data }) {
          return data.navigationStyle === "default";
        },
        title: "标题",
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
        title: "导航栏类型",
        type: "select",
        options: [
          {
            label: "默认",
            value: "default",
          },
          {
            label: "自定义",
            value: "custom",
          },
          {
            label: "隐藏",
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
                } catch (e) { }
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
                } catch (e) { }
                break;
            }
          },
        },
      },
      {
        title: '显示返回按钮',
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
        options: ["size", "color"],
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
