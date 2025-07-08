export default {
  ignore: true,
  ':root'({ data }) {
    return {}
  },
  prompts: {
    summary: `自定义表单项，父元素只能是mybricks.harmony.formContainer，内部支持渲染各种子元素，最终与formContainer通信完成表单信息的收集和渲染
何时使用：在当前表单项不能满足用户需求时，用自定义表单项可以渲染各种样式的UI
特别注意：使用此组件必须推荐mybricks.harmony.formContainer组件
`,
    usage: `
  data声明
  无

  slots插槽
  content: 自定义内容

  styleAry声明
  无

  使用案例
  \`\`\`dsl file="page.dsl"
  <mybricks.harmony.formContainer
    title="登录表单"
    data={{
      config: {
        colon: true,
        layout: 'horizontal'
      },
      items: [
        { id: "name", label: "用户名", name: "name"},
        { id: "password", label: "密码", name: "password"}
      ],
    }}
  >
    <slots.content title="表单项内容" layout={{ width: '100%' }}>
      <mybricks.harmony.formInput
        title="用户名"
        layout={{ width: '100%', marginTop: '5px',marginBottom: '5px' }} //当用户提到要给表单项加间距时，或者视觉上需要加点留白空间时，可通过layout中的marginTop,marginBottom进行配置
        data={{
            label:"用户名",
            name:"name",
            placeholder: "请输入用户名",
        }}
      />
      <mybricks.harmony.formPassword
        title="密码"
        layout={{ width: '100%', marginTop: '5px',marginBottom: '5px' }} //当用户提到要给表单项加间距时，或者视觉上需要加点留白空间时，可通过layout中的marginTop,marginBottom进行配置
        data={{
            label:"密码",
            name:"password",
            placeholder: "请输入密码",
        }}
      />
    </slots.content>
  </mybricks.harmony.formContainer>
  \`\`\`
  注意：表单的插槽不允许直接子组件为flex，仅允许schema=form-item的表单项组件。`
  },
  modifyTptJson: (component) => {
 
  }
}