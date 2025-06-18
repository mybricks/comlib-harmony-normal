export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '一个普通的按钮',
    usage: `
  data声明
  text: string = "按钮"

  styleAry声明
  按钮: .mybricks-button
  - 默认样式: borderRadius=60
  - 可编辑样式: backgroundColor、border相关

  美观度注意事项
  - 内容文本默认是水平垂直居中的，可以配置固定高度；
  - 组件默认有左右两边14的内边距，注意按钮宽度；`
  }
}