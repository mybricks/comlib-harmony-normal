export default {
  ":root"({ data }) {
    return {};
  },
  prompts: {
    summary: "服务接口，发起网络请求的必要组件",
    usage: `
输入端口：
  - call 调用
    
输出端口：
  - then 结果
  - catch 发生错误
`,
  },
};
