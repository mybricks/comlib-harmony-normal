import { IconSelector } from "./../utils/editors/icon-selector";

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
            options: ["font", "border", "background", "boxshadow", "padding"],
            target: ".mybricks-button",
            defaultOpen: true,
          },
          {
            title: "按钮",
            catelog: "禁用",
            options: ["font", "border", "background", "boxshadow", "padding"],
            target: ".mybricks-button-disable",
            defaultOpen: true,
          },
        ],
      },
      {
        ifVisible({ data }) {
          return data.showIcon && data.useImageIcon;
        },
        title: "自定义图标",
        options: ["size", "border", "margin", "background"],
        target: ".mybricks-button-image-icon",
      },
    ],
    items: [
      {
        title: "基础属性",
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
            binding: {
              with: "data.text",
              schema: {
                type: "string",
              },
            },
          },
        ],
      },
      {
        title: "高级属性",
        items: [
          {
            title: "展示图标",
            type: "switch",
            value: {
              get({ data }) {
                return data.showIcon;
              },
              set({ data, outputs }, value: boolean) {
                data.showIcon = value;
              },
            },
          },
          {
            ifVisible({ data }) {
              return data.showIcon;
            },
            title: "图标配置",
            items: [
              {
                title: "自定义",
                type: "switch",
                description: "开启后可上传自定义图标",
                value: {
                  get({ data }) {
                    return data.useImageIcon;
                  },
                  set({ data, outputs }, value: boolean) {
                    data.useImageIcon = value;
                  },
                },
              },
              {
                ifVisible({ data }) {
                  return data.useImageIcon;
                },
                title: "图标",
                type: "imageSelector",
                value: {
                  get({ data }) {
                    return data.imageIcon;
                  },
                  set({ data }, value) {
                    data.imageIcon = value;
                  },
                },
              },
              {
                ifVisible({ data }) {
                  return !data.useImageIcon;
                },
                title: "图标",
                type: "editorRender",
                options: {
                  render: (props) => {
                    return <IconSelector value={props.editConfig.value} />;
                  },
                },
                value: {
                  get({ data }) {
                    return data.icon;
                  },
                  set({ data }, value: string) {
                    data.icon = value;
                  },
                },
              },
              {
                ifVisible({ data }) {
                  return !data.useImageIcon;
                },
                title: "图标大小",
                type: "inputnumber",
                options: [{ min: 1 }],
                value: {
                  get({ data }) {
                    return [data.iconSize];
                  },
                  set({ data }, value: string) {
                    if (Array.isArray(value)) {
                      data.iconSize = value?.[0];
                    } else {
                      data.iconSize = value;
                    }
                  },
                },
              },
              {
                ifVisible({ data }) {
                  return !data.useImageIcon;
                },
                title: "图标颜色",
                type: "colorpicker",
                value: {
                  get({ data }) {
                    return data.iconColor?.[0];
                  },
                  set({ data }, value: string) {
                    data.iconColor[0] = value;
                  },
                },
              },
              {
                title: "展示位置",
                type: "select",
                options: [
                  {
                    label: "位于文字前",
                    value: "left",
                  },
                  {
                    label: "位于文字后",
                    value: "right",
                  },
                ],
                value: {
                  get({ data }) {
                    return data.iconPosition;
                  },
                  set({ data, outputs }, value: string) {
                    data.iconPosition = value;
                  },
                },
              },
              {
                ifVisible({ data }) {
                  return !data.useImageIcon;
                },
                title: "图标与文字间距",
                type: "inputnumber",
                options: [{ min: 0 }],
                value: {
                  get({ data }) {
                    return [data.iconMargin];
                  },
                  set({ data }, value: string) {
                    if (Array.isArray(value)) {
                      data.iconMargin = value?.[0];
                    } else {
                      data.iconMargin = value;
                    }
                  },
                },
              },
            ],
          },
        ],
      },

      {
        title: "事件",
        items: [
          {
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
};
