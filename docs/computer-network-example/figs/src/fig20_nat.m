function fig20_nat
% NAT 地址与端口改写
[f,ax]=mnewfig(1000,560);
W=1000;H=560;
mtext(ax,W/2,H-26,'NAT：私有地址与公网地址/端口的映射','fontsize',17,'fontweight','bold');

rectangle(ax,'Position',[70 190 220 210],'FaceColor',[0.96 0.97 0.99], ...
  'EdgeColor',[0.70 0.74 0.82],'LineWidth',1.2,'Curvature',[0.06 0.06]);
mtext(ax,180,420,'私有网络 10.0.0.0/24','fontsize',11,'fontweight','bold');
mtext(ax,180,360,'主机 10.0.0.1:3345','fontsize',10.5);
mtext(ax,180,330,'服务器 10.0.0.2:80','fontsize',10.5);
mtext(ax,180,250,'私有地址不可在公网路由','fontsize',9.2,'color',[0.45 0.45 0.45]);
mbox(ax,420,285,150,90,'NAT 路由器','fontsize',12.5,'fontweight','bold','facecolor',[0.90 0.94 0.99]);
mtext(ax,495,300,'公网 138.76.29.7','fontsize',9.5);
rectangle(ax,'Position',[720 240 220 140],'FaceColor',[0.96 0.99 0.96], ...
  'EdgeColor',[0.70 0.82 0.72],'LineWidth',1.2,'Curvature',[0.06 0.06]);
mtext(ax,830,430,'Internet','fontsize',12,'fontweight','bold');
mtext(ax,830,360,'服务器','fontsize',10.5);
mtext(ax,830,330,'128.119.40.186:80','fontsize',10);

marrow(ax,300,340,420,340,'color',[0.16 0.42 0.72],'linewidth',2,'head',9);
mtext(ax,355,358,'源 10.0.0.1:3345','fontsize',8.8,'color',[0.16 0.42 0.72]);
marrow(ax,570,330,720,330,'color',[0.16 0.42 0.72],'linewidth',2,'head',9);
mtext(ax,645,348,'源 138.76.29.7:5001','fontsize',8.8,'color',[0.16 0.42 0.72]);
marrow(ax,720,285,570,285,'color',[0.20 0.52 0.32],'linewidth',2,'head',9);
mtext(ax,645,266,'目的 138.76.29.7:5001','fontsize',8.8,'color',[0.20 0.52 0.32]);
marrow(ax,420,285,300,285,'color',[0.20 0.52 0.32],'linewidth',2,'head',9);
mtext(ax,355,266,'目的 10.0.0.1:3345','fontsize',8.8,'color',[0.20 0.52 0.32]);

x0=360; y0=190;
mtext(ax,x0+100,y0+40,'NAT 映射表','fontsize',10.5,'fontweight','bold');
rectangle(ax,'Position',[x0 y0-20 300 44],'FaceColor',[1 1 1],'EdgeColor',[0.70 0.70 0.70]);
mtext(ax,x0+75,y0+10,'WAN 侧','fontsize',9.5);
mtext(ax,x0+225,y0+10,'LAN 侧','fontsize',9.5);
rectangle(ax,'Position',[x0 y0-64 300 42],'FaceColor',[1 1 1],'EdgeColor',[0.70 0.70 0.70]);
mtext(ax,x0+75,y0-44,'138.76.29.7:5001','fontsize',9);
mtext(ax,x0+225,y0-44,'10.0.0.1:3345','fontsize',9);

mtext(ax,W/2,50,'NAT 路由器改写 IP 地址与端口；外网主机无法直接访问内网地址，需要端口映射/中继等穿越方案', ...
  'fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig20_nat.png');
end
