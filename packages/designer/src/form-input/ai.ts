export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '单行输入框',
    usage: `data声明
  label: string = "单行输入"
  name: string = "单行输入"
  value: string = ""
  placeholder: string = "请输入内容"

  schema声明
  form-item

  styleAry声明
  输入框: .input
    - 默认样式:
      - border: none
    - 可编辑样式: 
      - 无（非必要不加边框，不然会有割裂感）
  内容文本: .text
    - 默认样式:
      - color: #323233
      - textAlign: left
      - fontSize: 14px
    - 可编辑样式: color、fontSize、textAlign
  提示文本: .placeholder
    - 默认样式: 
      - color: #c0c0c0
    - 可编辑样式: color、fontSize

  layout声明
  width: 可配置
  height: 可配置，默认为fit-content`
  },
  modifyTptJson: (component) => {
    component.style?.styleAry?.forEach?.((style, index) => {
      if (style.selector === ".input") {
        style.selector = [`.mybricks-h5Input .taroify-native-input`, `.mybricks-input`]
      }
      if (style.selector === ".text") {
        style.selector = [`.mybricks-input`, `.mybricks-h5Input .taroify-native-input`]
      }
      if (style.selector === ".placeholder") {
        style.selector = [`.mybricks-input .taroify-input__placeholder`, `.mybricks-h5Input .taroify-native-input::placeholder`]
      }
    })
  }
}