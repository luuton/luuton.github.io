# -*- coding: utf-8 -*-
"""figures.json -> SVG。文案以样式片段（runs）给出，无需再解析标记。"""
from __future__ import annotations

import html
import json
from pathlib import Path

INK = "#000000"          # 纯黑；暗色模式由 CSS 反色（见 markdown.css）
BG = "none"
FONT = "'Times New Roman','Cambria Math','STIX Two Text',serif"
NODE_R = 0.060
LW = 0.017

SHIFT = {"ital": (0.0, None), "sup": (-0.34, 0.62), "sub": (0.20, 0.62)}


def esc(t: str) -> str:
    return html.escape(t, quote=True)


def spans(runs):
    out = []
    for r in runs:
        st, txt = r["s"], esc(r["t"])
        if st == "ital":
            out.append('<tspan font-style="italic">%s</tspan>' % txt)
        elif st in ("sup", "sub"):
            dy, scale = SHIFT[st]
            out.append('<tspan dy="%.2fem" font-size="%.2fem">%s</tspan>'
                       '<tspan dy="%.2fem">\u200b</tspan>'
                       % (dy, scale, txt, -dy))
        else:
            out.append(txt)
    return "".join(out)


def text(x, y, runs, size, anchor="middle"):
    return ('<text x="%.3f" y="%.3f" font-family="%s" font-size="%.3f" fill="%s" '
            'text-anchor="%s">%s</text>'
            % (x, y, FONT, size, INK, anchor, spans(runs)))


def render(fig, unit):
    x0, y0, w, h = fig["viewbox"]
    out = ['<svg xmlns="http://www.w3.org/2000/svg" width="%.0f" height="%.0f" '
           'viewBox="%s %s %s %s">' % (w * unit, h * unit, x0, y0, w, h),
           '<defs><marker id="a" viewBox="0 0 12 12" refX="10.4" refY="6" '
           'markerWidth="0.155" markerHeight="0.082" markerUnits="userSpaceOnUse" '
           'orient="auto-start-reverse"><path d="M 0,1.3 L 12,6 L 0,10.7 Z" fill="%s"/>'
           '</marker></defs>' % INK]
    for it in fig["items"]:
        k = it["k"]
        if k == "node":
            x, y = it["xy"]
            out.append('<circle cx="%.3f" cy="%.3f" r="%.3f" fill="%s"/>'
                       % (x, y, NODE_R, INK))
        elif k == "branch":
            pts = it["pts"]
            d = "M %.3f,%.3f" % (pts[0][0], pts[0][1]) + "".join(
                " L %.3f,%.3f" % (p[0], p[1]) for p in pts[1:])
            m = ' marker-end="url(#a)"' if it.get("arrow", True) else ""
            out.append('<path d="%s" fill="none" stroke="%s" stroke-width="%.3f" '
                       'stroke-linejoin="miter" stroke-linecap="butt"%s/>'
                       % (d, INK, LW, m))
        elif k == "box":
            cx, cy = it["c"]
            bw, bh = it["wh"]
            out.append('<rect x="%.3f" y="%.3f" width="%.3f" height="%.3f" rx="0.05" '
                       'fill="none" stroke="%s" stroke-width="%.3f"/>'
                       % (cx - bw / 2, cy - bh / 2, bw, bh, INK, LW))
            n = len(it["lines"])
            step = it["size"] * (1.70 if n >= 3 else 1.55)
            for i, ln in enumerate(it["lines"]):
                dy = (i - (n - 1) / 2) * step
                out.append(text(cx, cy + it["size"] * 0.36 + dy, ln, it["size"]))
            if it.get("rule") is not None:
                k2 = it["rule"]
                ry = cy + (k2 - (n - 1) / 2) * step + 0.055
                out.append('<path d="M %.3f,%.3f L %.3f,%.3f" stroke="%s" '
                           'stroke-width="%.3f"/>'
                           % (cx - bw * 0.36, ry, cx + bw * 0.36, ry, INK, LW * 0.75))
        elif k == "circle0":
            x, y = it["xy"]
            r = it.get("r", NODE_R * 1.25)
            out.append('<circle cx="%.3f" cy="%.3f" r="%.3f" fill="none" stroke="%s" '
                       'stroke-width="%.3f"/>' % (x, y, r, INK, LW))
        elif k == "cross":
            x, y = it["xy"]
            s = it.get("r", NODE_R * 1.3)
            out.append('<path d="M %.3f,%.3f L %.3f,%.3f M %.3f,%.3f L %.3f,%.3f" '
                       'stroke="%s" stroke-width="%.3f"/>'
                       % (x - s, y - s, x + s, y + s, x - s, y + s, x + s, y - s, INK, LW))
        elif k == "adder":
            cx, cy, r = it["c"][0], it["c"][1], it["r"]
            out.append('<circle cx="%.3f" cy="%.3f" r="%.3f" fill="none" stroke="%s" '
                       'stroke-width="%.3f"/>' % (cx, cy, r, INK, LW))
            out.append(text(cx, cy + 0.075, [{"t": "Σ", "s": "normal"}], 0.24))
        elif k == "label":
            x, y = it["xy"]
            out.append(text(x, y, it["runs"], it["size"], it.get("anchor", "middle")))
    out.append("</svg>")
    return "\n".join(out)


def main():
    here = Path(__file__).parent
    spec = json.loads((here / "figures.json").read_text(encoding="utf-8"))
    out = here / "out"
    out.mkdir(exist_ok=True)
    for f in spec["figures"]:
        (out / (f["name"] + ".svg")).write_text(render(f, spec["unit_px"]),
                                                encoding="utf-8")
        print(f["name"])


if __name__ == "__main__":
    main()
