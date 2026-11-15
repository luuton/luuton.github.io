function fig29_flow
% CSMA/CD 与 CSMA/CA 流程对比
[f,ax]=mnewfig(1100,780);
W=1100;H=780;
mtext(ax,W/2,H-26,'CSMA/CD 与 CSMA/CA 流程对比','fontsize',17,'fontweight','bold');
flowcd(ax,80); flowca(ax,600);
msave(f,'fig29_flow.png');
end

function flowcd(ax,x0)
mtext(ax,x0+200,700,'CSMA/CD（有线以太网）','fontsize',12.5,'fontweight','bold','color',[0.14 0.40 0.72]);
cx=x0+200;
mbox(ax,cx-85,640,170,40,'有帧要发送','fontsize',10.5);
mdiamond(ax,cx,575,190,70,'侦听：信道空闲？','fontsize',10);
mbox(ax,cx+80,485,160,40,'等候至空闲','fontsize',10);
mbox(ax,cx-150,485,140,40,'立即发送','fontsize',10);
mdiamond(ax,cx,415,190,70,'检测到冲突？','fontsize',10);
mbox(ax,cx-150,330,150,40,'发送完成','fontsize',10);
mbox(ax,cx+90,330,170,40,'发干扰信号并停止','fontsize',9.5,'facecolor',[0.99 0.90 0.90],'edgecolor',[0.70 0.25 0.25]);
mdiamond(ax,cx+90,255,170,64,'重试 < 16？','fontsize',9.8);
mbox(ax,cx+90,175,170,40,'指数回退，重新侦听','fontsize',9.5,'facecolor',[0.99 0.92 0.86],'edgecolor',[0.62 0.45 0.20]);
mbox(ax,cx+240,255,110,40,'放弃','fontsize',10);
marrow(ax,cx,640,cx,610,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx,540,cx+80,525,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx-95,575,cx-150,525,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx-80,485,cx,450,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx+80,485,cx,450,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx-95,415,cx-150,370,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx+95,415,cx+90,370,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx+90,310,cx+90,287,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx+90,223,cx+90,195,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx+175,255,cx+240,255,'color',[0.4 0.4 0.4],'linewidth',1.3);
end

function flowca(ax,x0)
mtext(ax,x0+200,700,'CSMA/CA（无线局域网）','fontsize',12.5,'fontweight','bold','color',[0.62 0.20 0.20]);
cx=x0+200;
mbox(ax,cx-85,640,170,40,'有帧要发送','fontsize',10.5);
mdiamond(ax,cx,575,200,70,'侦听空闲 DIFS？','fontsize',10);
mbox(ax,cx+90,485,160,40,'随机回退','fontsize',10,'facecolor',[0.99 0.92 0.86],'edgecolor',[0.62 0.45 0.20]);
mbox(ax,cx-150,485,140,40,'发送整帧','fontsize',10);
mdiamond(ax,cx,415,190,70,'收到 ACK？','fontsize',10);
mbox(ax,cx-150,330,150,40,'完成','fontsize',10);
mbox(ax,cx+90,330,180,40,'扩大回退范围重试','fontsize',9.5,'facecolor',[0.99 0.90 0.90],'edgecolor',[0.70 0.25 0.25]);
mtext(ax,cx,290,'（可选）先交换 RTS/CTS','fontsize',9.5,'color',[0.62 0.20 0.20]);
mtext(ax,cx,266,'收到 CTS 的邻近节点设置 NAV','fontsize',9,'color',[0.40 0.40 0.40]);
marrow(ax,cx,640,cx,610,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx,540,cx+90,525,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx-100,575,cx-150,525,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx-80,485,cx,450,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx+90,485,cx,450,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx-95,415,cx-150,370,'color',[0.4 0.4 0.4],'linewidth',1.3);
marrow(ax,cx+95,415,cx+90,370,'color',[0.4 0.4 0.4],'linewidth',1.3);
end
