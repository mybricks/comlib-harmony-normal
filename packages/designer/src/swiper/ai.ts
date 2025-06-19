export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '轮播，支持图片轮播，内容轮播',
    usage: `data声明
items: [
  {
    _id: string
    thumbnail: string
  }
]

styleAry声明
轮播容器: .mybricks-swiper-wrapper

注意：对于轮播组件必须给定高度。`
  }
}