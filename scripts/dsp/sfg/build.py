# -*- coding: utf-8 -*-
"""DSP 系统结构图（信号流图 / 方框图）的几何数据生成器。

制图规范见同目录 README.md。本文件只负责“结构参数 -> 绝对坐标”，
输出 figures.json，供 SVG 后端（svg.py）与 MATLAB 后端（draw_sfg.m）共用。

坐标：1 数据单位 = 1 英寸；y 轴向下。
"""
from __future__ import annotations

import json
import math
from pathlib import Path

# ---------------- 规范常量 ----------------
STEP = 1.30        # 相邻节点水平间距
NODE_R = 0.060     # 节点半径
BOX_W, BOX_H = 0.66, 0.46
BOX_FILL = "#ffffff"   # 暗色模式由 CSS 反色，这里固定白底
ADD_R = 0.28       # 加法器半径
FB_STEP = 0.30     # 反馈支路层距
FF_STEP = 0.30     # 前馈支路层距
FS_NODE = 0.155    # 节点 / 信号名字高
FS_GAIN = 0.132    # 支路增益字高
FS_BOX = 0.150     # 方框内字高


def rim_x(cx, cy, r, dy):
    """水平线 y=cy+dy 与圆左侧的交点 x。"""
    return cx - math.sqrt(max(r * r - dy * dy, 0.0))


def node(x, y):
    return {"k": "node", "xy": [x, y]}


def branch(pts, arrow=True, cross_ok=False):
    """支路。cross_ok=True 表示该支路允许与其它支路交叉（无连接点的普通交叉）。"""
    it = {"k": "branch", "pts": [[round(x, 4), round(y, 4)] for x, y in pts],
          "arrow": arrow}
    if cross_ok:
        it["cross_ok"] = True
    return it


def runs(s):
    """把内联标记拆成样式片段：[{t: 文本, s: normal|italic|sup|sub}]。

    标记：{i:..} 斜体，^{..} 上标，_{..} 下标。生成阶段一次性解析，
    两个渲染后端都只消费片段，不再各自解析字符串。
    """
    out, i = [], 0
    while i < len(s):
        for tag, style in (("{i:", "ital"), ("^{", "sup"), ("_{", "sub")):
            if s.startswith(tag, i):
                j = s.index("}", i)
                out.append({"t": s[i + len(tag):j], "s": style})
                i = j + 1
                break
        else:
            j = i
            while j < len(s) and not any(s.startswith(t, j)
                                        for t in ("{i:", "^{", "_{")):
                j += 1
            out.append({"t": s[i:j], "s": "normal"})
            i = j
    return out


def label(s, x, y, size=FS_NODE, anchor="middle"):
    return {"k": "label", "runs": runs(s), "xy": [round(x, 4), round(y, 4)],
            "size": size, "anchor": anchor}


def gain(s, x, y):
    return label(s, x, y, FS_GAIN)


def box(cx, cy, lines, w=BOX_W, h=BOX_H, size=FS_BOX):
    return {"k": "box", "c": [round(cx, 4), round(cy, 4)], "wh": [w, h],
            "lines": [runs(ln) for ln in lines], "size": size,
            "rule": 2 if len(lines) == 3 else None}


def hollow_node(x, y, r=NODE_R * 1.25):
    return {"k": "circle0", "xy": [round(x, 4), round(y, 4)], "r": r}


def cross_node(x, y, s=NODE_R * 1.3):
    return {"k": "cross", "xy": [round(x, 4), round(y, 4)], "r": s}


def adder(cx, cy, r=ADD_R):
    return {"k": "adder", "c": [round(cx, 4), round(cy, 4)], "r": r}


def text_width(runs_, size):
    """估算文字宽度（数据单位）：正体按 0.52em，斜体按 0.50em，上下标按 0.62 倍。"""
    w = 0.0
    for r in runs_:
        n = len(r["t"])
        if r["s"] in ("sup", "sub"):
            w += 0.62 * 0.50 * size * n
        elif r["s"] == "ital":
            w += 0.50 * size * n
        else:
            w += 0.52 * size * n
    return w


def fig(name, items, pad=0.30, pad_right=None, pad_top=None, pad_bottom=None):
    """由图元自动求包围盒（含文字区域）；左右上下留白可分别指定。"""
    xs, ys = [], []
    for it in items:
        k = it["k"]
        if k == "node":
            xs.append(it["xy"][0])
            ys.append(it["xy"][1])
        elif k == "label":
            x, y = it["xy"]
            w_, h_ = text_width(it["runs"], it["size"]), it["size"]
            a = it.get("anchor", "middle")
            if a == "start":
                xs += [x, x + w_]
            elif a == "end":
                xs += [x - w_, x]
            else:
                xs += [x - w_ / 2, x + w_ / 2]
            ys += [y - h_ * 0.75, y + h_ * 0.25]
        elif k == "branch":
            xs += [p[0] for p in it["pts"]]
            ys += [p[1] for p in it["pts"]]
        elif k == "box":
            cx, cy = it["c"]
            xs += [cx - it["wh"][0] / 2, cx + it["wh"][0] / 2]
            for ln in it.get("lines", []):
                tw = text_width(ln, it["size"]) / 2
                xs += [cx - tw, cx + tw]
            ys += [cy - it["wh"][1] / 2, cy + it["wh"][1] / 2]
        elif k == "adder":
            cx, cy, r = it["c"][0], it["c"][1], it["r"]
            xs += [cx - r, cx + r]
            ys += [cy - r, cy + r]
    pr = pad if pad_right is None else pad_right
    pt = pad if pad_top is None else pad_top
    pb = pad if pad_bottom is None else pad_bottom
    x0, x1 = min(xs) - pad, max(xs) + pr
    y0, y1 = min(ys) - pt, max(ys) + pb
    return {"name": name,
            "viewbox": [round(x0, 3), round(y0, 3),
                        round(x1 - x0, 3), round(y1 - y0, 3)],
            "items": items}
