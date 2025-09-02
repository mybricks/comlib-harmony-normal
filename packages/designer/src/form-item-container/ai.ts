export default {
  ':root'({ data }) {
    return {}
  },
  prompts: {
    summary: `自定义表单项，父元素只能是mybricks.harmony.formContainer的插槽，内部支持渲染任意子元素，最终与formContainer通信完成表单信息的收集和渲染
何时使用：在当前表单项不能满足用户需求时，用自定义表单项可以渲染各种样式的UI。`,
    usage: `自定义表单项，父元素只能是mybricks.harmony.formContainer的插槽，内部支持渲染任意子元素，最终与formContainer通信完成表单信息的收集和渲染
何时使用：在当前表单项不能满足用户需求时，用自定义表单项可以渲染各种样式的UI。

  schema=mybricks.taro.formContainer/formItem

  slots插槽
  formItem: 内容`
  },
  modifyTptJson: (component) => {
 
  }
}