# my_accelerator

本科毕设的项目

**基于 BWT 的短序列比对算法的硬件加速器**

- *参考文献*：[Hardware-Acceleration of Short-Read Alignment Based on the Burrows-Wheeler Transform](./reference/Hardware-Acceleration%20of%20Short-Read%20Alignment.pdf)

- *核心算法*：参考文献中提及 `Algorithm 1. Short-read Alignment Algorithm` 

- *加速核心*：`Algorithm 1. Short-read Alignment Algorithm` 中的 `InexRecur()` 函数

值得一提的是：

- `InexRecur()` 函数的递归调用完成了整个比对过程
  
- 该过程的输出结果是后缀数组/序列的索引（SA_index）
  
  后续，仍需要需要借助其他工具生成 CIGAR 串等其他的比对信息

---

## 前提说明

该加速器核心的所实现的算法来源于**参考文献**

该加速器核心的整体结构为**状态机**，每个状态的设计参考了**CPU的经典五级流水线**

设计语言：verilog HDL（2005年标准）

相关工具：vivado 2020.1

板载验证：pynq-z2（镜像v2.6）

---

## 想法构思

- `InexRecur()` 本质上是递归调用，需要手动维护调用现场并保存当前的结果。

- 比对过程需要的数据：
  
    1. 与参考序列相关：C，Occ（出现数组）
  
    2. 与短序列相关：W（短序列本身），D（搜索边界）

    3. 与执行过程有关的：调用 `InexRecur()` 的参数，当前参数执行的状态

    其中，将1、2两项称为 **rom** （执行过程中只读不写）；3称为 **regfile**（执行过程中有又读又写）

- 数据2、3项和加速器核心构成一个完整的加速器

- 状态机：

---

## 文件结构

---

## 备注

