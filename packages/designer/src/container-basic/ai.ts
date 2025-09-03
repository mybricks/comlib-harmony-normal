export default {
  // ignore: true,
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '基础布局组件，可以用做布局组件和背景样式容器，必须使用',
    usage: `基础布局组件，可以用做布局组件和背景样式容器，必须使用。

slots插槽
content 内容

layout声明
width: 可配置，默认100%
height: 可配置，默认160

<配置流程>
  1. 确认当前布局需要使用什么布局，是flex还是absolute；
  2. 由于宽度、高度都和布局相关，需要根据确认的布局，完成宽高的配置
    2.1 当声明display=absolute时，宽高可遵循下方类型定义配置:
      width: number(固定px) | '100%'
      height: number((固定px))
    2.2 当声明display=flex时，宽高可遵循下方类型定义配置:
      width: number(固定px) | '100%' ｜ 'fit-content'
      height: number(固定px) | 'fit-content'
  3. 根据需求完成其它layout和样式配置；
</配置流程>
`
  }
}