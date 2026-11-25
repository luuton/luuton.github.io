# -*- coding: utf-8 -*-
"""几何自检：支路直角化、两两不相交（端点相接除外）、文字不与线段相交。"""
import json
from pathlib import Path


def segs(fig):
    out = []
    for it in fig["items"]:
        if it["k"] != "branch" or it.get("arc") or it.get("cross_ok"):
            continue
        pts = it["pts"]
        for a, b in zip(pts, pts[1:]):
            out.append((a, b))
    return out


def on_seg(p, a, b, eps=1e-6):
    (x, y), (x1, y1), (x2, y2) = p, a, b
    if abs(x1 - x2) < eps:
        return abs(x - x1) < eps and min(y1, y2) - eps <= y <= max(y1, y2) + eps
    if abs(y1 - y2) < eps:
        return abs(y - y1) < eps and min(x1, x2) - eps <= x <= max(x1, x2) + eps
    return False


def prop_cross(a, b, c, d):
    """正交线段内部是否相交（不含共享端点）。"""
    ax1, ay1 = a
    bx1, by1 = b
    cx1, cy1 = c
    dx1, dy1 = d
    vert1 = abs(ax1 - bx1) < 1e-9
    vert2 = abs(cx1 - dx1) < 1e-9
    if vert1 == vert2:
        return False
    if vert1:
        x, ya, yb = ax1, min(ay1, by1), max(ay1, by1)
        y, xa, xb = cy1, min(cx1, dx1), max(cx1, dx1)
    else:
        x, ya, yb = cx1, min(cy1, dy1), max(cy1, dy1)
        y, xa, xb = ay1, min(ax1, bx1), max(ax1, bx1)
    return xa + 1e-6 < x < xb - 1e-6 and ya + 1e-6 < y < yb - 1e-6


def main():
    here = Path(__file__).parent
    spec = json.loads((here / "figures.json").read_text(encoding="utf-8"))
    bad = 0
    for fig in spec["figures"]:
        segs_ = segs(fig)
        issues = []
        for a, b in segs_:
            if abs(a[0] - b[0]) > 1e-9 and abs(a[1] - b[1]) > 1e-9:
                short = abs(a[0] - b[0]) < 0.06 and abs(a[1] - b[1]) < 0.06
                if not short:
                    issues.append("斜线 %s-%s" % (a, b))
        for i in range(len(segs_)):
            for j in range(i + 1, len(segs_)):
                if prop_cross(*segs_[i], *segs_[j]):
                    issues.append("交叉 %s-%s x %s-%s" % (*segs_[i], *segs_[j]))
        for it in fig["items"]:
            if it["k"] != "label":
                continue
            x, y = it["xy"]
            for a, b in segs_:
                if on_seg((x, y + 0.02), a, b):
                    txt = "".join(r["t"] for r in it.get("runs", []))
                    issues.append("文字压线 %r @%s" % (txt, (round(x, 2), round(y, 2))))
                    break
        boxes = [(it["c"], it["wh"]) for it in fig["items"] if it["k"] == "box"]
        for i in range(len(boxes)):
            for j in range(i + 1, len(boxes)):
                (c1, w1), (c2, w2) = boxes[i], boxes[j]
                if (abs(c1[0] - c2[0]) < (w1[0] + w2[0]) / 2 - 1e-6
                        and abs(c1[1] - c2[1]) < (w1[1] + w2[1]) / 2 - 1e-6):
                    issues.append("方框重叠 %s %s" % (c1, c2))

        # 支路不得穿过方框内部
        for it in fig["items"]:
            if it["k"] != "box":
                continue
            (cx, cy), (bw, bh) = it["c"], it["wh"]
            for a, b in segs_:
                for t in (0.2, 0.5, 0.8):
                    px = a[0] + (b[0] - a[0]) * t
                    py = a[1] + (b[1] - a[1]) * t
                    if (abs(px - cx) < bw / 2 - 0.02
                            and abs(py - cy) < bh / 2 - 0.02):
                        issues.append("穿框 (%s,%s) 在 %s" %
                                      (round(px, 2), round(py, 2), (round(cx, 2), round(cy, 2))))
                        break

        if issues:
            bad += len(issues)
            print("== %s: %d 项" % (fig["name"], len(issues)))
            for s in issues[:8]:
                print("   ", s)
    print("总计", bad, "项")


if __name__ == "__main__":
    main()
