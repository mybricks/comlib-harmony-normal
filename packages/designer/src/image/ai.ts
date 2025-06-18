export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '图片',
    usage: `data声明
  src: string
  mode: ['scaleToFill', 'aspectFill']

  美观度注意事项
  - 对于图片组件，尽量保证图片的宽高，如果相对父元素，需要保证父元素的宽高
  - 图片也可以配置背景色，在图片没加载出来的时候有兜底效果
  - 一般选择 scaleToFill 模式，拉伸图片到铺满`
  },
}