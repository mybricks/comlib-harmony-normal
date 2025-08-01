export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '标签页组件，用于切换标签项，是一个文字+下方选中条的tab形态(在遇到多个高度相似按钮排列在一起,且有一个为高亮态时高优先使用)',
    usage: `data数据模型
new_index: number = 3
tabs: array = [
  {_id: "tabId1", tabName: "标签项1"},
  {_id: "tabId2", tabName: "标签项2"}
]
tabWidthType: ['fill', 'fit'] = 'fill' # 标签项宽度配置，是适应内容还是平均铺满，适应内容时每个标签项宽度由内布局定，平均铺满时每个标签项会平分宽度
contentShowType: string = "switch"
hideContent: boolean = false # 开启后可以只展示tabs，而不渲染插槽内容

slots插槽
tabId1: 标签项1内容
tabId2: 标签项2内容

styleAry声明
标签栏: .taroify-tabs
  - 默认样式: 
    - height: 44px # 仅配置标签栏的高度，不算内容高度
  - 可编辑样式: backgroundColor、border、height相关
标签项（未选中）: .taroify-tabs__tab
  - 默认样式:
    - color: #646566
    - backgroundColor: #ffffff
    - borderRaidus: 0px
    - fontSize: 14px
    - paddingLeft: 12px
    - paddingRight: 12px
  - 可编辑样式: color、backgroundColor、borderRaidus、fontSize、padding相关、margin相关
    - 如果要修改margin，务必要保证和 .taroify-tabs__tab--active 的margin保持一致，不然点击切换的时候会闪动
标签项（已选中）: .taroify-tabs__tab--active
  - 默认样式:
    - color: #323233
    - backgroundColor: #ffffff
    - borderRaidus: 0px
    - fontSize: 14px
    - paddingLeft: 12px
    - paddingRight: 12px
  - 可编辑样式: color、backgroundColor、borderRaidus、fontSize、padding相关、margin相关
      - 如果要修改margin，务必要保证和 .taroify-tabs__tab 的margin保持一致，不然点击切换的时候会闪动
标签项选中条: .taroify-tabs__line
  - 默认样式: 一个位于高亮标签项下方的选中条
    - width = 40px
    - height = 3px
    - backgroundColor: #EE0A24
  - 可编辑样式: width、height、backgroundColor、borderRadius
  - 不可编辑样式: display
  - 重要补充: 如果要隐藏掉高亮标签项下方的选中条，配置颜色为透明即可，不能配置为 display: none;

注意事项:
  - 你是高级产品经理，有非常全面的思考，能精准识别出页面上哪些功能是带有切换逻辑的，最高优先使用tab组件，以实现正常的切换逻辑
    - 比如一些看起来像按钮组（包含多个相似按钮，可能有一个颜色和其他按钮不同），要实现点击后高亮态切换，这种情况下用tab组件是最合理的
    - 比如有些日历、月份选择，点击后切到对应的时间并高亮，这种也是用tab组件最合理的
    - 比如有多段文本并排在一起，其中有一个文本带有下划线，这种需要额外关注，可能会有切换逻辑
    - 如果遇到有些功能是需要tab组件的，但是使用tab组件会导致UI还原度不高，这种情况也优先使用tab组件，以交互功能为优先
    - 目前tab组件暂时不支持红点，所以遇到带红点的tab时，忽略掉红点，直接使用tab组件即可
  - 标签项（未选中） .taroify-tabs__tab 和 标签项（已选中）.taroify-tabs__tab--active 的borderRadius、padding必须保持高度一致，不然在切换时会有视觉上的不和谐

使用案例
\`\`\`dsl file="page.dsl"
<mybricks.harmony.tabs
  title="tab"
  layout={{ width: '100%', height: 'fit-content' }}
  data={{ 
    tabs: [{ _id: "tabId1", tabName: "全部" },{ _id: "tabId2", tabName: "待付款" }],
    tabWidthType: 'fit',
    contentShowType: "switch"
  }}
> // 注意: 插槽的数量要和tabs的数量保持一致
  <slots.tabId1 title="tab项" layout={{ width: '100%' }}>
  </slots.tabId1>
  <slots.tabId2 title="tab项" layout={{ width: '100%' }}>
  </slots.tabId2>
</mybricks.harmony.tabs>
\`\`\``
  },
  modifyTptJson: (component) => {
    let configHeight

    component.style?.styleAry?.forEach?.((style, index) => {
      if (style.selector === ".taroify-tabs") {
        style.selector = ".taroify-tabs__wrap .taroify-tabs__wrap__scroll"
        if (style?.css?.height) {
          configHeight = style?.css?.height
        }
      }
      if (style.selector === ".taroify-tabs__tab") {
        style.selector = `.taroify-tabs__tab:not(.taroify-tabs__tab--active):not(#{id} *[data-isslot="1"] *)`
      }
      if (style.selector === ".taroify-tabs__tab--active") {
        style.selector = `.taroify-tabs__tab--active:not(#{id} *[data-isslot="1"] *)`
      }
      if (style.selector === ".taroify-tabs__line") {
        style.selector = `.taroify-tabs__line:not(#{id} *[data-isslot="1"] *)`
      }
    })

    if (configHeight) {
      component.style.styleAry.push({
        selector: '.taroify-tabs__wrap',
        css: {
          height: configHeight
        }
      })
    }
   
  }


}