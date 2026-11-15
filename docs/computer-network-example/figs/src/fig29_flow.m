function fig29_flow
% CSMA/CD 与 CSMA/CA 流程对比（严格网格对齐版）
[f,ax]=mnewfig(1180,840);
W=1180;H=840;
mtext(ax,W/2,H-26,'CSMA/CD 与 CSMA/CA 流程对比','fontsize',17,'fontweight','bold');

Y.start=720; Y.d1=630; Y.branch=540; Y.d2=448; Y.end=358; Y.extra=268;

flowcd(ax,300,Y);
flowca(ax,860,Y);

msave(f,'fig29_flow.png');
end

function flowcd(ax,c,Y)
mtext(ax,c,768,'CSMA/CD（有线以太网）','fontsize',12.5,'fontweight','bold','color',[0.14 0.40 0.72]);
L=c-140; R=c+140;
mbox(ax,c-85,Y.start-22,170,44,'有帧要发送','fontsize',10.5,'fontweight','bold');
mdiamond(ax,c,Y.d1,240,80,'侦听：信道空闲？','fontsize',10);
mbox(ax,L-80,Y.branch-22,160,44,'立即发送','fontsize',10);
mbox(ax,R-85,Y.branch-22,170,44,'等候至空闲','fontsize',10);
mdiamond(ax,c,Y.d2,240,80,'检测到冲突？','fontsize',10);
mbox(ax,L-80,Y.end-22,160,44,'发送完成','fontsize',10);
mbox(ax,R-95,Y.end-22,190,44,'发干扰信号并停止','fontsize',9.5, ...
  'facecolor',[0.99 0.90 0.90],'edgecolor',[0.70 0.25 0.25]);
mdiamond(ax,R,Y.extra,200,72,'重试 < 16？','fontsize',9.8);
mbox(ax,R+130,Y.extra-22,140,44,'放弃','fontsize',10);
mbox(ax,R-95,Y.extra-120,190,44,'指数回退，重新侦听','fontsize',9.5, ...
  'facecolor',[0.99 0.92 0.86],'edgecolor',[0.62 0.45 0.20]);

melbow(ax,[c Y.start-22; c Y.d1+40],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[c Y.d1-40; c Y.d2+40],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[c-120 Y.d1; L Y.d1; L Y.branch+22],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[c+120 Y.d1; R Y.d1; R Y.branch+22],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[L Y.branch-22; L Y.d2; c-120 Y.d2],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[R Y.branch-22; R Y.d2; c+120 Y.d2],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[c-120 Y.d2; L Y.d2; L Y.end+22],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[c+120 Y.d2; R Y.d2; R Y.end+22],'color',[0.4 0.4 0.4],'linewidth',1.5);
% 重试判定：是 -> 指数回退；否 -> 放弃
melbow(ax,[R Y.end-22; R Y.extra+36],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[R+100 Y.extra; R+130 Y.extra],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[R Y.extra-36; R Y.extra-98],'color',[0.4 0.4 0.4],'linewidth',1.5);

mtext(ax,c-150,Y.d1+16,'空闲','fontsize',9.5,'color',[0.20 0.52 0.32]);
mtext(ax,c+150,Y.d1+16,'忙','fontsize',9.5,'color',[0.80 0.44 0.10]);
mtext(ax,c-150,Y.d2+18,'否','fontsize',9.5);
mtext(ax,c+150,Y.d2+18,'是','fontsize',9.5);
mtext(ax,R+114,Y.extra+18,'否','fontsize',9.5);
mtext(ax,R+14,Y.extra-66,'是','fontsize',9.5,'halign','left');
end

function flowca(ax,c,Y)
mtext(ax,c,768,'CSMA/CA（无线局域网）','fontsize',12.5,'fontweight','bold','color',[0.62 0.20 0.20]);
L=c-140; R=c+140;
mbox(ax,c-85,Y.start-22,170,44,'有帧要发送','fontsize',10.5,'fontweight','bold');
mdiamond(ax,c,Y.d1,250,80,'侦听空闲 DIFS？','fontsize',10);
mbox(ax,L-80,Y.branch-22,160,44,'发送整帧','fontsize',10);
mbox(ax,R-85,Y.branch-22,170,44,'随机回退','fontsize',10, ...
  'facecolor',[0.99 0.92 0.86],'edgecolor',[0.62 0.45 0.20]);
mdiamond(ax,c,Y.d2,240,80,'收到 ACK？','fontsize',10);
mbox(ax,L-80,Y.end-22,160,44,'完成','fontsize',10);
mbox(ax,R-95,Y.end-22,190,44,'扩大回退范围重试','fontsize',9.5, ...
  'facecolor',[0.99 0.90 0.90],'edgecolor',[0.70 0.25 0.25]);

melbow(ax,[c Y.start-22; c Y.d1+40],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[c Y.d1-40; c Y.d2+40],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[c-125 Y.d1; L Y.d1; L Y.branch+22],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[c+125 Y.d1; R Y.d1; R Y.branch+22],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[L Y.branch-22; L Y.d2; c-120 Y.d2],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[R Y.branch-22; R Y.d2; c+120 Y.d2],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[c-120 Y.d2; L Y.d2; L Y.end+22],'color',[0.4 0.4 0.4],'linewidth',1.5);
melbow(ax,[c+120 Y.d2; R Y.d2; R Y.end+22],'color',[0.4 0.4 0.4],'linewidth',1.5);

mtext(ax,c-150,Y.d1+16,'是','fontsize',9.5,'color',[0.20 0.52 0.32]);
mtext(ax,c+150,Y.d1+16,'否','fontsize',9.5,'color',[0.80 0.44 0.10]);
mtext(ax,c-150,Y.d2+18,'是','fontsize',9.5);
mtext(ax,c+150,Y.d2+18,'否','fontsize',9.5);

mtext(ax,c,Y.end-128,'（可选）先交换 RTS/CTS','fontsize',9.5,'color',[0.62 0.20 0.20]);
mtext(ax,c,Y.end-152,'收到 CTS 的邻近节点设置 NAV','fontsize',9,'color',[0.40 0.40 0.40]);
end
