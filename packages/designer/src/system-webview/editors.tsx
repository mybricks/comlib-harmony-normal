import MybricksNavigationEditor from "./editors/mybricks-navigation";

export default {
  ":root"({ data, output, style }, cate0, cate1, cate2) {
    cate0.title = "常规";
    cate0.items = [
      {
        title: "顶部导航栏",
        items: MybricksNavigationEditor[".mybricks-navigation"].items,
      },
      {
        title: "",
        items: [
          {
            title: "网页链接",
            type: "text",
            description:
              "可打开关联的公众号的文章，其它网页需登录小程序管理后台配置业务域名。",
            value: {
              get({ data }) {
                return data.url;
              },
              set({ data }, value: string) {
                data.url = value;
              },
            },
          },
        ],
      },
      {
        title: "事件",
        items: [
          {
            title: "网页加载成功时",
            type: "_event",
            options: {
              outputId: "onLoad",
            },
          },
          {
            title: "网页加载失败时",
            type: "_event",
            options: {
              outputId: "onError",
            },
          },
          {
            title: "网页向小程序 postMessage 时",
            type: "_event",
            options: {
              outputId: "onMessage",
            },
          },
        ],
      },
    ];
  },
};
