function fig18_dns
% DNS 迭代查询与递归查询
[f,ax]=mnewfig(1080,600);
W=1080;H=600;
mtext(ax,W/2,H-26,'DNS 查询：迭代式 vs 递归式','fontsize',17,'fontweight','bold');
drawdns(ax,40,'迭代式（Iterative）',false);
drawdns(ax,550,'递归式（Recursive）',true);
mtext(ax,W/2,50,'迭代：被查询服务器只返回“下一步问谁”；递归：被查询服务器代为完成后续查询', ...
  'fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig18_dns.png');
end

function drawdns(ax,x0,titleStr,recursive)
w=460;
mtext(ax,x0+w/2,520,titleStr,'fontsize',12.5,'fontweight','bold','color',[0.14 0.40 0.72]);
% 四个参与者的纵线
xs=x0+[40 150 265 380];
yT=470; yB=90;
names={'主机','本地DNS','根/TLD','授权DNS'};
for i=1:4
  plot(ax,[xs(i) xs(i)],[yB yT],'-','Color',[0.65 0.65 0.65],'LineWidth',1.2);
  mtext(ax,xs(i),yT+18,names{i},'fontsize',9.2);
  mtext(ax,xs(i),yB-14,sprintf('H%d',i),'fontsize',8,'color',[0.55 0.55 0.55]);
end
% 主机问本地
marrow(ax,xs(1),440,xs(2),410,'color',[0.16 0.42 0.72],'linewidth',1.6,'head',8);
mtext(ax,(xs(1)+xs(2))/2,442,'查询','fontsize',8.5,'color',[0.16 0.42 0.72]);
if ~recursive
  marrow(ax,xs(2),395,xs(3),365,'color',[0.55 0.55 0.55],'linewidth',1.5,'head',8);
  marrow(ax,xs(3),350,xs(2),320,'color',[0.20 0.52 0.32],'linewidth',1.4,'head',8,'dash','--');
  mtext(ax,(xs(2)+xs(3))/2+12,358,'指向 TLD','fontsize',8,'color',[0.35 0.35 0.35]);
  marrow(ax,xs(2),305,xs(4),275,'color',[0.55 0.55 0.55],'linewidth',1.5,'head',8);
  marrow(ax,xs(4),260,xs(2),230,'color',[0.20 0.52 0.32],'linewidth',1.4,'head',8,'dash','--');
  mtext(ax,(xs(2)+xs(4))/2,250,'返回 IP','fontsize',8,'color',[0.35 0.35 0.35]);
else
  marrow(ax,xs(2),395,xs(3),365,'color',[0.55 0.55 0.55],'linewidth',1.5,'head',8);
  marrow(ax,xs(3),365,xs(4),335,'color',[0.55 0.55 0.55],'linewidth',1.5,'head',8);
  mtext(ax,(xs(3)+xs(4))/2,370,'代为查询','fontsize',8,'color',[0.35 0.35 0.35]);
  marrow(ax,xs(4),320,xs(3),290,'color',[0.20 0.52 0.32],'linewidth',1.4,'head',8,'dash','--');
  marrow(ax,xs(3),290,xs(2),260,'color',[0.20 0.52 0.32],'linewidth',1.4,'head',8,'dash','--');
  marrow(ax,xs(2),260,xs(1),230,'color',[0.20 0.52 0.32],'linewidth',1.4,'head',8,'dash','--');
  mtext(ax,xs(2)-10,244,'逐级返回','halign','right','fontsize',8,'color',[0.35 0.35 0.35]);
end
marrow(ax,xs(2),225,xs(1),195,'color',[0.20 0.52 0.32],'linewidth',1.6,'head',8);
mtext(ax,(xs(1)+xs(2))/2,205,'返回 IP','fontsize',8.5,'color',[0.20 0.52 0.32]);
end
