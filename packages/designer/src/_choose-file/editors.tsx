export default {
  ":root": [
    {
      title: "文件类型",
      description:
        "允许上传的文件类型,无选择则不限制；可自定义输入，标准格式如“.json”",
      type: "select",
      options: {
        mode: "tags",
        multiple: true,
        options: [
          { label: "JPG图片", value: ".jpg,.jpeg" },
          { label: "PNG图片", value: ".png" },
          { label: "SVG图片", value: ".svg" },
          { label: "GIF图片", value: ".gif" },
          { label: "Tiff图片", value: ".tiff" },
          { label: "Word文档", value: ".doc,.docx" },
          { label: "Excel电子表格", value: ".xlsx,.xls,.xlsm" },
          { label: "PowerPoint演示文稿", value: ".pptx,.ppt" },
          { label: "PDF文档", value: ".pdf" },
          { label: "HTML网页文件", value: ".html" },
          { label: "CSS样式表文件", value: ".css" },
          { label: "Less样式表文件", value: ".less" },
          { label: "JS脚本文件", value: ".js" },
          { label: "XML数据文件", value: ".xml" },
          { label: "JSON文件", value: ".json" },
          { label: "Markdown文件", value: ".md" },
          { label: "SQL数据库文件", value: ".sql" },
          { label: "MDB数据库文件", value: ".mdb" },
          { label: "zip压缩文件", value: ".zip" },
          { label: "rar压缩文件", value: ".rar" },
          { label: "Mp3音频文件", value: ".mp3" },
          { label: "Wav音频文件", value: ".wav" },
          { label: "Mp4视频文件", value: ".mp4" },
          { label: "Avi视频文件", value: ".avi" },
          { label: "Mov视频文件", value: ".mov" },
        ],
      },
      value: {
        get({ data }) {
          return data.fileType || [];
        },
        set({ data }, value) {
          data.fileType = value;
        },
      },
    },
    {
      title: "最多可选文件个数",
      description: "最多可以选择的文件个数（支持的范围：1~20）",
      type: "inputnumber",
      options: [{ min: 1, max: 20 }],
      value: {
        get({ data }) {
          return [data.count];
        },
        set({ data }, value) {
          data.count = value[0];
        },
      },
    },
    {
      title: "授权持久化",
      description:
        "临时授权在应用退出后或者设备重启后会清除。如果应用重启或者设备重启后需要直接访问之前已访问过的文件，则对文件进行持久化授权（对于应用已经持久化的授权，应用每次启动时实际未加载到内存中，需要应用按需进行手动激活已持久化授权的权限，否则已经持久化授权的权限仍存在不能使用的情况。）需要受限开放权限：ohos.permission.FILE_ACCESS_PERSIST",
      type: "switch",
      value: {
        get({ data }) {
          return data.persist;
        },
        set({ data }, value) {
          data.persist = value;
        },
      },
    },
    // {
    //   title: "文件来源",
    //   description: "图片和视频选择的来源",
    //   type: "select",
    //   options: {
    //     mode: "tags",
    //     multiple: true,
    //     options: [
    //       { label: "相册", value: "album" },
    //       { label: "拍照", value: "camera" },
    //     ],
    //   },
    //   value: {
    //     get({ data }) {
    //       return data.sourceType;
    //     },
    //     set({ data }, value) {
    //       data.sourceType = value;
    //     },
    //   },
    // },
    // {
    //   title: "是否支持压缩所选文件",
    //   description: "是否压缩所选文件，仅小程序支持",
    //   type: "select",
    //   options: {
    //     mode: "tags",
    //     multiple: true,
    //     options: [
    //       { label: "原始", value: "original" },
    //       { label: "压缩", value: "compressed" },
    //     ],
    //   },
    //   value: {
    //     get({ data }) {
    //       return data.sizeType;
    //     },
    //     set({ data }, value) {
    //       data.sizeType = value;
    //     },
    //   },
    // },
  ],
};
