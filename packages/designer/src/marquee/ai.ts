export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '跑马灯',
    usage: `当用户提到跑马灯，走马灯的时候，以及文字横向滚动播放相关需求的时候，必须要使用这个组件。

slots插槽
item # 跑马灯项插槽

layout声明
width: 可配置，默认 'fit-content'
height: 可配置，默认 'fit-content'
`
  }
}