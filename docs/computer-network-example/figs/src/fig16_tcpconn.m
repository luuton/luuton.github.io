function fig16_tcpconn
% TCP 三次握手与四次挥手
[f,ax]=mnewfig(1080,700);
W=1080;H=700;
mtext(ax,W/2,H-26,'TCP 连接管理：三次握手与四次挥手','fontsize',17,'fontweight','bold');
drawconn(ax,120,'三次握手','SYN','SYN+ACK','ACK');
drawconn(ax,430,'四次挥手','FIN','ACK','FIN / ACK');
mtext(ax,W/2,52,'三次握手同步双方初始序号并确认收发能力；四次挥手因 TCP 全双工，两个方向需分别关闭（FIN 各占 1 个序号）', ...
  'fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig16_tcpconn.png');
end

function drawconn(ax,y0,titleStr,s1,s2,s3)
xL=250; xR=800;
mtext(ax,(xL+xR)/2,y0+235,titleStr,'fontsize',12.5,'fontweight','bold','color',[0.14 0.40 0.72]);
plot(ax,[xL xL],[y0+30 y0+205],'-','Color',[0.60 0.60 0.60],'LineWidth',1.4);
plot(ax,[xR xR],[y0+30 y0+205],'-','Color',[0.60 0.60 0.60],'LineWidth',1.4);
mtext(ax,xL,y0+218,'客户机','fontsize',11,'fontweight','bold');
mtext(ax,xR,y0+218,'服务器','fontsize',11,'fontweight','bold');
mtext(ax,xL,y0+14,'ESTABLISHED','fontsize',9,'color',[0.35 0.55 0.35]);
mtext(ax,xR,y0+14,'ESTABLISHED','fontsize',9,'color',[0.35 0.55 0.35]);
marrow(ax,xL+6,y0+180,xR-6,y0+150,'color',[0.16 0.42 0.72],'linewidth',1.8,'head',9);
mtext(ax,(xL+xR)/2-40,y0+182,s1,'fontsize',9.5,'color',[0.16 0.42 0.72]);
marrow(ax,xR-6,y0+145,xL+6,y0+115,'color',[0.20 0.52 0.32],'linewidth',1.8,'head',9);
mtext(ax,(xL+xR)/2+40,y0+140,s2,'fontsize',9.5,'color',[0.20 0.52 0.32]);
marrow(ax,xL+6,y0+110,xR-6,y0+80,'color',[0.16 0.42 0.72],'linewidth',1.8,'head',9);
mtext(ax,(xL+xR)/2-35,y0+94,s3,'fontsize',9.5,'color',[0.16 0.42 0.72]);
mtext(ax,(xL+xR)/2,y0+58,'（序号 x/y 随机生成；确认号 = 对方序号 + 1）','fontsize',8.8,'color',[0.45 0.45 0.45]);
end
