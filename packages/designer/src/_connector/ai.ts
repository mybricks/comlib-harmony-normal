export default {
  ":root"({ data }) {
    return {};
  },
  prompts: {
    summary: "服务接口，发起网络请求的必要组件",
    usage: `
输入端口：
  - call 调用 [默认输入，不需要重复添加]
    
输出端口：
  - then 结果 [默认输出，不需要重复添加]
  - catch 发生错误 [默认疏忽，不需要重复添加]
`,
  },
};
