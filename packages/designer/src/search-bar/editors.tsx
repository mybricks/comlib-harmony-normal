import { IconSelector } from "./../utils/editors/icon-selector";

export default {
  "@init": ({ style, data }) => {
    style.width = 375;
    style.height = 34;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
      {
        title: "搜索框样式",
        options: ["background", "border", "padding", "boxShadow"],
        target: [`.mybricks-searchBar`],
      },
      {
        title: "搜索按钮样式",
        options: [
          "background",
          "border",
          "padding",
          "boxShadow",
          "size",
          "font",
        ],
        target: [`.mybricks-searchButton`],
      },
      {
        title: "内容文本",
        options: ["font"],
        target: [`.mybricks-searchBar-input .taroify-native-input`],
      },
      {
        title: "提示内容文本",
        options: ["font"],
        target: [
          `.mybricks-searchBar-input .taroify-native-input::placeholder`,
        ],
      },
      {
        ifVisible({ data }) {
          return !!data.label;
        },
        title: "左侧文本",
        options: ["background", "border", "padding", "size", "margin", "font"],
        target: [`.mybricks-searchBar-label`],
      },
    ],
    items: ({ data, output, style }, cate0, cate1, cate2) => {
      cate0.title = "搜索框";
      cate0.items = [
        {
          title: "基础属性",
          items: [
            {
              title: "提示文字",
              type: "text",
              value: {
                get({ data }) {
                  return data.placeholderText;
                },
                set({ data }, value: string) {
                  data.placeholderText = value;
                },
              },
              binding: {
                with: `data.placeholderText`,
                schema: {
                  type: "string",
                },
              },
            },
            {
              title: "是否禁用输入框",
              type: "switch",
              value: {
                get({ data }) {
                  return data.disabled;
                },
                set({ data }, value: boolean) {
                  data.disabled = value;
                },
              },
            },
          ],
        },
        {
          title: "高级属性",
          items: [
            {
              title: "搜索框左侧文本",
              type: "text",
              value: {
                get({ data }) {
                  return data.label;
                },
                set({ data }, value: string) {
                  data.label = value;
                },
              },
              binding: {
                with: `data.label`,
                schema: {
                  type: "string",
                },
              },
            },
            {
              title: "展示搜索按钮",
              type: "switch",
              value: {
                get({ data }) {
                  return data.showSearchButton;
                },
                set({ data }, value: boolean) {
                  data.showSearchButton = value;
                },
              },
              binding: {
                with: `data.showSearchButton`,
                schema: {
                  type: "boolean",
                },
              },
            },
            {
              title: "搜索按钮文本",
              type: "text",
              ifVisible({ data }) {
                return data.showSearchButton;
              },
              value: {
                get({ data }) {
                  return data.searchButtonText;
                },
                set({ data }, value: string) {
                  data.searchButtonText = value;
                },
              },
              binding: {
                with: `data.searchButtonText`,
                schema: {
                  type: "string",
                },
              },
            },
            {
              title: "展示搜索图标",
              type: "switch",
              description: "展示搜索输入框前的图标",
              value: {
                get({ data }: EditorResult<Data>) {
                  return data.showSearchIcon;
                },
                set({ data }: EditorResult<Data>, value: boolean) {
                  data.showSearchIcon = value;
                },
              },
            },
            {
              title: "图标",
              type: "editorRender",
              ifVisible({ data }: EditorResult<Data>) {
                return data.showSearchIcon;
              },
              options: {
                render: (props) => {
                  return <IconSelector value={props.editConfig.value} />;
                },
              },
              value: {
                get({ data }) {
                  return data.searchIcon;
                },
                set({ data }, value: string) {
                  data.searchIcon = value;
                },
              },
              binding: {
                with: `data.searchIcon`,
                schema: {
                  type: "string",
                },
              },
            },
            {
              title: "图标颜色",
              type: "colorpicker",
              ifVisible({ data }: EditorResult<Data>) {
                return data.showSearchIcon;
              },
              value: {
                get({ data }) {
                  return data.searchIconColor?.[0];
                },
                set({ data }, value: string) {
                  data.searchIconColor[0] = value;
                },
              },
            },
            {
              title: "图标大小",
              type: "inputnumber",
              options: [{ min: 1 }],
              value: {
                get({ data }) {
                  return [data.searchIconFontSize];
                },
                set({ data }, value: string) {
                  data.searchIconFontSize = value?.[0];
                },
              },
              binding: {
                with: `data.searchIconFontSize`,
                schema: {
                  type: "number",
                },
              },
            },
          ],
        },
        {
          title: "事件",
          items: [
            //
            {
              ifVisible({ data }) {
                return data.disabled;
              },
              title: "单击",
              type: "_event",
              options: {
                outputId: "onClick",
              },
            },

            //
            {
              ifVisible({ data }) {
                return !data.disabled;
              },
              title: "输入框内容变化时",
              type: "_event",
              options: {
                outputId: "onChange",
              },
            },
            {
              ifVisible({ data }) {
                return !data.disabled;
              },
              title: "点击清除按钮时",
              type: "_event",
              options: {
                outputId: "onClear",
              },
            },
            {
              ifVisible({ data }) {
                return !data.disabled;
              },
              title: "当触发搜索时",
              type: "_event",
              options: {
                outputId: "onSearch",
              },
            },
          ],
        },
      ];
    },
  },
  ".mybricks-searchButton": {
    "@dblclick": {
      type: "text",
      value: {
        get({ data }) {
          return data.searchButtonText;
        },
        set({ data }, value) {
          data.searchButtonText = value;
        },
      },
      binding: {
        with: `data.searchButtonText`,
        schema: {
          type: "string",
        },
      },
    },
    style: [
      {
        title: "样式",
        options: [
          "background",
          "border",
          "padding",
          "boxShadow",
          "size",
          "font",
        ],
        target: `.mybricks-searchBar .mybricks-searchButton`,
      },
    ],
    items: (props, cate1, cate2, cate3) => {
      cate1.title = "常规";
      cate1.items = [
        {
          title: "基础属性",
          items: [
            {
              title: "按钮文本",
              type: "text",
              value: {
                get({ data, focusArea }) {
                  return data.searchButtonText;
                },
                set({ data, focusArea, slot, output }, value) {
                  data.searchButtonText = value;
                },
              },
              binding: {
                with: `data.searchButtonText`,
                schema: {
                  type: "string",
                },
              },
            },
          ],
        },
      ];
    },
  },
};
