export default {
  ":root": [
    {
      title: "说明",
      type: "editorRender",
      options: {
        render: (props) => {
          return (
            <div style={{ opacity: 0.7 }}>
              输入格式为任意对象，
              <br />如 <strong>{"{key1: value1, key2: value2}"}</strong>，
              <br />其中对象的键将会被作为用户首选项的 key，其对应的值将会作为用户首选项的值。
              <br />更多规则可
              <a
                href="https://developers.weixin.qq.com/miniprogram/dev/api/storage/wx.setStorageSync.html"
                target="_blank"
                rel="noopener noreferrer"
              >
                参考链接
              </a>
            </div>
          );
        },
      },
    },
  ],
};
