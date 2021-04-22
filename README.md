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

  `InexRecur()` 本质上是递归调用，需要手动维护调用现场并保存当前的结果。
  
  比对过程需要的数据：
  
  - 1. 与参考序列相关：C，Occ（出现数组）
  
  - 2. 与短序列相关：W（短序列本身），D（搜索边界）

  - 3. 与执行过程有关：调用 `InexRecur()` 的参数，当前参数执行的状态

  其中，将1、2两项称为 **rom** （执行过程中只读不写）；3称为 **regfile**（执行过程中有又读又写）

  2、3项和加速器核心构成一个完整的加速器

  从 rom_Occ 中需要获取两次数据，分两次读数据，对应状态 **get_data_2** 和 **get_data_3**

  ### 状态机
  
  ```mermaid
    stateDiagram
        [*] --> idle 
        idle --> get_param : is_start == true
        get_param --> get_data_1 : is_find == true
        get_data_1 --> ex : is_get_data_in_Occ == false
        get_data_1 --> get_data_2 : is_get_data_in_Occ == true
        get_data_2 --> get_data_3
        get_data_3 --> ex
        ex --> write_back
        write_back --> get_param
        ex --> finish : is_finish == true
        finish --> [*]

        state get_param {
          now --> go_back
          go_back --> now
        }

        note right of idle
            复位初始状态
        end note

        note right of get_param
            包含一个小的状态机，找到尚未完成的参数调用
        end note
  ```

  ### 现场保护

  `regfile_state` 和 `regfile_InexRecur` 中的数据一一对应（地址相同）

  `regfile_InexRecur`: 记录每次调用 `InexRecur()` 的参数

  `regfile_state`：记录对应参数的执行位置、返回地址、当前是否执行结束

  各个执行位置如下所示：

  ```
  InexRecur(W, i, z, k, l)
  begin              =================> NONE
  |  if z<D (i) then
  |  |  return φ
  |  end             =================> STOP_1
  |  if i < 0 then
  |  |  return [k,l]
  |  end             =================> STOP_2
  |  I = φ          
  |  I = I ∪ InexRecur(W, i − 1, z − 1, k,l)
  |                  =================> INSERTION_{A,C,G,T}
  |  for each b ∈ {A, C, G, T} do
  |  |  kb = C (b) + O (b, k − 1) + 1
  |  |  lb = C (b) + O (b, l)
  |  |  if kb ≤ lb then
  |  |  |  I = I ∪ InexRecur(W, i, z − 1, kb, lb)
  |  |  |           =================> DELETION_{A,C,G,T}
  |  |  |  if b = W[i] then
  |  |  |  |  I = I ∪ InexRecur(W, i − 1, z, kb, lb)
  |  |  |  |        =================> MATCH_{A,C,G,T}
  |  |  |  else
  |  |  |  |  I = I ∪  InexRecur(W, i − 1, z − 1, kb, lb)
  |  |  |  |        =================> SNP_{A,C,G,T}
  |  |  |  end
  |  |  end
  |  end
  |  return I
  end
  ```
---

## 文件结构

`./sim_1` 中为测试文件；`./sources_1` 中为源代码

🐖注：`./sim_1` 中很多测试文件是在开发过程中写的，其调用的模块名称、接口定义与最终成果有差异

`./sim_1` 中的测试文件彼此没有依赖关系，不再其介绍文件结构

`./sources_1/new` 中的文件结构

```
.
├── _top.v                      // 最顶层的封装
|   |
|   ├── _accelerator_top.v      // 加速器顶层
|   |   |
|   │   ├── _accelerator_fsm.v  // 加速器状态控制
|   |   |   |
|   |   |   ├── state_control.v  
|   |   |   |
|   |   |   ├── get_param.v     // 取参数
|   |   |   |
|   |   |   ├── get_data_1.v    // 取数据(rom_read_and_D、rom_C)
|   |   |   |
|   |   |   ├── get_data_2.v    // 取数据(rom_Occ)
|   |   |   |
|   |   |   ├── get_data_3.v    // 取数据(rom_Occ)
|   |   |   |
|   |   |   ├── exa.v           // 判断/执行
|   |   |   |
|   |   |   └── write_back.v    // 回写
|   |   |
|   │   ├── regfile_InexRecur.v // 两个 regfile 数据宽度不同，均为 regfile.v 的实例化
|   |   |  
|   |   ├── regfile_state.v     // 两个 regfile 数据宽度不同，均为 regfile.v 的实例化
|   |   |
|   |   └──rom_read_and_D.v    
|   |
|   ├── rom_Occ.v
|   └── rom_C.v          
|
├── C.data               // rom_C.v 数据           C(a)
├── Occ.data             // rom_Occ.v 数据         Occ(a,i)
└── read_and_D.data      // rom_read_and_D.v 数据  W、D(i)

```

---

## 备注（2020/4/22）

🐖注：rom 中的数据在初始化的时候被加载进去

🐖注：当前尚未进行板载验证

有关 python 和 C/C++ 语言执行效率的差别，参考 `./reference` 中的总结。

PL 部分使用 DDR 读取数据。（待完成）

多核心处理。（待完成）
