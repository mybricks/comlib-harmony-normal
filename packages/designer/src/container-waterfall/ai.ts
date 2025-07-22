export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '瀑布流列表组件，支持一行N列卡片不等高的瀑布流',
    usage: `瀑布流列表组件，支持一行N列卡片不等高的瀑布流
  data声明
  layout: {
    type: 'grid'
    column: number = 2
    gutter: [number, number] = [8, 8] # 间距[水平,垂直]
    minHeight: number = 400
  }
  rowKey: string = "id"

  slots插槽
  item # 列表项插槽

  注意事项
  - 在列表中，插槽仅放置一个组件即可，因为列表会遍历这个组件，不要开发多个，仅需开发一个示例即可；
  
  高度计算
  因为无论几列，瀑布流会自动循环三行，所以
    瀑布流的高度 = 插槽内容的高度*3列 + 行间距*2。
  `
  }
}