<div align="center">
    <a href="https://mybricks.world/">
      <img src="https://user-images.githubusercontent.com/77093461/192469708-107ed96d-66d0-4eb2-861a-f97ac384ee15.png" height="160" width="160"/>
    </a>
</div>

<h1>MyBricks-鸿蒙通用组件库</h1>

基于 *Harmony OS NEXT* 版本打造的 *MyBricks-鸿蒙通用组件库*，涵盖 *50+* 常用组件，可直接用于在 [MyBricks平台](https://my.mybricks.world/) 上搭建鸿蒙原生APP。

## ✨ 特性
- 🌈 基于纯血鸿蒙 *Harmony OS NEXT* 版本 打造，兼容鸿蒙 5.0+ 版本
- 📦 开箱即用的 *50+* 高质量原生组件

## 📁 项目结构
鸿蒙组件库的结构主要分为 *designer* 组件设计态代码 和 *rt-arkts* 组件鸿蒙运行时代码 两个目录
```
packages/
├── designer/    # 所有组件的鸿蒙设计态代码
└── rt-arkts/    # 基于ArkTs的完整鸿蒙项目
    ├── comlib/  # 所有组件的鸿蒙运行时代码
    └── entry/   # 鸿蒙项目的入口文件
```