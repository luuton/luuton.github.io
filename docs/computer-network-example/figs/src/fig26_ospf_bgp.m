function fig26_ospf_bgp
% OSPF 区域 与 BGP AS 路径
[f,ax]=mnewfig(1100,600);
W=1100;H=600;
mtext(ax,W/2,H-26,'OSPF 区域结构 与 BGP 域间路由','fontsize',17,'fontweight','bold');

% ---- OSPF ----
mtext(ax,270,520,'OSPF：两级分层（主干区域 + 非主干区域）','fontsize',12,'fontweight','bold','color',[0.14 0.40 0.72]);
cx=270; cy=320;
% 主干
rectangle(ax,'Position',[cx-70 cy-45 140 90],'FaceColor',[0.90 0.94 0.99],'EdgeColor',[0.16 0.42 0.72],'LineWidth',1.5,'Curvature',[0.2 0.2]);
mtext(ax,cx,cy,'area 0','fontsize',11,'fontweight','bold');
% 三个区域
ang=[90 210 330]*pi/180; R=150;
for i=1:3
  x=cx+R*cos(ang(i)); y=cy+R*sin(ang(i));
  rectangle(ax,'Position',[x-52 y-32 104 64],'FaceColor',[0.96 0.98 0.96],'EdgeColor',[0.20 0.52 0.32],'LineWidth',1.3,'Curvature',[0.15 0.15]);
  mtext(ax,x,y+8,sprintf('area %d',i),'fontsize',10,'fontweight','bold');
  mtext(ax,x,y-12,'ABR','fontsize',9);
  mlink(ax,cx,cy,x,y,'color',[0.45 0.45 0.45],'linewidth',2);
end
mtext(ax,cx,145,'area border router（ABR）汇总区域开销','fontsize',9.2,'color',[0.35 0.35 0.35]);

% ---- BGP ----
mtext(ax,800,520,'BGP：AS 路径与 iBGP/eBGP','fontsize',12,'fontweight','bold','color',[0.62 0.20 0.20]);
as=struct('A',[700 380],'B',[830 380],'C',[960 380]);
fn=fieldnames(as);
for i=1:numel(fn)
  p=as.(fn{i});
  rectangle(ax,'Position',[p(1)-42 p(2)-30 84 60],'FaceColor',[0.99 0.92 0.92],'EdgeColor',[0.62 0.20 0.20],'LineWidth',1.4,'Curvature',[0.15 0.15]);
  mtext(ax,p(1),p(2)+6,['AS ' fn{i}],'fontsize',11,'fontweight','bold');
end
marrow(ax,742,380,788,380,'color',[0.62 0.20 0.20],'linewidth',2,'head',9);
marrow(ax,872,380,918,380,'color',[0.62 0.20 0.20],'linewidth',2,'head',9);
mtext(ax,765,398,'eBGP','fontsize',9,'color',[0.62 0.20 0.20]);
mtext(ax,895,398,'eBGP','fontsize',9,'color',[0.62 0.20 0.20]);
% iBGP 内部
mlink(ax,700,350,700,300,'color',[0.45 0.45 0.85],'linewidth',1.3,'dash','--');
mlink(ax,830,350,830,300,'color',[0.45 0.45 0.85],'linewidth',1.3,'dash','--');
mtext(ax,715,320,'iBGP','halign','left','fontsize',8.5,'color',[0.45 0.45 0.85]);
mtext(ax,845,320,'iBGP','halign','left','fontsize',8.5,'color',[0.45 0.45 0.85]);
% 路由通告
bx=610; by=110; bw=430; bh=120;
rectangle(ax,'Position',[bx by bw bh],'FaceColor',[0.98 0.98 0.99],'EdgeColor',[0.70 0.72 0.78],'Curvature',[0.05 0.08]);
mtext(ax,bx+10,by+95,'UPDATE：前缀 + 属性','halign','left','fontsize',9.8,'fontweight','bold');
mtext(ax,bx+10,by+70,'Prefix：135.120.0.0/16','halign','left','fontsize',9.2);
mtext(ax,bx+10,by+46,'AS_PATH：2 1（每经过一个 AS 追加 ASN）','halign','left','fontsize',9.2);
mtext(ax,bx+10,by+22,'NEXT_HOP：到达目的网络的下一跳','halign','left','fontsize',9.2);
mtext(ax,W/2,50,'OSPF 在 AS 内计算最短路径；BGP 在 AS 间传播可达性，基于策略选择路径（可达性甚于最优性）', ...
  'fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig26_ospf_bgp.png');
end
