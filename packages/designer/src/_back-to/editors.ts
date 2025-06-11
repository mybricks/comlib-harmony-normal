export default {
  ":root": [
    {
      title: "方式",
      type: "Select",
      options: [
        { value: "back", label: "返回" },
        { value: "backToPage", label: "返回到打开过的某个页面" },
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
      title: "返回的页面数",
      description: "如果 delta 大于现有页面数，则返回到首页",
      type: 'text',
      options: {
        type: 'number'
      },
      ifVisible({ data }: EditorResult<Data>) {
        return data.action === 'back';
      },
      value: {
        get({ data }) {
          return data.delta;
        },
        set({ data }, value) {
          data.delta = value;
        },
      },
    },
    {
      title: "返回的页面ID",
      type: "text",
      ifVisible({ data }: EditorResult<Data>) {
        return data.action === 'backToPage';
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
