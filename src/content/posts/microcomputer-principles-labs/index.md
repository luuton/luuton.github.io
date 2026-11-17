---
title: 微机原理实验复盘：从 MIPS 汇编到 FPGA 软核
published: 2026-11-17
pinned: false
description: 微机原理课程四个实验的完整复盘：MIPS 汇编、单周期 CPU、并行 IO 与串行 IO，附关键代码、调试坑点与复现方法。
tags: [microcomputer, mips, verilog, fpga, vivado, lab]
category: Study
licenseName: "Unlicensed"
author: Luuton
sourceLink: "https://github.com/luuton/microcomputer-principles-labs"
draft: false
date: 2026-11-17
pubDate: 2026-11-17
---

# 微机原理实验复盘：从 MIPS 汇编到 FPGA 软核

> 仓库地址：[luuton/microcomputer-principles-labs](https://github.com/luuton/microcomputer-principles-labs)
>
> 这篇文章把课程里的四个实验串成一条线：先在 MARS 里写 MIPS 汇编，再用 Verilog 搭一个能跑这些指令的单周期 CPU，最后用 MicroBlaze 软核把 GPIO、定时器、中断和 UART 串起来。每个实验都记录任务、关键代码、调试时踩过的坑和复现方法。

## 0. 实验全景

| 实验 | 主题 | 核心内容 | 工具 |
|---|---|---|---|
| 实验 1 | MIPS 汇编程序设计 | `PENO` 子程序：正奇数之和、负偶数之和 | MARS / QtSPIM |
| 实验 2 | 类 MIPS 单周期微处理器 | Verilog 实现 PC、ALU、寄存器堆、控制器、存储器，拓展 `addi` / `ori` | Vivado 2021.x |
| 实验 3 | 并行 IO 接口 | MicroBlaze + AXI GPIO / Timer / INTC，查询与中断两种实现 | Vivado + Vitis/SDK |
| 实验 4 | 串行 IO 接口 | UART 9600 bps，双板通信，16 位开关量分字节收发 | Vivado + Vitis/SDK |

仓库里除了源码和报告，还保留了 Vivado 的 Tcl 重建脚本，方便换机器后重新生成工程。

## 1. 实验一：MIPS 汇编与调用约定

### 1.1 任务

编写子程序 `PENO(&X, N, SP, SN)`：遍历长度为 `N` 的字数组 `X`，把所有**正奇数**累加到 `SP`，把所有**负偶数**累加到 `SN`。约定：

- `$a0` 存数组首地址，`$a1` 存数组长度；
- 返回值 `$v0 = SP`，`$v1 = SN`；
- 主程序用两组测试数组验证，并把结果打印到控制台。

测试数据：

```c
int X1[10] = {1, -4, 8, -9, 5, 6, -10, 19, 22, 23};
int X2[10] = {121, -124, 138, -199, 255, 2566, -1034, 1019, 2032, 2033};
```

### 1.2 核心循环

```asm
PENO:
    li   $v0, 0          # SP = 0
    li   $v1, 0          # SN = 0
    li   $t0, 0          # i = 0
    move $t3, $a0        # 当前元素指针
loop:
    beq  $t0, $a1, done
    lw   $t2, 0($t3)     # X[i]
    blez $t2, else       # X[i] <= 0 走负分支
    andi $t4, $t2, 1
    beq  $t4, $zero, next
    add  $v0, $v0, $t2   # 正奇数
    j    next
else:
    beq  $t2, $zero, next  # 0 既不是正数也不是负数
    andi $t5, $t2, 1
    beq  $t5, 1, next      # 负奇数不累加
    add  $v1, $v1, $t2     # 负偶数
next:
    addi $t0, $t0, 1
    addi $t3, $t3, 4
    j    loop
done:
    jr   $ra
```

### 1.3 两个容易踩的坑

1. **0 的处理**：`blez` 会把 0 也送进负分支，如果负分支只判断奇偶，0 会被当成负偶数累加。必须先 `beq $t2, $zero, next` 排除 0。
2. **返回值被 syscall 覆盖**：`PENO` 返回后如果马上执行 `syscall` 打印，`$v0` 和 `$a0` 会被系统调用改写。正确做法是先把 `$v0/$v1` 保存到 `$s0/$s1`，再输出。

### 1.4 内存映像

MARS 默认把 `.data` 放在 `0x10010000`，每个 `.word` 占 4 字节，所以 `arr1[0]` 在 `0x10010000`，`arr1[1]` 在 `0x10010004`。负数的内存值是补码，例如 `-4` 显示为 `0xfffffffc`。代码段从 `0x00400000` 开始，`jal PENO` 的机器码是 `0x0c100032`，可以据此观察指令与机器码的对应关系。

## 2. 实验二：类 MIPS 单周期 CPU

### 2.1 模块划分

单周期 CPU 在一个时钟周期内完成一条指令的完整流程：

```text
PC -> irom -> 指令寄存器 -> 控制器/寄存器堆/立即数扩展 -> ALU -> Dram -> 写回
```

工程中的主要 RTL 模块：

| 模块 | 作用 |
|---|---|
| `PC.v` | 保存当前指令地址，复位为 0，正常 `PC+4`，分支/跳转时更新为目标地址 |
| `irom.v` | 指令存储器，按 PC 取指令 |
| `regFile.v` | 32×32 寄存器堆，下降沿写入 |
| `ALU.v` | 根据 `aluCtr` 执行加、减、与、或、比较等运算，并给出 `zero` |
| `Dram.v` | 数据存储器 |
| `ctr.v` | 控制器，根据 `op` / `funct` 产生全部控制信号 |
| `top.v` | 顶层连线与模块例化 |

### 2.2 控制信号

控制器需要产生：

```text
RegDst, ALUSrc, MemtoReg, RegWriteEn,
MemReadEn, MemWriteEn, Branch, Jump,
ALUCtr
```

其中最容易出错的是 `RegDst`（写 `rt` 还是 `rd`）、`MemtoReg`（写回来自 ALU 还是内存）和 `ALUSrc`（第二操作数来自寄存器还是立即数）。

### 2.3 拓展 addi / ori

在原指令集基础上增加了两条 I 型指令：

| 指令 | op | 立即数扩展 | ALU 操作 | 目标寄存器 |
|---|---|---|---|---|
| `addi` | `001000` | 符号扩展 | 加法 | `rt` |
| `ori` | `001101` | 零扩展 | 按位或 | `rt` |

`addi` 必须做**符号扩展**，否则负数立即数会被当成大正数；`ori` 必须做**零扩展**，否则高 16 位会被符号位污染。

### 2.4 波形调试

用 `addi $7, $6, 20` 验证时，可以按下面几个阶段看波形：

1. 取指：`PAddr = 0x00`，取出机器码 `20c70014`；
2. 译码：控制器识别 `op = 0x08`，给出 `RegWrite=1`、`ALUSrc=1`、`ALUCtr=ADD`；
3. 取操作数：读出 `$6 = 24`，立即数 20 符号扩展；
4. 执行：ALU 得到 `44`；
5. 写回：时钟下降沿把 44 写入 `$7`；
6. 更新 PC：顺序执行，`pc_out` 变为 `0x04`。

> 注意：报告里有一处笔误写成 `24 + 20 = 24`，正确结果应为 `44`。写实验报告时这类数字要对着波形核对。

## 3. 实验三：并行 IO 与中断

### 3.1 任务

用独立按键和拨码开关作为输入，LED 和 8 位数码管作为输出：

- LED 实时显示开关状态；
- 数码管显示最近按下的按键位置编码（C、U、L、D、R）；
- 分别用**查询**和**中断**两种方式实现。

### 3.2 硬件结构

Vivado Block Design 中使用 MicroBlaze 软核，挂载：

- `AXI GPIO`：开关输入、LED 输出、数码管段选/位选、按键输入；
- `AXI Timer`：产生数码管动态扫描的定时中断；
- `AXI INTC`：汇总 GPIO 和 Timer 中断，接到 MicroBlaze 中断控制器。

### 3.3 查询方式

查询方式的主循环做三件事：

```c
while (1) {
    u16 sw = Xil_In16(GPIO0 + XGPIO_DATA_OFFSET);
    Xil_Out16(GPIO0 + XGPIO_DATA2_OFFSET, sw);   // 开关 -> LED
    // 读按键，更新 button
    for (int i = 0; i < 8; i++) {
        Xil_Out16(GPIO1 + XGPIO_DATA2_OFFSET, segcode[button]); // 段选
        Xil_Out16(GPIO1 + XGPIO_DATA_OFFSET, pos);              // 位选
        for (int j = 0; j < 10000; j++);                        // 延时
        pos >>= 1;
    }
    pos = 0xff7f;
}
```

优点是直观；缺点是 CPU 一直在轮询和延时，效率低。

### 3.4 中断方式

中断方式把三件事拆成三个 ISR：

| 中断源 | 处理函数 | 工作 |
|---|---|---|
| GPIO0（开关） | `SwitchHandler` | 读开关值，写 LED，清 GPIO 中断 |
| GPIO2（按键） | `PushBtnHandler` | 读键值，映射为 `button`，清 GPIO 中断 |
| Timer | `seg7_TimerHandler` | 每次中断刷新一位数码管，8 次完成一轮扫描 |

主循环只负责打印标志，不再参与实时控制。

### 3.5 调试要点

1. **中断使能顺序**：外设使能 → INTC 使能 → CPU 全局中断使能。顺序错了会收不到中断。
2. **清中断**：GPIO 要写 `ISR` 清中断，Timer 要回写 `TCSR`，INTC 最后写 `IAR`。漏清会反复进中断。
3. **数码管扫描**：位选信号每次右移一位，8 次后恢复 `0xff7f`；否则会出现重影或只亮一位。
4. **按键抖动**：机械按键需要软件消抖，或者至少在一次中断后延时再读。

## 4. 实验四：串行 IO 与 UART

### 4.1 任务

两块 Nexys4 DDR 通过 UART 通信，波特率 9600：

- 板 A 拨动开关，把 16 位开关值通过 UART1 发给板 B 的 UART2，板 B 用 LED 显示；
- 板 B 按下按键，把按键值通过 UART2 发给板 A 的 UART1，板 A 用数码管显示。

### 4.2 16 位数据分两字节发送

UART 一次只能发 8 位，所以 16 位开关量必须拆成低字节和高字节：

```c
if (Xil_In32(uart1_STATUS) & XUL_SR_TX_FIFO_EMPTY) {
    Xil_Out8(uart1_TX_FIFO, sw & 0xff);          // 低字节
    while (!(Xil_In32(uart1_STATUS) & XUL_SR_TX_FIFO_EMPTY));
    Xil_Out8(uart1_TX_FIFO, (sw >> 8) & 0xff);   // 高字节
}
```

发送端必须等发送 FIFO 空再写第二个字节，否则高字节会覆盖低字节。

### 4.3 接收端状态机

接收端用一个两状态的状态机拼装：

```c
if (uart2_rx_state == 0) {
    uart2_rx_low = data;      // 收到低字节
    uart2_rx_state = 1;
} else {
    u16 sw = uart2_rx_low | ((u16)data << 8);  // 拼成 16 位
    Xil_Out16(GPIO0 + XGPIO_DATA2_OFFSET, sw); // 更新 LED
    uart2_rx_state = 0;
}
```

### 4.4 与并行 IO 的对比

| | 并行 IO | 串行 IO |
|---|---|---|
| 引脚占用 | 每根信号一根线 | 只需 TX/RX 两根线 |
| 传输距离 | 短 | 长 |
| 速度 | 高 | 受波特率限制 |
| 适用场景 | 板内、短距离 | 板间、远距离 |

## 5. 操作考试：四道真题与实现

> 仓库 `操作考试/` 目录保留了四道上机题的参考代码。下面把题目、思路和关键实现整理出来；示例代码是便于阅读的简化版，实际工程还需要包含 `headfile.h` 和 Xilinx BSP 头文件。

### 5.1 真题一：按键计数与两位数码管

**题目：** 初始数码管低两位显示 0；按下按键 U 后显示 U 按下的次数，大于 20 时清 0；按下 L 清零。要求中断实现，注意按键消抖。

**思路：**

- 按键 GPIO 中断 → `PushBtnHandler`；定时器 1 ms 中断 → 两位动态扫描。
- `u_count` 保存计数，段码表 `seg7_table[10]` 把 0–9 转成七段码。
- 消抖：进入中断后延时约 1 ms 再读键值。

**关键代码：**

```c
void PushBtnHandler(void) {
    switch (Xil_In8(Btn_data)) {
    case 2:                                 // U
        for (int i = 0; i < 1000; i++);     // 约 1 ms 消抖
        u_count = (u_count >= 20) ? 0 : u_count + 1;
        break;
    case 4:                                 // L
        for (int i = 0; i < 1000; i++);
        u_count = 0;
        break;
    }
    Xil_Out32(Btn_ISR, Xil_In32(Btn_ISR));  // 清 GPIO 中断
}

void TimerHandler(void) {
    seg_buf[0] = seg7_table[u_count % 10];  // 个位
    seg_buf[1] = seg7_table[u_count / 10];  // 十位
    Xil_Out16(segment_data, seg_buf[scan]);
    Xil_Out16(anode_data, pos[scan]);
    scan = (scan + 1) & 1;
    Xil_Out32(Timer_TCSR, Xil_In32(Timer_TCSR));
}
```

**易错点：** 计数到 20 后应回到 0（不是 21）；两位数码管的段选与位选要一一对应；中断里不要调用 `printf` 之类的阻塞函数。

### 5.2 真题二：开关值映射 LED

**题目：** 拨动开关，读取 `SW[2:0]`，按其值点亮 `LED[7:0]`。例如 SW=101 时点亮 5 个 LED。按 L 点亮数 +1，按 R 点亮数 −1；超过 8 回到 1，小于 1 回到 8。中断实现。

**思路：**

- 开关中断 → 读 `SW & 0x07` 得到 0–7；用查表 `tableLED[n]` 生成“前 n 个 LED 亮”的图案。
- 按键 L/R 修改 `led_count`，注意边界：`8 → 1`、`1 → 8`。
- 每次修改后立即写 LED 寄存器。

**关键代码：**

```c
void SwitchHandler(void) {
    led_count = Xil_In16(Switch_data) & 0x07;
    Xil_Out8(led_data, tableLED[led_count]);
    Xil_Out32(Switch_ISR, Xil_In32(Switch_ISR));
}

// L：+1
if (led_count >= 8) led_count = 1;
else led_count++;
// R：-1
if (led_count <= 1) led_count = 8;
else led_count--;
Xil_Out8(led_data, tableLED[led_count]);
```

**易错点：** 仓库原代码用的是 `led_count > 8` 和 `led_count < 1`，当计数正好等于 8 或 1 时会多走一步；应改为 `>=` / `<=`。

### 5.3 真题三：数码管滚动显示 2026

**题目：** 八位数码管初始从左到右显示 `2026`，空位显示 `-`。按 R 后数字整体向右移动；当 6 移到最右端后，下一次移动 `2026` 整体回到最左端；按 L 停止滚动，再按 R 继续。滚动周期 1 s，中断实现。

**思路：**

- 用一个 8 位掩码 `seg_p` 表示“哪几位显示数字”，初值 `0xf0`（左四位）。
- 定时器 1 ms 中断里累计 `tick`，每 1000 次（1 s）把掩码循环右移一位：
  `seg_p = (seg_p >> 1) | ((seg_p & 1) << 7);`
- 扫描时，掩码为 1 的位依次取 `2026` 的段码，为 0 的位写 `-` 的段码。
- L/R 只改变 `run` 标志，不改掩码。

**关键代码：**

```c
static const u8 seg2026[4] = {0xA4, 0xC0, 0xA4, 0x82}; // 2 0 2 6
u8 seg_p = 0xf0;   // 显示窗口

// 1 s 到，循环右移
if (++tick >= 1000) {
    tick = 0;
    if (run) seg_p = (seg_p >> 1) | ((seg_p & 1) << 7);
}

// 动态扫描
if ((seg_p >> scan) & 1) {
    Xil_Out16(segment_data, seg2026[digit++]);
    if (digit == 4) digit = 0;
} else {
    Xil_Out16(segment_data, SEG_DASH);
}
Xil_Out16(anode_data, pos[scan]);
scan = (scan + 1) & 7;
```

**易错点：** 不能用普通的左/右移，否则 `2026` 会被拆开；必须用循环移位保持四位整体移动。题目中“每两秒移动一格”与“滚动周期 1 s”存在冲突，考试时以最后一句为准。

### 5.4 真题四：LED 循环移动

**题目：** 按 C 让 `LED[7:0]` 显示固定初值 `11110000`；按 L 后 LED 以 1 Hz 向左循环移动（`11110000 → 11100001`）；再按 L 变为向右循环；再按 L 停止并保持当前位置。中断实现。

**思路：**

- 三个状态：停止、左移、右移。用 `mode`（或 `l_flag/r_flag`）表示。
- 定时器 1 ms 累计到 1000 次（1 s）执行一次循环移位：
  - 左移：`led = (led << 1) | (led >> 7);`
  - 右移：`led = (led >> 1) | (led << 7);`
- 按键 C 重置 `led = 0xF0`；L 在三个状态间切换。

**关键代码：**

```c
if (++tick >= 1000) {
    tick = 0;
    if (mode == LEFT)  led = (led << 1) | (led >> 7);
    if (mode == RIGHT) led = (led >> 1) | (led << 7);
    Xil_Out8(led_data, led);
}
```

**易错点：** 仓库原代码把 `if (tick >= 1000)` 写成了两层嵌套，外层每 1 s 才进入一次，内层永远不成立；正确写法是每 1 ms 只判断一次 `++tick >= 1000`。

### 5.5 四道题的共同点

1. **定时器只做“节拍”**：1 ms 中断负责扫描/计时，业务逻辑放在计数变量里。
2. **按键只改状态**：ISR 里改 `mode` / `count` / `run`，显示刷新交给定时器。
3. **边界要闭环**：计数 20→0、点亮数 8→1、掩码循环移位，都是“环形”逻辑。
4. **中断要清干净**：GPIO 写 `ISR`、Timer 回写 `TCSR`、INTC 最后写 `IAR`。

## 6. 环境与复现

### 6.1 软件

- Windows 10/11
- Xilinx Vivado 2021.2（仓库 Tcl 由该版本导出）
- Vitis/SDK（MicroBlaze 软件工程）
- MARS / QtSPIM（实验 1）

### 6.2 重建 Vivado 工程

```text
实验2-类MIPS单周期微处理器设计/MIPS_cpu/create_project.bat
实验3-并行IO接口实验/IO_exp/create_project.bat
实验4-串行IO接口实验/IO_exp/create_project.bat
```

双击或在命令行执行，脚本会调用 `create_prj.tcl` 重建工程。

### 6.3 常见问题

1. **找不到 `vivado.bat`**：Vivado 没加入环境变量；可以在 Vivado Tcl Console 里 `source create_prj.tcl`。
2. **找不到 Nexys4 DDR 板卡文件**：把 Digilent 的 `nexys4_ddr` 板卡文件放到 Vivado 的 `board_store` 目录，或修改 `create_prj.tcl` 里的 `board_part_repo_paths`。
3. **软件工程编译失败**：重新导出 XSA、重新生成 BSP，再清理重编译。
4. **中断没有输出**：检查波特率、COM 口、bitstream 与 elf 是否匹配，以及中断使能/清除顺序。

## 7. 复盘

这四个实验连起来，其实是一条很完整的“软硬协同”链路：

- 实验 1 让我习惯用寄存器和内存看程序，而不是只写 C；
- 实验 2 把指令拆成数据通路和控制信号，理解了“一条指令一个周期”的代价；
- 实验 3 把 CPU 核、GPIO、定时器和中断控制器连起来，体会到查询与中断的取舍；
- 实验 4 把并行接口换成串行接口，理解了协议、FIFO 和状态机在真实通信中的作用。

仓库里保留了源码、报告和重建脚本。如果你也在做同样的实验，建议先跑通最小例子，再逐个加中断和外设；遇到问题时先看波形和寄存器，再改代码。

> 仓库：[luuton/microcomputer-principles-labs](https://github.com/luuton/microcomputer-principles-labs)
