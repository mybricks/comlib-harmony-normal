export default {
  ":root": [
    {
      title: "分享场景",
      description: "支持文本、图片、视频、链接等",
      type: "select",
      options: [
        { label: "分享链接", value: "HYPERLINK" },
        { label: "分享图片", value: "IMAGE" },
        { label: "分享视频", value: "VIDEO" },
        { label: "分享文本", value: "TEXT" },
        { label: "分享其他文件", value: "OTHER" },
      ],
      value: {
        get({ data }) {
          return data.type || "OTHER";
        },
        set({ data }, value) {
          data.type = value;
        },
      },
    },
  ],
};
