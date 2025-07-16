export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: `容器,里面可以放置组件`,
    usage: `
  data声明
  overflowVisible: boolean = false

  styleAry声明
  图标: > .mybricks-container 
  - 默认样式: 无
  - 可配置样式: padding、backgroundColor、border、margin

  如果需要实现元素超出容器后,依然还能显示,需要配置 overflowVisible = true
  
`
  },
  modifyTptJson: (component) => {
  }
}