
export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '多行输入textarea',
    usage: `data声明
label: string = "多行输入"
name: string = "多行输入"
value: string = "" # 输入框值
placeholder: string = "请输入内容" # 占位提示文本
limit: number = 100 # 字数限制，当=0时，代表不限制，也不会出现有下角的字数统计信息

schema声明
form-item

styleAry声明
输入框: .textarea
  - 默认样式:
    - border: none
    - padding: 0px
  - 可编辑样式: 
    - border、padding、background
内容文本: .text
  - 默认样式:
    - color: #323233
    - fontSize: 14px
  - 可编辑样式: color、fontSize
提示文本: .placeholder
  - 默认样式: 
    - color: #c0c0c0
  - 可编辑样式: color、fontSize

layout声明
width: 可配置
height: 不可配置，默认为fit-content`
  },
  modifyTptJson: (component) => {
    component.style?.styleAry?.forEach?.((style, index) => {
      if (style.selector === ".textarea") {
        style.selector = ".taroify-textarea__wrapper"
        if (style.css) {
          style.css.height = '100%';
        }
      }
      if (style.selector === ".text") {
        style.selector = [".taroify-textarea__wrapper .mybricks-textarea", ".taroify-textarea__wrapper .mybricks-h5Textarea .taroify-native-textarea"]
      }
      if (style.selector === ".placeholder") {
        style.selector = [".taroify-textarea__wrapper .taroify-textarea__placeholder", ".taroify-textarea__wrapper .mybricks-h5Textarea .taroify-native-textarea::placeholder"]
      }
    })

    if (component.data?.limit !== undefined) {
      component.data.limit = component.data?.limit
    }

    if (!component.style) {
      component.style = {}
    }
    if (!component.style?.styleAry) {
      component.style.styleAry = []
    }
    if (!component.style.styleAry.find(t => t.selector !== '.taroify-textarea__wrapper')) {
      component.style.styleAry.push({
        selector: ".taroify-textarea__wrapper",
        css: {
          height: '100%'
        }
      })
    }

  }
}