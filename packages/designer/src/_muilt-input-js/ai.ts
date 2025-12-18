export default {
  ":root"({ data }) {
    return {};
  },
  prompts: {
    summary: "JS计算，一个可嵌入事件流程中的JavaScript脚本组件，允许自定义JavaScript代码来处理和转换输入数据，灵活实现业务逻辑，控制流程分支",
    usage: `JS计算支持动态添加多个输入和输出端口，可实现复杂的数据整合，控制流程分支等功能。

输入端口：
  - input.inputValue0 参数0 - [默认输入，不需要重复添加]
  - input.inputValue[index] 参数[index] - 支持动态添加多个输入端口，每个端口可接收不同类型的数据。index对应的是输入端口的顺序，从0开始，依次递增
    例如：input.inputValue0（参数0），input.inputValue1（参数1）, ...
  注意：
    - 该组件输入为多输入模式，即当所有的输入端口均有数据输入时，组件才会触发运行。
    - 输入id一定是以\`input.inputValue\`开头，后面跟数字索引。

输出端口：
  - output0 输出项0 - [默认输出，不需要重复添加]
  - output[index] 输出项[index] - 支持动态添加多个输出端口，每个端口可输出不同类型的数据。index对应的是输出端口的顺序，从0开始，依次递增
    例如：output0（输出项0），output1（输出项1），...
`,
  },
};  
