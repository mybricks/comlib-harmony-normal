export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '移动端侧边栏组件（当遇到以下需求时需要使用: ①左边可以切换的标签栏 ②左边有多个按钮，点击按钮可以进行切换）',
    usage: `data声明
  tabs: array = [
    {_id: "tabName1", tabName: "标签项1"},
    {_id: "tabName2", tabName: "标签项2"}
  ]
  tabNameKey: string = "tabName"

  slots插槽
  tabName1: 标签项1
  tabName2: 标签项2

  styleAry声明
  侧边栏底色: .taroify-tree-select__sidebar
  选中条: .taroify-sidebar-tab--active:before
  标签项:
  - 默认样式: .taroify-sidebar-tab:not(.taroify-sidebar-tab--active)
  - 选中样式: .taroify-sidebar-tab--active

  使用案例
  \`\`\`dsl file="page.dsl"
  <mybricks.harmony.sidebar
    title="tab"
    layout={{ width: '100%', height: 'fit-content' }}
    data={{ 
      tabs: [{ _id: "tabId1", tabName: "全部" }, { _id: "tabId2", tabName: "待付款" }],
      tabNameKey: 'tabName'
    }}
    > // 注意: 插槽的数量要和tabs的数量保持一致
      <slots.content title="标签项1" layout={{ width: '100%' }}>
      </slots.content>
      <slots.content title="标签项2" layout={{ width: '100%' }}>
      </slots.content>
  </mybricks.harmony.sidebar>

  注意：
  - 侧边栏不要去配置width宽度，默认铺满页面宽度即可
  - 侧边栏高度默认铺满整个页面`
  },
}