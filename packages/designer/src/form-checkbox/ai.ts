export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: 'checkbox组件，带文本和勾选效果',
    usage: `
  data声明
  label: string = "多选"
  name: string = "多选"
  direction: ['horizontal', 'vertical'] = 'vertical'
  value: Array = []
  options: Array<{
    label: string,
    value: string,
    icon: string 
  }>

  schema声明
  form-item

  slots插槽
  无

  layout声明
  width: 可配置
  height: 不可配置，默认为fit-content

  注意事项
  - 在列表中，插槽仅放置一个组件即可，因为列表会遍历这个组件，不要开发多个，仅需开发一个示例即可；`
  }
}