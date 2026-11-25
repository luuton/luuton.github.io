% draw_sfg.m —— 按 figures.json 的几何数据重绘 DSP 系统结构图。
%
% 用法（在本目录下）：
%   python figs.py          % 生成 figures.json
%   matlab -batch draw_sfg  % 输出 PNG 到 out/
%
% 说明：几何坐标由 Python 生成，MATLAB 只负责绘制，保证两种后端图形一致。
% 坐标单位 1 = 1 英寸，y 轴向下（已在此处翻转）。

function draw_sfg()
here = fileparts(mfilename('fullpath'));
spec = jsondecode(fileread(fullfile(here, 'figures.json')));
outdir = fullfile(here, 'out');
if ~exist(outdir, 'dir'), mkdir(outdir); end
unit = spec.unit_px;

for k = 1:numel(spec.figures)
    f = spec.figures(k);
    if iscell(f), f = f{1}; end
    vb = f.viewbox;
    W = vb(3) * unit; H = vb(4) * unit;

    fig = figure('Visible', 'off', 'Color', 'w', 'Units', 'pixels', ...
                 'Position', [80 80 W H]);
    ax = axes(fig, 'Position', [0 0 1 1]);
    hold(ax, 'on'); axis(ax, 'off'); axis(ax, 'equal');
    xlim(ax, [vb(1), vb(1) + vb(3)]);
    ylim(ax, [vb(2) + vb(4), vb(2)]);     % y 轴向下
    set(ax, 'Clipping', 'off');

    items = f.items;
    if iscell(items), items = [items{:}]; end
    for i = 1:numel(items)
        it = items(i);
        switch it.k
            case 'node'
                drawNode(ax, it.xy);
            case 'branch'
                drawBranch(ax, it.pts, it.arrow);
            case 'box'
                drawBox(ax, it.c, it.wh, it.lines, it.size);
            case 'adder'
                drawAdder(ax, it.c, it.r);
            case 'label'
                drawLabel(ax, it.xy, it.s, it.size, it.anchor);
        end
    end

    exportgraphics(fig, fullfile(outdir, [f.name '.png']), 'Resolution', 192);
    close(fig);
    fprintf('%s\n', f.name);
end
end

% ---------------------------------------------------------------- 基本图元
function drawNode(ax, xy)
plot(ax, xy(1), xy(2), 'o', 'MarkerSize', 9.6, ...
     'MarkerFaceColor', [0.12 0.14 0.16], 'MarkerEdgeColor', 'none');
end

function drawBranch(ax, pts, arrow)
plot(ax, pts(:, 1), pts(:, 2), '-', 'Color', [0.12 0.14 0.16], 'LineWidth', 1.35);
if arrow
    a = pts(end - 1, :); b = pts(end, :);
    d = b - a; L = norm(d);
    if L > 0
        d = d / L;
        n = [-d(2), d(1)];
        tip = b;
        base = tip - 0.155 * d;
        P = [tip; base + 0.082 * n; base - 0.082 * n];
        patch(ax, P(:, 1), P(:, 2), [0.12 0.14 0.16], 'EdgeColor', 'none');
    end
end
end

function drawBox(ax, c, wh, lines, fs)
w = wh(1); h = wh(2);
rectangle(ax, 'Position', [c(1) - w / 2, c(2) - h / 2, w, h], ...
          'Curvature', 0.06, 'EdgeColor', [0.12 0.14 0.16], ...
          'FaceColor', 'w', 'LineWidth', 1.35);
n = numel(lines);
step = fs * (1.70);
for i = 1:n
    y = c(2) - (i - 1 - (n - 1) / 2) * step;
    drawLabel(ax, [c(1), y], lines{i}, fs, 'middle');
end
if n == 3
    ry = c(2) - (2 - 1 - (n - 1) / 2) * step + 0.055;
    plot(ax, c(1) + w * [-0.36 0.36], [ry ry], '-', ...
         'Color', [0.12 0.14 0.16], 'LineWidth', 1.0);
end
end

function drawAdder(ax, c, r)
rectangle(ax, 'Position', [c(1) - r, c(2) - r, 2 * r, 2 * r], ...
          'Curvature', 1, 'EdgeColor', [0.12 0.14 0.16], ...
          'FaceColor', 'w', 'LineWidth', 1.35);
text(ax, c(1), c(2), '\Sigma', 'FontName', 'Times New Roman', ...
     'FontSize', 13, 'HorizontalAlignment', 'center', ...
     'VerticalAlignment', 'middle', 'Color', [0.12 0.14 0.16]);
end

function drawLabel(ax, xy, s, fs, anchor)
[txt, it] = parseMark(s);
switch anchor
    case 'start', ha = 'left';
    case 'end', ha = 'right';
    otherwise, ha = 'center';
end
h = text(ax, xy(1), xy(2), txt, 'FontName', 'Times New Roman', ...
         'FontSize', fs * 150, 'HorizontalAlignment', ha, ...
         'VerticalAlignment', 'middle', 'Color', [0.12 0.14 0.16], ...
         'Interpreter', 'tex');
if it
    set(h, 'FontAngle', 'italic');
end
end

function [txt, ital] = parseMark(s)
% 把 {i:x} 转成 TeX 斜体，^{..} 转上标，_{..} 转下标。
ital = false;
txt = s;
txt = strrep(txt, '{i:', '{\it ');
while true
    k = strfind(txt, '{\it ');
    if isempty(k), break; end
    e = find(txt(k(1):end) == '}', 1);
    if isempty(e), break; end
    ital = true;
    break;
end
txt = strrep(txt, '^{', '^{');
txt = strrep(txt, '_{', '_{');
end
