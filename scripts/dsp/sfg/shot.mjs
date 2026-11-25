// 把 out/*.svg 用无头 Edge 渲染成 PNG，便于本地校对（不参与构建）。
import { execFileSync } from "node:child_process";
import { mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const EDGE = "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe";
const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1"));
const out = path.join(here, "out");
if (!readdirSync(here).includes("out")) {
  console.error("先运行 python svg.py 生成 out/*.svg");
  process.exit(1);
}
mkdirSync(out, { recursive: true });

for (const f of readdirSync(out).filter((x) => x.endsWith(".svg"))) {
  const svg = readFileSync(path.join(out, f), "utf8");
  const m = /width="(\d+)" height="(\d+)"/.exec(svg);
  const [w, h] = [Number(m[1]), Number(m[2])];
  const html = `<!doctype html><meta charset="utf-8">
<style>html,body{margin:0;background:#fff}svg{display:block}</style>${svg}`;
  const hp = path.join(out, f.replace(/\.svg$/, ".html"));
  writeFileSync(hp, html);
  execFileSync(EDGE, ["--headless=new", "--disable-gpu", "--hide-scrollbars",
    `--window-size=${w},${h}`,
    `--screenshot=${path.join(out, f.replace(/\.svg$/, ".png"))}`,
    pathToFileURL(hp).href], { stdio: "ignore" });
  console.log(f, w, h);
}
