export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: 'checkbox组件，带文本和勾选效果',
    usage: `data声明
config: {
options: [
  {
    label: string
    value: string
    type: string
    checked: boolean
    key: string
  }
]
disabled: boolean
}
staticOptions: array
checkAll: boolean
layout: ['horizontal', 'vertical']
checkAllText: string
isEditable: boolean 
isIndeterminate: boolean
eventBubble: boolean

schema声明
form-item

styleAry声明
选择框: .ant-checkbox-inner
全选框: .checkbox > .ant-checkbox-wrapper
选项: .ant-checkbox-group .ant-checkbox-group-item
选项标签: label.ant-checkbox-wrapper > span:nth-child(2)
选择框勾选符号: .ant-checkbox-checked .ant-checkbox-inner:after`
  }
}