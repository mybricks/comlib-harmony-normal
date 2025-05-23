export default {
  ":root": [
    {
      title: "跳转方式",
      type: "Select",
      options: [
        // { value: "navigateTo", label: "新页面" },
        { value: "redirectTo", label: "重定向" },
        { value: "back", label: "返回" },
        { value: "backTo", label: "返回到打开过的某个页面" },
      ],
      value: {
        get({ data }) {
          return data.action;
        },
        set({ data }, value) {
          data.action = value;
        },
      },
    },
    {
      title: "使用动态传入",
      type: "switch",
      value: {
        get({ data }) {
          return data.dynamicInput;
        },
        set({ data }, value) {
          data.dynamicInput = value;
        },
      },
    },
    {
      title: "页面",
      type: "text",
      ifVisible({ data }: EditorResult<Data>) {
        return data.action === 'backTo' || data.action === 'redirectTo';
      },
      value: {
        get({ data }) {
          return data.url;
        },
        set({ data, outputs }, value: string) {
          data.url = value;
        },
      },
    },
  ],
};
