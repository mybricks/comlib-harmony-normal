export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '搜索框组件，搜索框内含有搜索图标的组件',
    usage: `data声明
placeholderText: string = "请输入关键词"
label?: string # 搜索框左侧文本，无则不展示
showSearchButton: boolean = true # 搜索框右侧圆角按钮，false则不展示

styleAry声明
输入框: .searchBar
  - 默认样式:
    - border: none
    - paddingLeft: 12px
    - paddingRight: 12px
  - 可编辑样式: 
    - background
    - border（非必要不加边框，不然会有割裂感）
输入框文本: .text
  - 默认样式:
    - color: #323233
    - textAlign: left
    - fontSize: 14px
  - 可编辑样式:
    - color、fontSize、textAlign
提示内容文本: .placeholder
  - 默认样式:
    - color: #c0c0c0
  - 可编辑样式:
    - color
搜索按钮: .button
  - 默认样式:
    - color: #ffffff
    - background: #fa6400
    - width: 80px
    - height: 33px
    - margin-right: 8px
    - border-radius: 60px
  - 可编辑样式:
    - color、background、width、height、marginRight、borderRadius`
  },
  modifyTptJson: (component) => {
    component?.style?.styleAry?.forEach((style, index) => {
      if (style.selector == ".searchBar") {
        style.selector = ".mybricks-searchBar"
      }
      if (style.selector == ".text") {
        style.selector = ".mybricks-searchBar .mybricks-searchBar-input .taroify-input"
      }
      if (style.selector == ".placeholder") {
        style.selector = ".mybricks-searchBar .mybricks-searchBar-input .taroify-input__placeholder"
      }
      if (style.selector == ".button") {
        style.selector = ".mybricks-searchButton"
      }
    })
  }
}