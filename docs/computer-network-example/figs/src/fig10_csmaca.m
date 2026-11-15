function fig10_csmaca
% CSMA/CA：DIFS、随机回退、RTS/CTS、SIFS/ACK
[f,ax]=mnewfig(1100,660);
W=1100;H=660;
mtext(ax,W/2,H-26,'CSMA/CA：冲突避免与 RTS/CTS 交互','fontsize',17,'fontweight','bold');

x0=150; xEnd=1010; yS=520; yR=420; yN=320;
mtext(ax,x0-18,yS,'发送方','halign','right','fontsize',11);
mtext(ax,x0-18,yR,'接收方 AP','halign','right','fontsize',11);
mtext(ax,x0-18,yN,'邻近节点','halign','right','fontsize',11);
plot(ax,[x0 xEnd],[yS yS],'-','Color',[0.75 0.75 0.75],'LineWidth',1);
plot(ax,[x0 xEnd],[yR yR],'-','Color',[0.75 0.75 0.75],'LineWidth',1);
plot(ax,[x0 xEnd],[yN yN],'-','Color',[0.75 0.75 0.75],'LineWidth',1);
maxis(ax,x0,xEnd,yN-36,'时间');

% 时间坐标（像素）
t=@(v) x0+v*760;  % v 0..1
% 信道忙（DIFS 前的已有传输）
rectangle(ax,'Position',[t(0.02) yS-8 t(0.06)-t(0.02) 16],'FaceColor',[0.85 0.85 0.85],'EdgeColor',[0.6 0.6 0.6]);
mtext(ax,(t(0.02)+t(0.06))/2,yS+22,'忙','fontsize',8.5,'color',[0.45 0.45 0.45]);
% DIFS
plot(ax,[t(0.08) t(0.14)],[yS+30 yS+30],'-','Color',[0.55 0.30 0.65],'LineWidth',2);
mtext(ax,t(0.11),yS+42,'DIFS','fontsize',9,'color',[0.55 0.30 0.65]);
% 回退
for k=0:3
  xx=t(0.14+k*0.03);
  rectangle(ax,'Position',[xx yS-6 0.03*760 12],'FaceColor',[0.98 0.92 0.80],'EdgeColor',[0.75 0.55 0.20]);
end
mtext(ax,t(0.20),yS+22,'随机回退（空闲才计时）','fontsize',9,'color',[0.72 0.50 0.10]);
% RTS
marrow(ax,t(0.26),yS,t(0.32),yR,'color',[0.16 0.42 0.72],'linewidth',2,'head',9);
mtext(ax,t(0.29),(yS+yR)/2+10,'RTS','fontsize',9.5,'color',[0.16 0.42 0.72]);
% SIFS + CTS
plot(ax,[t(0.32) t(0.36)],[yR+24 yR+24],'-','Color',[0.20 0.52 0.32],'LineWidth',2);
mtext(ax,t(0.34),yR+36,'SIFS','fontsize',8.5,'color',[0.20 0.52 0.32]);
marrow(ax,t(0.36),yR,t(0.42),yS,'color',[0.20 0.52 0.32],'linewidth',2,'head',9);
mtext(ax,t(0.39),(yS+yR)/2-12,'CTS','fontsize',9.5,'color',[0.20 0.52 0.32]);
% 邻居节点收到 CTS → NAV
plot(ax,[t(0.36) t(0.62)],[yN yN],'-','Color',[0.72 0.25 0.25],'LineWidth',3);
mtext(ax,t(0.49),yN+18,'收到 CTS：NAV 期间不发送','fontsize',9,'color',[0.72 0.25 0.25]);
% DATA
plot(ax,[t(0.42) t(0.46)],[yS+24 yS+24],'-','Color',[0.20 0.52 0.32],'LineWidth',2);
mtext(ax,t(0.44),yS+36,'SIFS','fontsize',8.5,'color',[0.20 0.52 0.32]);
rectangle(ax,'Position',[t(0.46) yS-12 t(0.14) 24],'FaceColor',[0.84 0.90 0.98], ...
  'EdgeColor',[0.16 0.42 0.72],'LineWidth',1.2);
mtext(ax,t(0.53),yS,'DATA','fontsize',10.5,'color',[0.16 0.42 0.72]);
% ACK
plot(ax,[t(0.60) t(0.64)],[yR+24 yR+24],'-','Color',[0.20 0.52 0.32],'LineWidth',2);
mtext(ax,t(0.62),yR+36,'SIFS','fontsize',8.5,'color',[0.20 0.52 0.32]);
marrow(ax,t(0.64),yR,t(0.70),yS,'color',[0.20 0.52 0.32],'linewidth',2,'head',9);
mtext(ax,t(0.67),(yS+yR)/2+12,'ACK','fontsize',9.5,'color',[0.20 0.52 0.32]);
rectangle(ax,'Position',[t(0.58) yN-8 t(0.14) 16],'FaceColor',[0.99 0.90 0.90], ...
  'EdgeColor',[0.72 0.25 0.25],'LineWidth',1);
mtext(ax,t(0.65),yN-26,'NAV','fontsize',9,'color',[0.72 0.25 0.25]);

% 下方说明
bx=150; by=70; bw=820; bh=130;
rectangle(ax,'Position',[bx by bw bh],'Curvature',[0.05 0.08], ...
  'FaceColor',[0.98 0.98 0.99],'EdgeColor',[0.65 0.68 0.75],'LineWidth',1);
mtext(ax,bx+bw/2,by+bh-24,'为什么用 CSMA/CA 而不是 CSMA/CD？','fontsize',11.5,'fontweight','bold');
mtext(ax,bx+bw/2,by+bh-50,'无线发送信号远强于接收信号，难以边发边检测冲突；改为随机回退 + ACK + RTS/CTS 避免冲突。','fontsize',9.8);
mtext(ax,bx+bw/2,by+bh-74,'RTS/CTS 同时缓解隐藏节点问题：听到 CTS 的节点在 NAV 期间保持静默。','fontsize',9.8);
mtext(ax,bx+bw/2,by+22,'DIFS > SIFS：保证 ACK/CTS 优先于新的竞争接入','fontsize',10,'color',[0.16 0.42 0.72]);
msave(f,'fig10_csmaca.png');
end
