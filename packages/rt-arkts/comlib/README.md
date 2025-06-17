# MyBricks.ai-鸿蒙通用组件库
<div align="center">
    <a href="https://mybricks.world/">
      <img src="https://user-images.githubusercontent.com/77093461/192469708-107ed96d-66d0-4eb2-861a-f97ac384ee15.png" height="300" width="300"/>
    </a>
</div>

## Introduction
为MyBricks.ai鸿蒙相关应用搭建产出源码提供运行时支持，通常无需关心该包的使用方式，安装即可。

## How to Install

```javascript
ohpm install @mybricks/comlib-harmony-normal
```

## Example
```javascript
import { mybricks_harmony_button as BasicMyBricksHarmonyButton,mybricks_harmony_button_Data } from "@mybricks/comlib-harmony-normal"

BasicMyBricksHarmonyButton({
  uid: "uid",
  data: new mybricks_harmony_button_Data({}),
  inputs: {},
  outputs: {},
  styles: {},
  slots: {},
  slotsIO: {},
  parentSlot: {}
})
```
