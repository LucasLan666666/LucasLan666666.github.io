# Mermaid 踩坑日记

## 缘起

2023 年 12 月开始使用 Typora 写 `Markdown` 笔记，刚了解到部分 `Markdown` 编辑器支持一个叫做 `Mermaid` 的图表工具，能够绘制流程图、状态图等，十分方便。因为碰巧在写数电实验报告，想到可以用 `Mermaid` 画流程图，于是开始了尝试。

## 踩坑

发生了一件非常神奇的事情，我写的代码可以在 `Typora` ，`VS Code` 的 `Markdown` 插件，以及 `Mermaid` [官网](https://mermaid.js.org/) 的在线编辑器中成功渲染，唯独不能再 `Github` 上正常显示。最气人的是他不给出任何报错信息，害我捣鼓了半天：

![mermaid1](assets/mermaid1.png)

## 真相

最终通过对 `Markdown` 文件中 `Mermaid` 块的内容一行一行排查，终于找到了原因。我们先查看下面代码：

```mermaid
flowchart LR
A(开始) --> B{判断是否到达时钟信号上升沿<br/>或置位信号下降沿}
B -->|N| End(结束)
B -->|Y| D{判断信号类型}
D -->|clk 上升沿| E{继续判断信号}
D -->|rstn 下降沿| F[进行置位操作，<br/>清除内存所有数据<br/>并进入接受数据状态]
F --> End
E -->|其他| End
E -->|input_valid 和 input_enable 均为 1| G1{进入接受数据状态，<br/>判断是否马上填满}
G1 -->|Y| H1[将 data_in 写入内存的最后一个 16 bit 空间中，<br/>同时进入输出数据状态]
G1 -->|N| I1[将 data_in 继续写入内存中]
E -->|output_valid 和 output_enable 均为 1| G2{进入输出数据状态，<br/>判断是否马上读空}
G2 -->|Y| H2[读出内存中最后一个 8 bit 数据，<br/>同时进入读取数据状态]
G2 -->|N| I2[将内存中的数据读出]
H1 & I1 & H2 & I2 --> End
```

在 `Github` 上，我发现代码不能正常显示，究其原因，**代码的文本里有 `Unicode` 符号**——中文逗号，为了解决这个问题，只需要**在文本前后添加英文双引号**即可：

```mermaid
flowchart LR
A("开始") --> B{"判断是否到达时钟信号上升沿<br/>或置位信号下降沿"}
B -->|N| End("结束")
B -->|Y| D{"判断信号类型"}
D -->|"clk 上升沿"| E{"继续判断信号"}
D -->|"rstn 下降沿"| F["进行置位操作，<br/>清除内存所有数据<br/>并进入接受数据状态"]
F --> End
E -->|"其他"| End
E -->|"input_valid 和 input_enable 均为 1"| G1{"进入接受数据状态，<br/>判断是否马上填满"}
G1 -->|Y| H1["将 data_in 写入内存的最后一个 16 bit 空间中，<br/>同时进入输出数据状态"]
G1 -->|N| I1["将 data_in 继续写入内存中"]
E -->|"output_valid 和 output_enable 均为 1"| G2{"进入输出数据状态，<br/>判断是否马上读空"}
G2 -->|Y| H2["读出内存中最后一个 8 bit 数据，<br/>同时进入读取数据状态"]
G2 -->|N| I2["将内存中的数据读出"]
H1 & I1 & H2 & I2 --> End
```

现在就能正常显示了。

所以，还是养成用英文双引号括好文本的习惯叭。。。

## 附录

[Mermaid | Diagramming and charting tool](https://mermaid.js.org/)

[About Mermaid | Mermaid](https://mermaid.js.org/intro/)
