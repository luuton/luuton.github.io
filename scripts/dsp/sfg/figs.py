# -*- coding: utf-8 -*-
"""结构参数 -> 绝对坐标（图元表）。制图规范见 README.md。

坐标：1 单位 = 1 英寸，y 轴向下。

统一布局（所有方框图共用）：
  * 两条水平链：前馈链在上（y=0），反馈链在下（y=2.40）；
    直接 II 型只有一条链（y=0）。
  * 求和母线在链右端外侧（竖直短线），母线中央放 Σ 圆并引出 y(n)。
  * 抽头先竖直离开链、再水平汇入母线；前馈抽头越靠左层越高，
    反馈抽头越靠左层越低 —— 两组各占母线一半高度，永不交叉。
"""
from build import (node, branch, label, gain, box, adder, fig,
                   STEP, NODE_R, ADD_R, BOX_W, FS_GAIN)

Y_A, Y_B = 0.0, 2.40        # 上链 / 下链
BUS_TOP, BUS_BOT, Y_M = 0.30, 2.10, 1.20
SUM_R = 0.24
LEVEL0, LEVEL_STEP = 0.36, 0.235
X_BUS_PAD = 1.25


def _levels(count, top):
    """从 top 开始、向下递增的层高列表。"""
    return [top + LEVEL_STEP * i for i in range(count)]


def sfg_direct(name, a):
    """纯信号流图：节点即信号，延迟写成 z^{-1} 支路。

    反馈支路全部画在主干下方（按抽头远近分层），输出从 y(n) 向上引出，
    因此主干上方只承载输出线，不存在交叉。
    """
    n = len(a)
    xs = [0.85 + i * STEP for i in range(n + 2)]
    y = 0.0
    items = [branch([(xs[0], y), (xs[-1], y)], arrow=False)]
    items += [node(x, y) for x in xs]
    items.append(branch([(xs[0] - 0.85, y), (xs[0], y)]))
    items.append(label("{i:x}(n)", xs[0] - 0.95, y + 0.06, 0.15, "end"))
    items.append(gain("1", (xs[0] + xs[1]) / 2, y - 0.16))
    for i in range(1, n + 1):
        items.append(gain("{i:z}^{-1}", (xs[i] + xs[i + 1]) / 2, y - 0.16))

    # 反馈：越远的抽头层越深
    for i in range(n):
        lvl = y + 0.72 + 0.30 * i
        items.append(branch([(xs[i + 2], y), (xs[i + 2], lvl),
                             (xs[1], lvl), (xs[1], y)]))
        items.append(gain(a[i], (xs[1] + xs[i + 2]) / 2, lvl + 0.235))

    # 输出从 y(n) 向上
    items.append(branch([(xs[1], y), (xs[1], y - 0.78)]))
    items.append(label("{i:y}(n)", xs[1] + 0.14, y - 0.72, 0.15, "start"))
    for i in range(1, n + 1):
        items.append(label("{i:y}(n-%d)" % i, xs[i + 1] + 0.13, y + 0.30, 0.135, "start"))
    return fig(name, items, pad=0.22, pad_right=1.00, pad_top=0.60, pad_bottom=0.10)


def _chain(items, y, xs, prefix, label_above):
    """延迟链：节点 + 节点之间的 z^-1 方框 + 信号名。

    主干在方框处断开，只画「节点 ↔ 方框边缘」的小段，避免线穿方框。
    """
    bw = BOX_W
    for i, x in enumerate(xs):
        items.append(node(x, y))
        if i:
            items.append(label("{i:%s}(n-%d)" % (prefix, i), x,
                              y - 0.34 if label_above else y + 0.36, 0.135))
    for i in range(1, len(xs)):
        cx = (xs[i - 1] + xs[i]) / 2
        items.append(box(cx, y, ["{i:z}^{-1}"]))
        items.append(branch([(xs[i - 1], y), (cx - bw / 2, y)], arrow=False))
        items.append(branch([(cx + bw / 2, y), (xs[i], y)], arrow=False))


def block_direct1(name, a, b):
    """直接 I 型：x 链在上、y 链在下，全部抽头汇入右侧求和母线。

    层高规则（保证零交叉）：抽头离母线越远，其水平段离所属链越远。
    """
    m, n = len(b) - 1, len(a)
    xs = [0.95 + i * STEP for i in range(max(m, n) + 1)]
    x_bus = xs[-1] + X_BUS_PAD
    items = []

    items.append(branch([(xs[0] - 1.15, Y_A), (xs[0] - NODE_R, Y_A)]))
    items.append(label("{i:x}(n)", xs[0] - 1.25, Y_A + 0.06, 0.15, "end"))
    _chain(items, Y_A, xs[:m + 1], "x", label_above=True)
    _chain(items, Y_B, xs[:n + 1], "y", label_above=False)

    items.append(label("{i:y}(n)", xs[0] - 0.12, Y_B + 0.06, 0.15, "end"))
    items.append(branch([(x_bus, BUS_TOP), (x_bus, Y_M - SUM_R)], arrow=False))
    items.append(branch([(x_bus, Y_M + SUM_R), (x_bus, BUS_BOT)], arrow=False))
    items.append(adder(x_bus, Y_M, SUM_R))
    items.append(branch([(x_bus + SUM_R, Y_M), (x_bus + SUM_R + 0.95, Y_M)]))
    items.append(label("{i:y}(n)", x_bus + SUM_R + 1.05, Y_M + 0.06, 0.15, "start"))

    # 前馈抽头：越靠左 → 水平段越低（远离上链）
    for i in range(m + 1):
        lvl = LEVEL0 + LEVEL_STEP * (m - i)
        items.append(branch([(xs[i], Y_A + NODE_R), (xs[i], lvl), (x_bus, lvl)]))
        items.append(gain(b[i], (xs[i] + x_bus) / 2, lvl - 0.075))

    # 反馈抽头：越靠左 → 水平段越高（远离下链）
    for i in range(n):
        lvl = Y_B - LEVEL0 - LEVEL_STEP * (n - 1 - i)
        items.append(branch([(xs[i + 1], Y_B - NODE_R), (xs[i + 1], lvl), (x_bus, lvl)]))
        items.append(gain(a[i], (xs[i + 1] + x_bus) / 2, lvl - 0.075))

    # y(n) 由母线回灌到下链最左节点
    xr = x_bus + SUM_R + 0.55
    items.append(branch([(x_bus + SUM_R + 0.95, Y_M), (xr, Y_M), (xr, Y_B + 0.70),
                         (xs[0], Y_B + 0.70), (xs[0], Y_B + NODE_R)]))
    return fig(name, items)


def block_direct2(name, a, b):
    """直接 II 型（规范型）：一条延迟链 w(n)，反馈走下方、输出走上方。"""
    n = len(a)
    xs = [2.05 + i * STEP for i in range(n + 1)]
    y = 0.0
    x_sum = xs[0] - 1.10
    items = [branch([(x_sum - 1.00, y), (x_sum - SUM_R, y)]),
             label("{i:x}(n)", x_sum - 1.08, y + 0.06, 0.15, "end"),
             adder(x_sum, y, SUM_R),
             branch([(x_sum + SUM_R, y), (xs[0] - NODE_R, y)])]
    for i, x in enumerate(xs):
        items.append(node(x, y))
        if i:
            items.append(box((xs[i - 1] + x) / 2, y, ["{i:z}^{-1}"]))
            items.append(label("{i:w}(n-%d)" % i, x + 0.13, y + 0.36, 0.135, "start"))

    # 反馈：越靠右 → 层越低（远离主干），全部汇入左侧求和点
    for i in range(1, n + 1):
        lvl = y + 0.62 + LEVEL_STEP * (i - 1)
        items.append(branch([(xs[i], y + NODE_R), (xs[i], lvl),
                             (x_sum, lvl), (x_sum, y + SUM_R)]))
        items.append(gain(a[i - 1], (x_sum + xs[i]) / 2, lvl - 0.075))

    if len(b) == 1:
        items.append(branch([(xs[0], y - NODE_R), (xs[0], y - 0.95)]))
        items.append(label("{i:y}(n)", xs[0], y - 1.04, 0.15))
        return fig(name, items)

    # 输出：上方针平段按抽头远近分层，母线竖直汇聚后进入 Σ（Σ 置于所有抽头之下）
    x_bus = xs[-1] + 0.80
    levels = [y - 0.62 - LEVEL_STEP * (len(b) - 1 - i) for i in range(len(b))]
    for i, lvl in enumerate(levels):
        items.append(branch([(xs[i], y - NODE_R), (xs[i], lvl), (x_bus, lvl)]))
        items.append(gain(b[i], (xs[i] + x_bus) / 2, lvl - 0.075))
    y_sum = max(levels) + 0.62
    items.append(branch([(x_bus, min(levels)), (x_bus, y_sum - SUM_R)], arrow=False))
    items.append(adder(x_bus, y_sum, SUM_R))
    items.append(branch([(x_bus + SUM_R, y_sum), (x_bus + SUM_R + 0.95, y_sum)]))
    items.append(label("{i:y}(n)", x_bus + SUM_R + 1.05, y_sum + 0.06, 0.15, "start"))
    return fig(name, items)


def block_cascade(name, sections, w=2.30, h=1.15):
    """级联型：每节一个方框，框内按「名称 / 分子 / 分数线 / 分母」排版。"""
    y = 0.0
    gap = 0.95
    xs = [1.85 + i * (w + gap) for i in range(len(sections))]
    items = [branch([(0.10, y), (xs[0] - w / 2, y)]),
             label("{i:x}(n)", 0.02, y + 0.06, 0.15, "end")]
    for i, sec in enumerate(sections):
        items.append(box(xs[i], y, sec, w=w, h=h, size=0.115))
        if i:
            items.append(branch([(xs[i - 1] + w / 2, y), (xs[i] - w / 2, y)]))
    items.append(branch([(xs[-1] + w / 2, y), (xs[-1] + w / 2 + 0.90, y)]))
    items.append(label("{i:y}(n)", xs[-1] + w / 2 + 1.00, y + 0.06, 0.15, "start"))
    return fig(name, items, pad=0.32)


def block_parallel(name, branches, w=2.30, h=0.80):
    """并联型：各支路方框上下排列，输出汇入右侧 Σ。"""
    y_mid = 0.0
    k = len(branches)
    pitch = h + 0.38
    ys = [y_mid - pitch * (k - 1) / 2 + pitch * i for i in range(k)]
    x0, xb, x_bus = 1.05, 3.10, 5.05
    items = [node(x0, y_mid), label("{i:x}(n)", x0 - 0.14, y_mid + 0.06, 0.15, "end")]
    for yy, lines in zip(ys, branches):
        items.append(box(xb, yy, lines, w=w, h=h, size=0.120))
        items.append(branch([(x0 + NODE_R, y_mid), (x0 + 0.62, y_mid),
                             (x0 + 0.62, yy), (xb - w / 2, yy)]))
        items.append(branch([(xb + w / 2, yy), (x_bus, yy)]))
    y_top, y_bot = ys[0], ys[-1]
    items.append(branch([(x_bus, y_top), (x_bus, y_mid - SUM_R)], arrow=False))
    items.append(branch([(x_bus, y_mid + SUM_R), (x_bus, y_bot)], arrow=False))
    items.append(adder(x_bus, y_mid, SUM_R))
    items.append(branch([(x_bus + SUM_R, y_mid), (x_bus + SUM_R + 0.90, y_mid)]))
    items.append(label("{i:y}(n)", x_bus + SUM_R + 1.00, y_mid + 0.06, 0.15, "start"))
    return fig(name, items, pad=0.30)


def fig_butterfly(name):
    """基 2 蝶形运算（约定符号图）。

    A = x1 + W x2，B = x1 - W x2：x1 以增益 1 送往 A、B；
    x2 以增益 W 送往 A、-W 送往 B。四条支路两两交叉，是全篇唯一允许斜线的图。
    """
    y1, y2 = 0.0, 1.10
    xj1, xj2 = 1.25, 1.95          # 两个抽头
    xa, xb = 3.55, 3.55            # 两个求和节点
    items = [node(xj1, y1), node(xj2, y2)]

    # 主干：x1 行、x2 行
    items.append(branch([(0.55, y1), (xj1, y1)]))
    items.append(branch([(xj1, y1), (xa, y1)]))
    items.append(branch([(0.55, y2), (xj2, y2)]))
    items.append(branch([(xj2, y2), (xb, y2)]))
    items.append(label("{i:x}_{1}", 0.46, y1 + 0.06, 0.15, "end"))
    items.append(label("{i:x}_{2}", 0.46, y2 + 0.06, 0.15, "end"))

    # 交叉支路
    items.append(branch([(xj1, y1), (xb - 0.02, y2 - 0.10)]))   # x1 -> B，增益 1
    items.append(branch([(xj2, y2), (xa - 0.02, y1 + 0.10)]))   # x2 -> A，增益 W

    # 输出
    items.append(branch([(xa, y1), (xa + 0.95, y1)]))
    items.append(branch([(xb, y2), (xb + 0.95, y2)]))
    items.append(label("{i:x}_{1}+{i:W}{i:x}_{2}", xa + 1.05, y1 + 0.06, 0.15, "start"))
    items.append(label("{i:x}_{1}-{i:W}{i:x}_{2}", xb + 1.05, y2 + 0.06, 0.15, "start"))

    # 增益标注
    items.append(gain("1", (xj1 + xa) / 2 + 0.10, y1 - 0.13))
    items.append(gain("-{i:W}", (xj2 + xb) / 2 - 0.05, y2 + 0.22))
    # 两条交叉支路的增益标在中点旁（分居对角线两侧）
    # 增益标在两条对角线的外侧，避免压线
    # 两条对角线之间的空隙里放增益，左右各一，互不压线
    items.append(gain("1", xj1 + 0.30, 0.30))             # x1 -> B
    items.append(gain("{i:W}", xj2 + 0.30, 0.80))         # x2 -> A
    return fig(name, items, pad=0.20, pad_right=0.35)





def fig_course_map(name):
    """全课程主线。版式刻意收紧（约 6 单位宽），使字号在文章栏宽下仍可读。

    第 1 行：连续信号 → 理想取样 → 序列
    第 2 行：四种变换（时域 → 频域 → z 域/DFT），LSI 并入首格
    第 3 行：IIR / FIR 两条设计路线
    第 4 行：随机信号与功率谱估计
    """
    items = []
    w1, h1 = 1.62, 0.92
    xs = [0.92, 2.90, 5.54]
    yA = 0.60
    items += [
        box(xs[0], yA, ["连续信号", "{i:x}_{a}({i:t})"], w=w1, h=h1, size=0.140),
        box(xs[1], yA, ["理想取样", "取样定理 §2.6"], w=w1, h=h1, size=0.130),
        box(xs[2], yA, ["序列", "{i:x}(n)"], w=w1, h=h1, size=0.140),
        branch([(xs[0] + w1 / 2, yA), (xs[1] - w1 / 2, yA)]),
        branch([(xs[1] + w1 / 2, yA), (xs[2] - w1 / 2, yA)]),
    ]
    # 第 2 行：四个格（LSI + 三种变换）
    w2, h2 = 1.32, 0.98
    xs2 = [0.92 + i * (w2 + 0.22) for i in range(4)]
    yB = 2.15
    items += [
        box(xs2[0], yB, ["LSI 系统", "{i:h}(n)"], w=w2, h=h2, size=0.135),
        box(xs2[1], yB, ["时域", "{i:y}={i:x}*{i:h}"], w=w2, h=h2, size=0.130),
        box(xs2[2], yB, ["频域 DTFT", "{i:Y}={i:X}·{i:H}"], w=w2, h=h2, size=0.130),
        box(xs2[3], yB, ["{i:z} 域 / DFT", "第 3 章"], w=w2, h=h2, size=0.130),
        branch([(xs2[0] + w2 / 2, yB), (xs2[1] - w2 / 2, yB)]),
        branch([(xs2[1] + w2 / 2, yB), (xs2[2] - w2 / 2, yB)]),
        branch([(xs2[2] + w2 / 2, yB), (xs2[3] - w2 / 2, yB)]),
        # 序列 → 第 2 行：右移出格子的投影范围，再折回 z 域格顶部
        branch([(xs[2], yA + h1 / 2), (xs[2], yB - h2 / 2)]),
    ]
    # 第 3 行：两条设计路线
    w3, h3 = 2.40, 1.02
    x3a, x3b = 1.45, 4.05
    yC = 3.70
    items += [
        box(x3a, yC, ["IIR 设计", "冲激响应不变 / 双线性"], w=w3, h=h3, size=0.125),
        box(x3b, yC, ["FIR 设计", "窗函数法 / 频率取样法"], w=w3, h=h3, size=0.125),
        branch([(x3a, yB + h2 / 2), (x3a, yC - h3 / 2)]),
        branch([(x3b, yB + h2 / 2), (x3b, yC - h3 / 2)]),
        label("按指标设计 {i:H}({i:z})", x3a + 0.10, (yB + yC) / 2 + 0.02, 0.130, "start"),
    ]
    # 第 4 行：随机信号与谱估计（两条设计路线在此汇合）
    w4, h4 = 3.60, 0.92
    yD = 5.15
    yMerge = 4.60
    items += [
        box(x3b, yD, ["随机信号与功率谱估计", "第 5、7 章"], w=w4, h=h4, size=0.130),
        branch([(x3a, yC + h3 / 2), (x3a, yMerge), (x3b, yMerge)], arrow=False),
        branch([(x3b, yC + h3 / 2), (x3b, yD - h4 / 2)]),
    ]
    return fig(name, items, pad=0.22)



FIGURES = [
    block_direct1("struct-4-1-block", a=["3/4", "-1/8"], b=["1"]),
    sfg_direct("struct-4-1-sfg", a=["3/4", "-1/8"]),
    block_direct1("struct-4-3-direct1", a=["3/4", "-1/8"], b=["1", "1/3"]),
    block_direct2("struct-4-3-direct2", a=["3/4", "-1/8"], b=["1", "1/3"]),
    block_cascade("struct-4-3-cascade",
                  [["{i:H}_{1}({i:z})", "1 + 1/3 {i:z}^{-1}", "1 - 1/2 {i:z}^{-1}"],
                   ["{i:H}_{2}({i:z})", "1", "1 - 1/4 {i:z}^{-1}"]]),
    block_parallel("struct-4-3-parallel",
                   [["10/3", "1 - 1/2 {i:z}^{-1}"], ["-7/3", "1 - 1/4 {i:z}^{-1}"]]),
    block_direct1("struct-4-4-direct1", a=["-3", "-3", "-1"], b=["-5", "2", "-0.5"]),
    block_direct2("struct-4-4-direct2", a=["-3", "-3", "-1"], b=["-5", "2", "-0.5"]),
    fig_butterfly("fft-butterfly"),
    fig_course_map("course-map"),
]



if __name__ == "__main__":
    import json
    from pathlib import Path
    here = Path(__file__).parent
    (here / "figures.json").write_text(
        json.dumps({"unit_px": 192, "figures": FIGURES}, ensure_ascii=False, indent=1),
        encoding="utf-8")
    for f in FIGURES:
        print("%-24s %3d items  viewbox=%s" % (f["name"], len(f["items"]), f["viewbox"]))
