export default {
  // ignore: true,
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '基础布局组件，可以用做布局组件和背景样式容器，必须使用',
    usage: `基础布局组件，可以用做布局组件和背景样式容器，必须使用。

slots插槽
content 内容，作为布局时必须声明布局display值

layout声明
width: 可配置，默认100%
height: 可配置，默认160
`
  }
}