% redraw_computer_network_diagrams.m
% 使用 MATLAB 重绘《计算机网络》知识点整理中的流程图与时序图。
% 运行方式（仓库根目录）：
%   matlab -batch "run('scripts/matlab/redraw_computer_network_diagrams.m')"
% 输出目录：public/images/computer-network/
% 生成 PNG 后执行以下命令转换为 WebP 并清理 PNG：
%   node scripts/convert-webp.mjs

clear; close all;

scriptDir = fileparts(mfilename('fullpath'));
ROOT = fileparts(fileparts(scriptDir));
OUTDIR = fullfile(ROOT, 'public', 'images', 'computer-network');
if ~exist(OUTDIR, 'dir'), mkdir(OUTDIR); end

S = style();

%% 1. 知识地图（自底向上）
W = 10; H = 13;
[fig, ax] = newCanvas(W, H, S);
ys = [11.1 9.0 6.9 4.8 2.7];
titles = {'应用层：网络应用', '传输层：进程到进程', ...
          '网络层：主机到主机、网络互联', '数据链路层：相邻节点之间传输帧', ...
          '物理层：在物理链路上传输原始比特'};
details = {'HTTP、DNS、SMTP、FTP', 'TCP、UDP', ...
           'IP、ICMP、ARP、路由协议', '成帧、差错检测、可靠传输、MAC', ...
           '媒质、编码、调制'};
faces = {[1.000 0.949 0.878], [0.910 0.949 0.988], [0.902 0.961 0.925], ...
         [0.988 0.965 0.886], [0.945 0.914 0.976]};
edges = {[0.780 0.520 0.180], [0.300 0.520 0.720], [0.250 0.550 0.320], ...
         [0.650 0.550 0.200], [0.480 0.350 0.650]};
for i = 1:5
    drawLayerBox(ax, S, 5, ys(i), 7.8, 1.45, titles{i}, details{i}, faces{i}, edges{i});
    if i < 5
        drawArrow(ax, S, [5, ys(i)-0.725], [5, ys(i+1)+0.725]);
    end
end
saveFig(fig, OUTDIR, '01-knowledge-map');

%% 2. 逐层封装
W = 16.8; H = 5.4; cy = 3.0;
[fig, ax] = newCanvas(W, H, S);
xs = [1.6 4.5 7.9 12.0 15.2];
ws = [2.4 2.8 3.4 4.0 2.0];
texts = {{'应用数据 M'}, {'Ht ｜ M', '报文段 segment'}, ...
         {'Hn ｜ Ht ｜ M', '数据报 datagram'}, ...
         {'Hl ｜ Hn ｜ Ht ｜ M', '帧 frame'}, {'比特流'}};
faces = {[0.945 0.914 0.976], [0.910 0.949 0.988], [0.902 0.961 0.925], ...
         [1.000 0.949 0.878], [0.988 0.965 0.886]};
edges = {[0.480 0.350 0.650], [0.300 0.520 0.720], [0.250 0.550 0.320], ...
         [0.780 0.520 0.180], [0.650 0.550 0.200]};
for i = 1:5
    h = 1.15; if numel(texts{i}) > 1, h = 1.35; end
    drawBox(ax, S, xs(i), cy, ws(i), h, texts{i}, 'process', faces{i}, edges{i});
    if i < 5
        drawArrow(ax, S, [xs(i)+ws(i)/2, cy], [xs(i+1)-ws(i+1)/2, cy]);
    end
end
saveFig(fig, OUTDIR, '02-encapsulation');

%% 3. CSMA/CD 流程图
W = 10.8; H = 16.0;
[fig, ax] = newCanvas(W, H, S);
drawBox(ax, S, 6.5, 15.0, 3.0, 1.0, {'有帧要发送'}, 'terminal');
drawDiamond(ax, S, 6.5, 13.0, 3.2, 1.5, {'侦听信道'});
drawBox(ax, S, 6.5, 11.0, 3.6, 1.2, {'立即发送帧'}, 'process');
drawBox(ax, S, 2.5, 13.0, 3.2, 1.2, {'等候直至', '信道空闲'}, 'process');
drawDiamond(ax, S, 6.5, 9.0, 3.6, 1.5, {'发送中检测到冲突?'});
drawBox(ax, S, 6.5, 7.0, 2.6, 1.2, {'发送完成'}, 'terminal');
drawBox(ax, S, 2.5, 7.0, 4.0, 1.4, {'发送 32 bit 干扰信号', '（连同 64 bit 前导码共 96 bit）'}, 'process');
drawBox(ax, S, 2.5, 5.0, 3.2, 1.2, {'停止发送，进入指数回退'}, 'process');
drawDiamond(ax, S, 2.5, 3.0, 3.2, 1.5, {'重试次数 < 16?'});
drawBox(ax, S, 6.5, 1.0, 3.2, 1.2, {'放弃发送，', '向上层报告'}, 'terminal');
drawArrow(ax, S, [6.5 14.5], [6.5 13.75]);
drawArrow(ax, S, [6.5 12.25], [6.5 11.6]);
drawArrow(ax, S, [4.9 13.0], [4.1 13.0]);
drawPolyArrow(ax, S, [2.5 12.4; 2.5 11.0; 4.7 11.0]);
drawArrow(ax, S, [6.5 10.4], [6.5 9.75]);
drawArrow(ax, S, [6.5 8.25], [6.5 7.6]);
drawPolyArrow(ax, S, [4.7 9.0; 2.5 9.0; 2.5 7.7]);
drawArrow(ax, S, [2.5 6.3], [2.5 5.6]);
drawArrow(ax, S, [2.5 4.4], [2.5 3.75]);
drawPolyArrow(ax, S, [4.1 3.0; 9.6 3.0; 9.6 13.0; 8.1 13.0]);
drawPolyArrow(ax, S, [2.5 2.25; 2.5 1.0; 4.9 1.0]);
label(ax, S, 6.75, 11.9, '空闲', 'left');
label(ax, S, 4.5, 13.25, '忙', 'center');
label(ax, S, 6.75, 8.0, '否', 'left');
label(ax, S, 3.6, 9.2, '是', 'center');
label(ax, S, 8.9, 13.2, '是', 'center');
label(ax, S, 3.4, 1.2, '否', 'center');
saveFig(fig, OUTDIR, '03-csma-cd');
%% 4. CSMA/CA 流程图
W = 15.6; H = 12.0;
[fig, ax] = newCanvas(W, H, S);
drawBox(ax, S, 9.2, 11.0, 3.0, 1.0, {'有帧要发送'}, 'terminal');
drawDiamond(ax, S, 9.2, 9.0, 3.2, 1.5, {'侦听信道空闲 DIFS?'});
drawBox(ax, S, 9.2, 7.0, 3.6, 1.2, {'发送整个帧（不做冲突检测）'}, 'process');
drawBox(ax, S, 2.3, 9.0, 3.0, 1.2, {'启动随机回退定时器'}, 'process');
drawDiamond(ax, S, 2.3, 7.0, 2.8, 1.5, {'信道空闲?'});
drawBox(ax, S, 5.7, 7.0, 2.2, 1.1, {'定时器暂停'}, 'process');
drawBox(ax, S, 2.3, 5.0, 3.0, 1.1, {'定时器计时'}, 'process');
drawDiamond(ax, S, 2.3, 3.0, 2.8, 1.5, {'定时器到期?'});
drawDiamond(ax, S, 9.2, 5.0, 3.2, 1.5, {'收到 ACK?'});
drawBox(ax, S, 13.2, 5.0, 3.2, 1.2, {'若有后续帧，', '返回回退步骤'}, 'process');
drawBox(ax, S, 2.3, 1.0, 3.0, 1.2, {'扩大回退范围', '（指数回退），重试'}, 'process');
drawArrow(ax, S, [9.2 10.5], [9.2 9.75]);
drawArrow(ax, S, [9.2 8.25], [9.2 7.6]);
drawArrow(ax, S, [7.6 9.0], [3.8 9.0]);
drawArrow(ax, S, [2.3 8.4], [2.3 7.75]);
drawArrow(ax, S, [2.3 6.25], [2.3 5.55]);
drawArrow(ax, S, [2.3 4.45], [2.3 3.75]);
drawArrow(ax, S, [3.42 7.15], [4.6 7.15]);
drawArrow(ax, S, [4.6 6.85], [3.42 6.85]);
drawPolyArrow(ax, S, [0.8 3.0; 0.6 3.0; 0.6 7.0; 0.8 7.0]);
drawPolyArrow(ax, S, [3.7 3.0; 7.0 3.0; 7.0 7.0; 7.4 7.0]);
drawArrow(ax, S, [9.2 6.4], [9.2 5.75]);
drawArrow(ax, S, [10.8 5.0], [11.6 5.0]);
drawPolyArrow(ax, S, [9.2 4.25; 9.2 1.0; 3.8 1.0]);
drawPolyArrow(ax, S, [0.8 1.0; 0.3 1.0; 0.3 9.0; 0.8 9.0]);
label(ax, S, 9.45, 7.9, '是', 'left');
label(ax, S, 5.7, 9.25, '否', 'center');
label(ax, S, 4.0, 7.38, '否', 'center');
label(ax, S, 0.68, 5.0, '否', 'center');
label(ax, S, 7.15, 6.2, '是', 'left');
label(ax, S, 11.2, 5.25, '是', 'center');
label(ax, S, 6.5, 1.25, '否', 'center');
saveFig(fig, OUTDIR, '04-csma-ca');
fprintf('前 4 张图完成。\n');


%% 5. 生成树（有环拓扑 -> 生成树）
W = 14.4; H = 7.2;
[fig, ax] = newCanvas(W, H, S);
drawGroupBox(ax, S, 3.3, 3.2, 6.0, 5.2, '有环拓扑');
drawGroupBox(ax, S, 11.1, 3.2, 6.0, 5.2, '生成树');
drawLine(ax, S, [1.4 4.4], [3.3 4.4]);
drawLine(ax, S, [3.3 4.4], [5.2 4.4]);
drawLine(ax, S, [3.3 4.4], [3.3 2.2]);
drawLine(ax, S, [3.3 2.2], [5.2 2.2]);
drawLine(ax, S, [5.2 4.4], [3.3 2.2]);
drawLine(ax, S, [9.2 4.4], [11.1 4.4]);
drawLine(ax, S, [11.1 4.4], [13.0 4.4]);
drawLine(ax, S, [11.1 4.4], [11.1 2.2]);
drawLine(ax, S, [11.1 2.2], [13.0 2.2]);
plot(ax, [13.0 11.1], [4.4 2.2], '--', 'Color', [0.80 0.25 0.25], 'LineWidth', 1.2);
drawNode(ax, S, 1.4, 4.4, 0.38, 'A');
drawNode(ax, S, 3.3, 4.4, 0.38, 'B1');
drawNode(ax, S, 5.2, 4.4, 0.38, 'C');
drawNode(ax, S, 3.3, 2.2, 0.38, 'B2');
drawNode(ax, S, 5.2, 2.2, 0.38, 'D');
drawNode(ax, S, 9.2, 4.4, 0.38, 'A');
drawNode(ax, S, 11.1, 4.4, 0.38, 'B1');
drawNode(ax, S, 13.0, 4.4, 0.38, 'C');
drawNode(ax, S, 11.1, 2.2, 0.38, 'B2');
drawNode(ax, S, 13.0, 2.2, 0.38, 'D');
text(ax, 12.05, 3.3, '×', 'FontName', S.font, 'FontSize', 17, ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
     'Color', [0.80 0.20 0.20]);
text(ax, 12.35, 2.95, '删除环路边', 'FontName', S.font, 'FontSize', 9.5, ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
     'Color', [0.70 0.18 0.18]);
saveFig(fig, OUTDIR, '05-spanning-tree');

%% 6. NAT 地址转换
W = 13.5; H = 8.0;
[fig, ax] = newCanvas(W, H, S);
drawBox(ax, S, 2.2, 5.0, 3.4, 1.5, {'内部主机', '10.0.0.1:3345'}, 'process', ...
        [0.914 0.957 0.918], [0.302 0.549 0.294]);
drawBox(ax, S, 6.75, 5.0, 3.6, 1.6, {'NAT 路由器', '公网 138.76.29.7'}, 'process', ...
        [1.000 0.949 0.878], [0.780 0.520 0.180]);
drawBox(ax, S, 11.3, 5.0, 3.8, 1.6, {'外网服务器', '128.119.40.186:80'}, 'process', ...
        [0.910 0.949 0.988], [0.300 0.520 0.720]);
drawPolyArrow(ax, S, [2.2 5.75; 2.2 6.5; 6.4 6.5; 6.4 5.8]);
drawPolyArrow(ax, S, [7.1 5.8; 7.1 7.2; 11.3 7.2; 11.3 5.8]);
drawPolyArrow(ax, S, [11.3 4.2; 11.3 3.4; 6.4 3.4; 6.4 4.2]);
drawPolyArrow(ax, S, [7.1 4.2; 7.1 2.7; 2.2 2.7; 2.2 4.25]);
label(ax, S, 4.45, 6.75, '源地址 10.0.0.1:3345', 'center');
label(ax, S, 9.0, 7.45, '源地址改为 138.76.29.7:5001', 'center');
label(ax, S, 9.0, 3.15, '目的地址 138.76.29.7:5001', 'center');
label(ax, S, 4.45, 2.45, '查 NAT 表，改回 10.0.0.1:3345', 'center');
saveFig(fig, OUTDIR, '06-nat');

%% 7. 路由算法示例图
W = 10.5; H = 7.5;
[fig, ax] = newCanvas(W, H, S);
drawLine(ax, S, [1.6 5.0], [4.9 6.1]);
drawLine(ax, S, [1.6 5.0], [4.9 3.8]);
drawLine(ax, S, [4.9 6.1], [4.9 3.8]);
drawLine(ax, S, [4.9 6.1], [8.4 4.9]);
drawLine(ax, S, [4.9 3.8], [8.4 4.9]);
drawNode(ax, S, 1.6, 5.0, 0.42, 'A');
drawNode(ax, S, 4.9, 6.1, 0.42, 'B');
drawNode(ax, S, 4.9, 3.8, 0.42, 'C');
drawNode(ax, S, 8.4, 4.9, 0.42, 'D', [1.000 0.949 0.878], [0.823 0.529 0.208]);
label(ax, S, 3.1, 5.58, '5', 'center');
label(ax, S, 3.1, 4.35, '10', 'center');
label(ax, S, 4.45, 4.95, '3', 'center');
label(ax, S, 6.7, 5.55, '11', 'center');
label(ax, S, 6.7, 4.3, '2', 'center');
text(ax, 8.4, 5.62, '源点 D', 'FontName', S.font, 'FontSize', 10, ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
     'Color', [0.60 0.35 0.10]);
saveFig(fig, OUTDIR, '07-routing-graph');

%% 8. TCP 三次握手
W = 11.5; H = 10.0;
[fig, ax] = newCanvas(W, H, S);
drawParticipant(ax, S, 2.4, 9.2, '客户机', 2.6, 0.7);
drawParticipant(ax, S, 7.2, 9.2, '服务器', 2.6, 0.7);
drawActivation(ax, S, 2.4, 7.45, 4.0);
drawActivation(ax, S, 7.2, 7.45, 5.6);
drawNoteBox(ax, S, 1.4, 8.2, 8.5, {'三次握手'});
drawMessage(ax, S, 2.4, 7.2, 7.4, 'SYN=1, Seq=x', 'solid');
drawNoteBox(ax, S, 7.65, 11.0, 6.6, {'服务器处于 LISTEN，', '选择初始序号 y'});
drawMessage(ax, S, 7.2, 2.4, 5.8, 'SYN=1, ACK=1, Seq=y, Ack=x+1', 'solid');
drawMessage(ax, S, 2.4, 7.2, 4.4, 'ACK=1, Seq=x+1, Ack=y+1', 'solid');
drawNoteBox(ax, S, 1.4, 8.2, 3.4, {'连接建立（ESTABLISHED）', '第三个报文段可携带数据'});
saveFig(fig, OUTDIR, '08-tcp-handshake');

%% 9. TCP 四次挥手
W = 11.5; H = 10.2;
[fig, ax] = newCanvas(W, H, S);
drawParticipant(ax, S, 2.4, 9.2, '主动关闭方', 2.8, 0.7);
drawParticipant(ax, S, 7.0, 9.2, '被动关闭方', 2.8, 0.7);
drawActivation(ax, S, 2.4, 7.55, 3.6);
drawActivation(ax, S, 7.0, 7.55, 4.6);
drawNoteBox(ax, S, 1.3, 8.1, 8.5, {'两个方向分别关闭'});
drawMessage(ax, S, 2.4, 7.0, 7.5, 'FIN=1, Seq=x', 'solid');
drawMessage(ax, S, 7.0, 2.4, 6.6, 'ACK=1, Ack=x+1', 'solid');
drawNoteBox(ax, S, 7.45, 11.0, 5.8, {'半关闭：服务器仍可发送数据'});
drawMessage(ax, S, 7.0, 2.4, 4.9, 'FIN=1, Seq=y', 'solid');
drawMessage(ax, S, 2.4, 7.0, 4.0, 'ACK=1, Ack=y+1', 'solid');
drawNoteBox(ax, S, 1.0, 3.8, 3.1, {'TIME_WAIT，等待 2MSL'});
saveFig(fig, OUTDIR, '09-tcp-four-way-close');

%% 10. DNS 迭代查询
W = 15.2; H = 11.0;
[fig, ax] = newCanvas(W, H, S);
xs = [1.5 4.4 7.3 10.2 13.1];
drawParticipant(ax, S, xs(1), 10.0, '请求主机', 2.4, 1.3);
drawParticipant(ax, S, xs(2), 10.0, '本地DNS', 2.4, 1.3);
drawParticipant(ax, S, xs(3), 10.0, '根DNS', 2.2, 1.3);
drawParticipant(ax, S, xs(4), 10.0, 'TLD DNS', 2.4, 1.3);
drawParticipant(ax, S, xs(5), 10.0, '授权DNS', 2.4, 1.3);
drawNoteBox(ax, S, 0.7, 13.9, 9.2, {'迭代式（Iterative）'});
drawMessage(ax, S, xs(1), xs(2), 8.1, '查询 gaia.cs.umass.edu', 'solid');
drawMessage(ax, S, xs(2), xs(3), 7.3, '查询', 'solid');
drawMessage(ax, S, xs(3), xs(2), 6.5, '指向 edu TLD', 'dashed');
drawMessage(ax, S, xs(2), xs(4), 5.7, '查询', 'solid');
drawMessage(ax, S, xs(4), xs(2), 4.9, '指向 umass.edu 授权DNS', 'dashed');
drawMessage(ax, S, xs(2), xs(5), 4.1, '查询', 'solid');
drawMessage(ax, S, xs(5), xs(2), 3.3, '返回 IP', 'dashed');
drawMessage(ax, S, xs(2), xs(1), 2.5, '返回 IP', 'dashed');
saveFig(fig, OUTDIR, '10-dns-iterative');

%% 11. DNS 递归查询
W = 15.2; H = 11.0;
[fig, ax] = newCanvas(W, H, S);
xs = [1.5 4.4 7.3 10.2 13.1];
drawParticipant(ax, S, xs(1), 10.0, '请求主机', 2.4, 1.3);
drawParticipant(ax, S, xs(2), 10.0, '本地DNS', 2.4, 1.3);
drawParticipant(ax, S, xs(3), 10.0, '根DNS', 2.2, 1.3);
drawParticipant(ax, S, xs(4), 10.0, 'TLD DNS', 2.4, 1.3);
drawParticipant(ax, S, xs(5), 10.0, '授权DNS', 2.4, 1.3);
drawNoteBox(ax, S, 0.7, 13.9, 9.2, {'递归式（Recursive）'});
drawMessage(ax, S, xs(1), xs(2), 8.1, '查询 gaia.cs.umass.edu', 'solid');
drawMessage(ax, S, xs(2), xs(3), 7.3, {'查询', '（请求代为完成）'}, 'solid');
drawMessage(ax, S, xs(3), xs(4), 6.5, '查询', 'solid');
drawMessage(ax, S, xs(4), xs(5), 5.7, '查询', 'solid');
drawMessage(ax, S, xs(5), xs(4), 4.9, '返回 IP', 'dashed');
drawMessage(ax, S, xs(4), xs(3), 4.1, '返回 IP', 'dashed');
drawMessage(ax, S, xs(3), xs(2), 3.3, '返回 IP', 'dashed');
drawMessage(ax, S, xs(2), xs(1), 2.5, '返回 IP', 'dashed');
saveFig(fig, OUTDIR, '11-dns-recursive');

%% 12. HTTP 非坚持式
W = 10.8; H = 9.8;
[fig, ax] = newCanvas(W, H, S);
drawParticipant(ax, S, 2.5, 9.0, '浏览器', 2.4, 0.8);
drawParticipant(ax, S, 7.5, 9.0, 'Web服务器', 2.6, 0.8);
drawActivation(ax, S, 2.5, 7.35, 5.45);
drawActivation(ax, S, 7.5, 7.35, 5.45);
drawNoteBox(ax, S, 1.2, 8.8, 8.3, {'非坚持式：每个对象 2 RTT'});
drawMessage(ax, S, 2.5, 7.5, 7.3, '建立 TCP 连接（1 RTT）', 'solid');
drawMessage(ax, S, 2.5, 7.5, 6.5, 'HTTP 请求', 'solid');
drawMessage(ax, S, 7.5, 2.5, 5.7, 'HTTP 响应 + 对象（1 RTT）', 'dashed');
drawNoteBox(ax, S, 1.0, 9.0, 4.6, {'关闭连接；下一个对象重复上述过程'});
saveFig(fig, OUTDIR, '12-http-nonpersistent');

%% 13. HTTP 坚持式 + 流水线
W = 10.8; H = 10.8;
[fig, ax] = newCanvas(W, H, S);
drawParticipant(ax, S, 2.5, 9.8, '浏览器', 2.4, 0.9);
drawParticipant(ax, S, 7.5, 9.8, 'Web服务器', 2.6, 0.9);
drawActivation(ax, S, 2.5, 8.05, 4.35);
drawActivation(ax, S, 7.5, 8.05, 4.35);
drawNoteBox(ax, S, 1.4, 8.6, 9.0, {'坚持式 + 流水线'});
drawMessage(ax, S, 2.5, 7.5, 8.0, '建立 TCP 连接（1 RTT）', 'solid');
drawMessage(ax, S, 2.5, 7.5, 7.2, '请求基础 HTML', 'solid');
drawMessage(ax, S, 7.5, 2.5, 6.4, '响应 + 基础 HTML（1 RTT）', 'dashed');
drawMessage(ax, S, 2.5, 7.5, 5.5, '连续请求所有引用对象', 'solid');
drawMessage(ax, S, 7.5, 2.5, 4.6, '连续返回所有对象（共用 1 RTT）', 'dashed');
drawNoteBox(ax, S, 1.0, 9.0, 3.5, {'连接保持，后续对象复用同一 TCP 连接'});
saveFig(fig, OUTDIR, '13-http-persistent');
%% 14. TCP 状态转换图
W = 18.2; H = 17.8;
[fig, ax] = newCanvas(W, H, S);
% 状态框
drawBox(ax, S, 2.0, 15.0, 3.4, 1.2, {'CLOSED'}, 'process', [0.940 0.940 0.950], [0.500 0.500 0.550]);
drawBox(ax, S, 2.0, 12.0, 3.4, 1.2, {'LISTEN'}, 'process', [0.910 0.950 0.990], [0.300 0.500 0.720]);
drawBox(ax, S, 6.5, 15.0, 3.4, 1.2, {'SYN_SENT'}, 'process', [0.910 0.950 0.990], [0.300 0.500 0.720]);
drawBox(ax, S, 6.5, 12.0, 3.4, 1.2, {'SYN_RCVD'}, 'process', [0.910 0.950 0.990], [0.300 0.500 0.720]);
drawBox(ax, S, 11.0, 12.0, 3.4, 1.2, {'ESTABLISHED'}, 'process', [0.900 0.960 0.920], [0.250 0.550 0.320]);
drawBox(ax, S, 11.0, 9.0, 3.4, 1.2, {'FIN_WAIT_1'}, 'process', [1.000 0.950 0.880], [0.780 0.520 0.180]);
drawBox(ax, S, 11.0, 6.0, 3.4, 1.2, {'CLOSE_WAIT'}, 'process', [1.000 0.950 0.880], [0.780 0.520 0.180]);
drawBox(ax, S, 15.5, 12.0, 3.4, 1.2, {'FIN_WAIT_2'}, 'process', [1.000 0.950 0.880], [0.780 0.520 0.180]);
drawBox(ax, S, 15.5, 9.0, 3.4, 1.2, {'TIME_WAIT'}, 'process', [1.000 0.980 0.860], [0.750 0.650 0.200]);
drawBox(ax, S, 15.5, 6.0, 3.4, 1.2, {'LAST_ACK'}, 'process', [1.000 0.950 0.880], [0.780 0.520 0.180]);
% 初始状态
plot(ax, 1.2, 16.5, 'o', 'MarkerFaceColor', S.arrow, 'MarkerEdgeColor', S.arrow, 'MarkerSize', 8);
drawArrow(ax, S, [1.2 16.35], [1.2 15.6]);
% 状态转换
drawArrow(ax, S, [2.0 14.4], [2.0 12.6]);
drawArrow(ax, S, [3.7 15.0], [4.8 15.0]);
drawArrow(ax, S, [3.7 12.0], [4.8 12.0]);
drawPolyArrow(ax, S, [8.2 15.0; 9.0 15.0; 9.0 12.6; 11.0 12.6]);
drawArrow(ax, S, [8.2 12.0], [9.3 12.0]);
drawArrow(ax, S, [11.0 11.4], [11.0 9.6]);
drawPolyArrow(ax, S, [9.3 11.45; 8.5 11.45; 8.5 6.0; 9.3 6.0]);
drawPolyArrow(ax, S, [11.0 8.4; 11.0 7.5; 13.6 7.5; 13.6 12.0; 13.8 12.0]);
drawArrow(ax, S, [15.5 11.4], [15.5 9.6]);
drawPolyArrow(ax, S, [17.2 9.0; 17.5 9.0; 17.5 16.5; 2.8 16.5; 2.8 15.6]);
drawArrow(ax, S, [12.7 6.0], [13.8 6.0]);
drawPolyArrow(ax, S, [15.5 5.4; 15.5 1.5; 0.1 1.5; 0.1 15.0; 0.3 15.0]);
% 转换条件
label(ax, S, 2.25, 13.5, '被动打开', 'left');
label(ax, S, 4.25, 14.75, '主动打开/发 SYN', 'center');
label(ax, S, 4.25, 11.65, {'收 SYN', '发 SYNACK'}, 'center');
label(ax, S, 10.0, 13.0, {'收 SYNACK', '发 ACK'}, 'center');
label(ax, S, 8.75, 11.75, '收 ACK', 'center');
label(ax, S, 11.25, 10.5, '关闭/发 FIN', 'left');
label(ax, S, 8.4, 9.0, {'收 FIN', '发 ACK'}, 'right');
label(ax, S, 12.4, 7.75, '收 ACK', 'center');
label(ax, S, 15.75, 10.5, '收 FIN/发 ACK', 'left');
label(ax, S, 10.0, 16.7, '2MSL 超时', 'center');
label(ax, S, 13.25, 6.3, {'关闭', '发 FIN'}, 'center');
label(ax, S, 8.0, 1.7, '收 ACK', 'center');
saveFig(fig, OUTDIR, '14-tcp-state-machine');

%% 15. cwnd 变化示意：超时 vs 3 个重复 ACK
fig = figure('Visible', 'off', 'Color', 'w', 'Units', 'inches', 'Position', [1 1 10 6.5]);
ax = axes(fig, 'Position', [0.095 0.12 0.875 0.80]);
hold(ax, 'on'); box(ax, 'on'); grid(ax, 'on');
set(ax, 'GridAlpha', 0.15, 'GridLineStyle', ':', 'LineWidth', 0.9, ...
    'FontName', S.font, 'FontSize', 11, 'TickDir', 'out');

cCommon = [0.15 0.15 0.18];
cTimeout = [0.82 0.29 0.26];
cFast = [0.18 0.43 0.71];

% 共同阶段：慢启动（指数） -> 拥塞避免（线性）
tSS = 0:0.02:3;
cSS = 2.^tSS;
tCA = 3:0.02:12;
cCA = 8 + (tCA-3)*(8/9);
plot(ax, [tSS tCA(2:end)], [cSS cCA(2:end)], '-', 'Color', cCommon, ...
     'LineWidth', 2.6, 'DisplayName', '拥塞前：慢启动 → 拥塞避免');

% 超时：cwnd 直接降为 1，重新慢启动
plot(ax, [12 12], [16 1], '-', 'Color', cTimeout, 'LineWidth', 2.2, 'HandleVisibility', 'off');
tTO = 12:0.02:15;
cTO = 2.^(tTO-12);
plot(ax, tTO, cTO, '-', 'Color', cTimeout, 'LineWidth', 2.2, ...
     'DisplayName', '超时：cwnd → 1，重新慢启动');
tTOCA = 15:0.02:22;
cTOCA = 8 + (tTOCA-15);
plot(ax, tTOCA, cTOCA, '-', 'Color', cTimeout, 'LineWidth', 2.2, 'HandleVisibility', 'off');

% 3 个重复 ACK：cwnd 减半，快速恢复后进入拥塞避免
plot(ax, [12 12], [16 8], '-', 'Color', cFast, 'LineWidth', 2.2, 'HandleVisibility', 'off');
tFR = 12:0.02:20;
cFR = 8 + (tFR-12);
plot(ax, tFR, cFR, '-', 'Color', cFast, 'LineWidth', 2.2, ...
     'DisplayName', '3 个重复 ACK：cwnd 减半，快速恢复');

% 关键点
plot(ax, [0 3 12], [1 8 16], 'o', 'MarkerSize', 5.5, ...
     'MarkerFaceColor', cCommon, 'MarkerEdgeColor', 'w', 'HandleVisibility', 'off');
plot(ax, [12 15 22], [1 8 15], 'o', 'MarkerSize', 5.5, ...
     'MarkerFaceColor', cTimeout, 'MarkerEdgeColor', 'w', 'HandleVisibility', 'off');
plot(ax, [12 20], [8 16], 'o', 'MarkerSize', 5.5, ...
     'MarkerFaceColor', cFast, 'MarkerEdgeColor', 'w', 'HandleVisibility', 'off');

% 阶段条
rectangle(ax, 'Position', [0 26.0 3 1.0], 'FaceColor', [0.86 0.92 1.00], 'EdgeColor', 'none');
rectangle(ax, 'Position', [3 26.0 9 1.0], 'FaceColor', [0.88 0.95 0.89], 'EdgeColor', 'none');
rectangle(ax, 'Position', [12 26.0 10 1.0], 'FaceColor', [1.00 0.93 0.86], 'EdgeColor', 'none');
text(ax, 1.5, 26.5, '慢启动', 'FontName', S.font, 'FontSize', 9.5, ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', S.text);
text(ax, 7.5, 26.5, '拥塞避免', 'FontName', S.font, 'FontSize', 9.5, ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', S.text);
text(ax, 17.0, 26.5, '同一拥塞点：两种处理', 'FontName', S.font, 'FontSize', 9.5, ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', S.text);

% 辅助线与注释
plot(ax, [12 12], [0 16], '--', 'Color', [0.45 0.45 0.50], 'LineWidth', 1.1, 'HandleVisibility', 'off');
plot(ax, [12 24], [8 8], '--', 'Color', [0.55 0.55 0.58], 'LineWidth', 1.0, 'HandleVisibility', 'off');
text(ax, 23.8, 8.45, 'ssthresh=8', 'FontName', S.font, 'FontSize', 9, ...
     'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'Color', [0.40 0.40 0.44]);
text(ax, 12.35, 17.0, '第 12 回合检测到拥塞', 'FontName', S.font, 'FontSize', 9.5, ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
     'BackgroundColor', 'w', 'Margin', 2, 'Color', S.text);
text(ax, 13.0, 3.5, '超时：ssthresh=8，cwnd=1', 'FontName', S.font, 'FontSize', 9.5, ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
     'BackgroundColor', 'w', 'Margin', 2, 'Color', cTimeout);
text(ax, 14.0, 15.5, {'3 个重复 ACK', 'ssthresh=8，cwnd=8'}, 'FontName', S.font, 'FontSize', 9.5, ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
     'BackgroundColor', 'w', 'Margin', 2, 'Color', cFast);

xlim(ax, [0 24]); ylim(ax, [-1 28.5]);
xticks(ax, 0:2:24); yticks(ax, 0:4:24);
xlabel(ax, '时间 / RTT', 'FontName', S.font, 'FontSize', 12);
ylabel(ax, 'cwnd（MSS）', 'FontName', S.font, 'FontSize', 12);
title(ax, 'cwnd 变化示意：超时 vs 3 个重复 ACK', 'FontName', S.font, ...
      'FontSize', 14, 'FontWeight', 'bold');
lg = legend(ax, 'Location', 'southeast');
set(lg, 'FontName', S.font, 'FontSize', 9, 'Box', 'off');

exportgraphics(fig, fullfile(OUTDIR, '15-cwnd-congestion-control.png'), 'Resolution', 240);
close(fig);

%% ===================== 局部函数 =====================
function S = style()
    S.font = 'Microsoft YaHei';
    S.fs = 11;
    S.fsSmall = 10;
    S.fsLarge = 12;
    S.text = [0.118 0.118 0.137];
    S.arrow = [0.235 0.235 0.255];
    S.boxFill = [0.925 0.953 0.988];
    S.boxEdge = [0.243 0.427 0.639];
    S.diaFill = [1.000 0.949 0.882];
    S.diaEdge = [0.823 0.529 0.208];
    S.termFill = [0.914 0.957 0.918];
    S.termEdge = [0.302 0.549 0.294];
    S.noteFill = [1.000 0.973 0.855];
    S.noteEdge = [0.780 0.639 0.235];
    S.life = [0.550 0.550 0.580];
    S.actFill = [0.988 0.902 0.780];
    S.actEdge = [0.823 0.600 0.278];
    S.head = 0.16;
    S.lw = 1.25;
end

function [fig, ax] = newCanvas(W, H, S)
    scale = 1.5;
    fig = figure('Visible', 'off', 'Color', 'w', 'Units', 'inches', ...
                 'Position', [1 1 W/scale H/scale]);
    ax = axes(fig, 'Position', [0 0 1 1]);
    hold(ax, 'on'); axis(ax, 'off'); axis(ax, 'equal');
    xlim(ax, [0 W]); ylim(ax, [0 H]);
    set(ax, 'Clipping', 'off');
end

function saveFig(fig, outdir, name)
    exportgraphics(fig, fullfile(outdir, [name '.png']), 'Resolution', 220);
    close(fig);
end

function drawBox(ax, S, cx, cy, w, h, str, kind, face, edge)
    if nargin < 9 || isempty(face)
        switch kind
            case 'terminal', face = S.termFill; edge = S.termEdge;
            case 'note',     face = S.noteFill; edge = S.noteEdge;
            otherwise,       face = S.boxFill;  edge = S.boxEdge;
        end
    end
    switch kind
        case 'terminal', curv = [0.38 0.38];
        case 'note',     curv = [0.10 0.10];
        otherwise,       curv = [0.14 0.14];
    end
    rectangle(ax, 'Position', [cx-w/2, cy-h/2, w, h], 'Curvature', curv, ...
              'FaceColor', face, 'EdgeColor', edge, 'LineWidth', 1.25);
    text(ax, cx, cy, str, 'FontName', S.font, 'FontSize', S.fs, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Color', S.text, 'Interpreter', 'none');
end

function drawLayerBox(ax, S, cx, cy, w, h, titleStr, detailStr, face, edge)
    rectangle(ax, 'Position', [cx-w/2, cy-h/2, w, h], 'Curvature', [0.12 0.12], ...
              'FaceColor', face, 'EdgeColor', edge, 'LineWidth', 1.3);
    text(ax, cx, cy+0.24, titleStr, 'FontName', S.font, 'FontSize', S.fs, ...
         'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'middle', 'Color', S.text, 'Interpreter', 'none');
    text(ax, cx, cy-0.28, detailStr, 'FontName', S.font, 'FontSize', S.fsSmall, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Color', [0.25 0.25 0.28], 'Interpreter', 'none');
end

function drawDiamond(ax, S, cx, cy, w, h, str)
    X = [cx, cx+w/2, cx, cx-w/2];
    Y = [cy+h/2, cy, cy-h/2, cy];
    patch(ax, X, Y, S.diaFill, 'EdgeColor', S.diaEdge, 'LineWidth', 1.25);
    text(ax, cx, cy, str, 'FontName', S.font, 'FontSize', S.fsSmall, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Color', S.text, 'Interpreter', 'none');
end

function drawArrow(ax, S, p1, p2)
    plot(ax, [p1(1) p2(1)], [p1(2) p2(2)], '-', 'Color', S.arrow, 'LineWidth', S.lw);
    drawHead(ax, S, p1, p2);
end

function drawPolyArrow(ax, S, pts)
    for i = 1:size(pts,1)-1
        plot(ax, [pts(i,1) pts(i+1,1)], [pts(i,2) pts(i+1,2)], '-', ...
             'Color', S.arrow, 'LineWidth', S.lw);
    end
    drawHead(ax, S, pts(end-1,:), pts(end,:));
end

function drawHead(ax, S, p1, p2)
    d = p2 - p1; L = norm(d);
    if L == 0, return; end
    u = d / L; n = [-u(2), u(1)];
    tip = p2; base = p2 - u * S.head;
    X = [tip(1), base(1)+n(1)*S.head*0.45, base(1)-n(1)*S.head*0.45];
    Y = [tip(2), base(2)+n(2)*S.head*0.45, base(2)-n(2)*S.head*0.45];
    patch(ax, X, Y, S.arrow, 'EdgeColor', S.arrow);
end

function drawLine(ax, S, p1, p2, style)
    if nargin < 5, style = '-'; end
    plot(ax, [p1(1) p2(1)], [p1(2) p2(2)], style, 'Color', S.arrow, 'LineWidth', S.lw);
end

function label(ax, S, x, y, str, ha)
    if nargin < 5, ha = 'center'; end
    text(ax, x, y, str, 'FontName', S.font, 'FontSize', S.fsSmall, ...
         'HorizontalAlignment', ha, 'VerticalAlignment', 'middle', ...
         'Color', S.text, 'BackgroundColor', [1 1 1], 'Margin', 1, ...
         'Interpreter', 'none');
end

function drawGroupBox(ax, S, cx, cy, w, h, titleStr)
    rectangle(ax, 'Position', [cx-w/2, cy-h/2, w, h], 'Curvature', [0.06 0.06], ...
              'FaceColor', [0.975 0.982 0.995], 'EdgeColor', [0.760 0.800 0.870], ...
              'LineWidth', 1.1);
    text(ax, cx, cy+h/2+0.28, titleStr, 'FontName', S.font, 'FontSize', 11, ...
         'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'middle', 'Color', S.text, 'Interpreter', 'none');
end

function drawNode(ax, S, cx, cy, r, str, face, edge)
    if nargin < 7, face = S.boxFill; edge = S.boxEdge; end
    rectangle(ax, 'Position', [cx-r, cy-r, 2*r, 2*r], 'Curvature', [1 1], ...
              'FaceColor', face, 'EdgeColor', edge, 'LineWidth', 1.2);
    text(ax, cx, cy, str, 'FontName', S.font, 'FontSize', 10.5, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Color', S.text, 'Interpreter', 'none');
end

function drawParticipant(ax, S, x, y, labelStr, w, bottomY)
    drawBox(ax, S, x, y, w, 0.62, labelStr, 'process', ...
            [0.910 0.945 0.990], [0.300 0.450 0.650]);
    plot(ax, [x x], [y-0.31, bottomY], '--', 'Color', S.life, 'LineWidth', 0.9);
end

function drawActivation(ax, S, x, yTop, yBottom)
    rectangle(ax, 'Position', [x-0.07, yBottom, 0.14, yTop-yBottom], ...
              'FaceColor', S.actFill, 'EdgeColor', S.actEdge, 'LineWidth', 0.8);
end

function drawMessage(ax, S, x1, x2, y, str, styleName)
    if strcmp(styleName, 'dashed'), ls = '--'; else, ls = '-'; end
    plot(ax, [x1 x2], [y y], ls, 'Color', S.arrow, 'LineWidth', 1.1);
    drawHead(ax, S, [x1 y], [x2 y]);
    labelNoBg(ax, S, (x1+x2)/2, y+0.10, str, 'center');
end

function drawNoteBox(ax, S, x1, x2, y, str)
    n = numel(str);
    h = 0.38 + 0.32*n;
    rectangle(ax, 'Position', [x1, y-h/2, x2-x1, h], 'Curvature', [0.10 0.10], ...
              'FaceColor', S.noteFill, 'EdgeColor', S.noteEdge, 'LineWidth', 1.0);
    text(ax, (x1+x2)/2, y, str, 'FontName', S.font, 'FontSize', 10, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
         'Color', S.text, 'Interpreter', 'none');
end

function labelNoBg(ax, S, x, y, str, ha)
    if nargin < 6, ha = 'center'; end
    text(ax, x, y, str, 'FontName', S.font, 'FontSize', 10, ...
         'HorizontalAlignment', ha, 'VerticalAlignment', 'bottom', ...
         'Color', S.text, 'Interpreter', 'none');
end
