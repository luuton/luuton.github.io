function fig04_datagram_vc
% 数据报交换 vs 虚电路交换（正交对齐版）
[f,ax]=mnewfig(1120,700);
W=1120;H=700;
mtext(ax,W/2,H-26,'数据报交换 vs 虚电路交换','fontsize',17,'fontweight','bold');

r=26;
% 统一的四节点矩形布局：上排 A--1 / M1，下排 2--B / M2
xl=110; xr=490; yt=520; yb=400;

% ================= 左：数据报 =================
mtext(ax,(xl+xr)/2,600,'数据报（datagram）','fontsize',13.5,'fontweight','bold','color',[0.14 0.40 0.72]);
A=[xl yt]; N1=[xr yt]; N2=[xl yb]; Bn=[xr yb];
% 物理链路（浅灰）
mlink(ax,A(1),A(2),N1(1),N1(2),'color',[0.82 0.82 0.82],'linewidth',1.5);
mlink(ax,A(1),A(2),N2(1),N2(2),'color',[0.82 0.82 0.82],'linewidth',1.5);
mlink(ax,N2(1),N2(2),Bn(1),Bn(2),'color',[0.82 0.82 0.82],'linewidth',1.5);
mlink(ax,N1(1),N1(2),Bn(1),Bn(2),'color',[0.82 0.82 0.82],'linewidth',1.5);
mlink(ax,N1(1),N1(2),N2(1),N2(2),'color',[0.82 0.82 0.82],'linewidth',1.5);
% 路径 1：A -> 1 -> B（沿链路，圆弧端点）
mcedge(ax,A,N1,r,r,'color',[0.13 0.50 0.25],'linewidth',2.4,'head',11,'offset',6);
mcedge(ax,N1,Bn,r,r,'color',[0.13 0.50 0.25],'linewidth',2.4,'head',11,'offset',6);
% 路径 2：A -> 2 -> B（沿链路，反向偏移）
mcedge(ax,A,N2,r,r,'color',[0.80 0.44 0.08],'linewidth',2.0,'head',10,'dash','--','offset',-6);
mcedge(ax,N2,Bn,r,r,'color',[0.80 0.44 0.08],'linewidth',2.0,'head',10,'dash','--','offset',-6);
mnode(ax,A(1),A(2),r,'A','facecolor',[0.86 0.92 0.99],'edgecolor',[0.14 0.40 0.72]);
mnode(ax,Bn(1),Bn(2),r,'B','facecolor',[0.86 0.92 0.99],'edgecolor',[0.14 0.40 0.72]);
mnode(ax,N1(1),N1(2),r,'1','facecolor',[0.97 0.97 0.97],'fontsize',11);
mnode(ax,N2(1),N2(2),r,'2','facecolor',[0.97 0.97 0.97],'fontsize',11);
mtext(ax,(xl+xr)/2,yt-30,'路径 1','fontsize',9.5,'color',[0.13 0.50 0.25]);
mtext(ax,(xl+xr)/2,yb+30,'路径 2','fontsize',9.5,'color',[0.80 0.44 0.08]);

mtext(ax,300,320,'分组 1：首部 = 目的地址 B','fontsize',10.5,'color',[0.13 0.50 0.25]);
mtext(ax,300,296,'分组 2：首部 = 目的地址 B','fontsize',10.5,'color',[0.80 0.44 0.08]);
mtext(ax,300,258,'每个分组独立查表、独立选路，路径可以不同','fontsize',10.5,'color',[0.28 0.28 0.28]);
mtext(ax,300,224,'节点只需转发表，无连接状态','fontsize',10.5,'color',[0.28 0.28 0.28]);

% ================= 右：虚电路 =================
xl2=630; xr2=1010;
mtext(ax,(xl2+xr2)/2,600,'虚电路（virtual circuit）','fontsize',13.5,'fontweight','bold','color',[0.62 0.20 0.20]);
A2=[xl2 yt]; M1=[xr2 yt]; M2=[xl2 yb]; B2=[xr2 yb];
mlink(ax,A2(1),A2(2),M1(1),M1(2),'color',[0.82 0.82 0.82],'linewidth',1.5);
mlink(ax,A2(1),A2(2),M2(1),M2(2),'color',[0.82 0.82 0.82],'linewidth',1.5);
mlink(ax,M2(1),M2(2),B2(1),B2(2),'color',[0.82 0.82 0.82],'linewidth',1.5);
mlink(ax,M1(1),M1(2),B2(1),B2(2),'color',[0.82 0.82 0.82],'linewidth',1.5);
mlink(ax,M1(1),M1(2),M2(1),M2(2),'color',[0.82 0.82 0.82],'linewidth',1.5);
% VC 建立：A->1 上方虚线；1->B 沿链路
mcedge(ax,A2,M1,r,r,'color',[0.45 0.45 0.85],'linewidth',1.7,'head',9,'dash','--','offset',9);
mcedge(ax,M1,B2,r,r,'color',[0.45 0.45 0.85],'linewidth',1.7,'head',9,'dash','--','offset',9);
% 数据：A->1 下方实线；1->B 沿链路另一侧
mcedge(ax,A2,M1,r,r,'color',[0.62 0.20 0.20],'linewidth',2.6,'head',11,'offset',-9);
mcedge(ax,M1,B2,r,r,'color',[0.62 0.20 0.20],'linewidth',2.6,'head',11,'offset',-9);
mnode(ax,A2(1),A2(2),r,'A','facecolor',[0.99 0.91 0.91],'edgecolor',[0.62 0.20 0.20]);
mnode(ax,B2(1),B2(2),r,'B','facecolor',[0.99 0.91 0.91],'edgecolor',[0.62 0.20 0.20]);
mnode(ax,M1(1),M1(2),r,'1','facecolor',[0.97 0.97 0.97],'fontsize',11);
mnode(ax,M2(1),M2(2),r,'2','facecolor',[0.97 0.97 0.97],'fontsize',11);
mtext(ax,(xl2+xr2)/2,yt+54,'VC 建立（含 B 的地址）','fontsize',9.5,'color',[0.42 0.42 0.85]);
mtext(ax,(xl2+xr2)/2,yt-46,'数据：VCI = 5','fontsize',9.5,'color',[0.62 0.20 0.20]);

mtext(ax,820,320,'分组首部只携带 VCI（不含完整目的地址）','fontsize',10.5,'color',[0.62 0.20 0.20]);
mtext(ax,820,258,'先建立虚电路，随后分组沿固定路径传输','fontsize',10.5,'color',[0.28 0.28 0.28]);
mtext(ax,820,224,'节点维护四元组 VC 表','fontsize',10.5,'color',[0.28 0.28 0.28]);

% 分隔与结论
plot(ax,[W/2 W/2],[200 585],':','Color',[0.80 0.80 0.80],'LineWidth',1.2);
mtext(ax,W/2,164,'共同点：均为分组交换，均采用存储转发','fontsize',10.8,'color',[0.26 0.26 0.26]);
mtext(ax,W/2,138,'关键区别：是否显式建立连接、首部用目的地址还是 VCI、节点是否保存连接状态', ...
  'fontsize',10.8,'color',[0.26 0.26 0.26]);
msave(f,'fig04_datagram_vc.png');
end
