
export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '数字输入，左侧减图标，中间输入，右侧加图标的数字输入框',
    usage: `data声明
label: string = "数字输入"
name: string = "数字输入"
value: number = 0
step: number = 1

schema声明
form-item

styleAry声明
增加按钮: .taroify-stepper__increase
  - 默认样式：
    - color: #ffffff
    - border-radius: 100%
    - border-color: #fa6400
    - background: #fa6400
  - 可编辑样式: color、border、background、borderRadius
减少按钮: .taroify-stepper__decrease
  - 默认样式：
    - color: #fa6400
    - border-radius: 100%
    - border-color: #fa6400
    - background: #ffffff
  - 可编辑样式: color、border、background、borderRadius
中间的数字文本: .taroify-stepper__input
  - 默认样式：
    - color: #000
  - 可编辑样式: color

layout声明
width: 可配置
height: 不可配置，默认为fit-content`
  },
  modifyTptJson: (component) => {
    
  }
}