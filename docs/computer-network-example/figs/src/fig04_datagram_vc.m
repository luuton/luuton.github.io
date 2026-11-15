function fig04_datagram_vc
% 数据报交换 vs 虚电路交换
[f,ax]=mnewfig(1120,660);
W=1120;H=660;
mtext(ax,W/2,H-26,'数据报交换 vs 虚电路交换','fontsize',17,'fontweight','bold');

r=25;
% ---------- 左：数据报 ----------
cxL=300; yT=520; yB=400;
A=[cxL-105 yT]; N1=[cxL+105 yT]; N2=[cxL-105 yB]; Bn=[cxL+105 yB];
mtext(ax,cxL,600,'数据报（datagram）','fontsize',13.5,'fontweight','bold','color',[0.14 0.40 0.72]);
mlink(ax,A(1),A(2),N1(1),N1(2),'color',[0.80 0.80 0.80],'linewidth',1.5);
mlink(ax,N2(1),N2(2),Bn(1),Bn(2),'color',[0.80 0.80 0.80],'linewidth',1.5);
mlink(ax,A(1),A(2),N2(1),N2(2),'color',[0.80 0.80 0.80],'linewidth',1.5);
mlink(ax,N1(1),N1(2),Bn(1),Bn(2),'color',[0.80 0.80 0.80],'linewidth',1.5);
mlink(ax,N1(1),N1(2),N2(1),N2(2),'color',[0.80 0.80 0.80],'linewidth',1.5);
mnode(ax,A(1),A(2),r,'A','facecolor',[0.86 0.92 0.99],'edgecolor',[0.14 0.40 0.72]);
mnode(ax,Bn(1),Bn(2),r,'B','facecolor',[0.86 0.92 0.99],'edgecolor',[0.14 0.40 0.72]);
mnode(ax,N1(1),N1(2),r,'1','facecolor',[0.97 0.97 0.97],'fontsize',11);
mnode(ax,N2(1),N2(2),r,'2','facecolor',[0.97 0.97 0.97],'fontsize',11);
% 路径1：A-1-B（实线绿）
marrow(ax,A(1)+r*0.75,A(2)+8,N1(1)-r*0.75,N1(2)+8,'color',[0.13 0.50 0.25],'linewidth',2.4,'head',11);
marrow(ax,N1(1)-r*0.75,N1(2)-8,Bn(1)+r*0.75,Bn(2)+8,'color',[0.13 0.50 0.25],'linewidth',2.4,'head',11);
% 路径2：A-2-B（虚线橙）
marrow(ax,A(1)+r*0.75,A(2)-8,N2(1)-r*0.75,N2(2)-8,'color',[0.80 0.44 0.08],'linewidth',2.0,'head',10,'dash','--');
marrow(ax,N2(1)-r*0.75,N2(2)+6,Bn(1)+r*0.75,Bn(2)-8,'color',[0.80 0.44 0.08],'linewidth',2.0,'head',10,'dash','--');

mtext(ax,cxL,330,'分组 1：首部 = 目的地址 B','fontsize',10.5,'color',[0.13 0.50 0.25]);
mtext(ax,cxL,306,'分组 2：首部 = 目的地址 B','fontsize',10.5,'color',[0.80 0.44 0.08]);
mtext(ax,cxL,268,'每个分组独立查表、独立选路，','fontsize',10.5,'color',[0.28 0.28 0.28]);
mtext(ax,cxL,246,'路径可以不同','fontsize',10.5,'color',[0.28 0.28 0.28]);
mtext(ax,cxL,212,'节点只需转发表，无连接状态','fontsize',10.5,'color',[0.28 0.28 0.28]);

% ---------- 右：虚电路 ----------
cx2=820;
A2=[cx2-105 yT]; M1=[cx2+105 yT]; M2=[cx2-105 yB]; B2=[cx2+105 yB];
mtext(ax,cx2,600,'虚电路（virtual circuit）','fontsize',13.5,'fontweight','bold','color',[0.62 0.20 0.20]);
mlink(ax,A2(1),A2(2),M1(1),M1(2),'color',[0.80 0.80 0.80],'linewidth',1.5);
mlink(ax,M2(1),M2(2),B2(1),B2(2),'color',[0.80 0.80 0.80],'linewidth',1.5);
mlink(ax,A2(1),A2(2),M2(1),M2(2),'color',[0.80 0.80 0.80],'linewidth',1.5);
mlink(ax,M1(1),M1(2),B2(1),B2(2),'color',[0.80 0.80 0.80],'linewidth',1.5);
mlink(ax,M1(1),M1(2),M2(1),M2(2),'color',[0.80 0.80 0.80],'linewidth',1.5);
mnode(ax,A2(1),A2(2),r,'A','facecolor',[0.99 0.91 0.91],'edgecolor',[0.62 0.20 0.20]);
mnode(ax,B2(1),B2(2),r,'B','facecolor',[0.99 0.91 0.91],'edgecolor',[0.62 0.20 0.20]);
mnode(ax,M1(1),M1(2),r,'1','facecolor',[0.97 0.97 0.97],'fontsize',11);
mnode(ax,M2(1),M2(2),r,'2','facecolor',[0.97 0.97 0.97],'fontsize',11);
% VC 建立（上方虚线）
marrow(ax,A2(1)+r*0.8,A2(2)+11,M1(1)-r*0.8,M1(2)+11,'color',[0.45 0.45 0.85],'linewidth',1.7,'head',9,'dash','--');
marrow(ax,M1(1),M1(2)-r-4,B2(1),B2(2)+r+6,'color',[0.45 0.45 0.85],'linewidth',1.7,'head',9,'dash','--');
% 数据（下方实线）
marrow(ax,A2(1)+r*0.8,A2(2)-11,M1(1)-r*0.85,M1(2)-11,'color',[0.62 0.20 0.20],'linewidth',2.6,'head',11);
marrow(ax,M1(1)+8,M1(2)-r-4,B2(1)+6,B2(2)+r+4,'color',[0.62 0.20 0.20],'linewidth',2.6,'head',11);
mtext(ax,cx2-70,556,'VC 建立（含 B 的地址）','fontsize',9.5,'color',[0.42 0.42 0.85]);
mtext(ax,cx2-20,478,'数据：VCI = 5','fontsize',9.5,'color',[0.62 0.20 0.20]);

mtext(ax,cx2,330,'分组首部只携带 VCI','fontsize',10.5,'color',[0.62 0.20 0.20]);
mtext(ax,cx2,306,'（不含完整目的地址）','fontsize',10.5,'color',[0.62 0.20 0.20]);
mtext(ax,cx2,268,'先建立虚电路，随后分组','fontsize',10.5,'color',[0.28 0.28 0.28]);
mtext(ax,cx2,246,'沿固定路径传输','fontsize',10.5,'color',[0.28 0.28 0.28]);
mtext(ax,cx2,212,'节点维护四元组 VC 表','fontsize',10.5,'color',[0.28 0.28 0.28]);

% 中间分隔
plot(ax,[W/2 W/2],[210 580],':','Color',[0.78 0.78 0.78],'LineWidth',1.2);
mtext(ax,W/2,186,'共同点：均为分组交换，均采用存储转发', ...
  'fontsize',10.8,'color',[0.26 0.26 0.26]);
mtext(ax,W/2,164,'关键区别：是否显式建立连接、首部用目的地址还是 VCI、节点是否保存连接状态', ...
  'fontsize',10.8,'color',[0.26 0.26 0.26]);
msave(f,'fig04_datagram_vc.png');
end
