function fig27_ipv6
% IPv6 首部与隧道
[f,ax]=mnewfig(1080,620);
W=1080;H=620;
mtext(ax,W/2,H-26,'IPv6：首部格式与迁移隧道','fontsize',17,'fontweight','bold');

% 首部
mtext(ax,90,555,'IPv6 首部（固定 40 B）','halign','left','fontsize',12.5,'fontweight','bold','color',[0.14 0.40 0.72]);
v6={ {'版本',4,[0.90 0.90 0.90]}, {'流量类别',8,[0.86 0.94 0.86]}, {'流标签',20,[0.99 0.92 0.78]}, ...
     {'载荷长度',16,[0.88 0.92 0.99]}, {'下一首部',8,[0.96 0.84 0.86]}, {'跳数限制',8,[0.96 0.84 0.86]}, ...
     {'源地址（128 bit）',128,[0.82 0.90 0.98]}, {'目的地址（128 bit）',128,[0.82 0.90 0.98]} };
mbitstrip(ax,110,410,880,44,v6,'fontsize',9,'showbits',false,'rotate',true);

% 扩展首部
mtext(ax,110,370,'扩展首部：分片、源路由、认证、安全等；最后一项指向传输层首部','halign','left','fontsize',10.2,'color',[0.35 0.35 0.35]);
mtext(ax,110,342,'相比 IPv4 删去：首部长度、首部校验和、分片相关字段（由源端处理）','halign','left','fontsize',10.2,'color',[0.35 0.35 0.35]);

% 隧道
mtext(ax,110,310,'IPv6 隧道：IPv6 数据报封装在 IPv4 中穿过 IPv4 区域','halign','left','fontsize',12,'fontweight','bold','color',[0.62 0.20 0.20]);
y=190;
% IPv6 网络
rectangle(ax,'Position',[90 y-40 150 80],'FaceColor',[0.90 0.96 0.90],'EdgeColor',[0.20 0.52 0.32],'Curvature',[0.2 0.2]);
mtext(ax,165,y+12,'IPv6 主机 A','fontsize',10);
rectangle(ax,'Position',[840 y-40 150 80],'FaceColor',[0.90 0.96 0.90],'EdgeColor',[0.20 0.52 0.32],'Curvature',[0.2 0.2]);
mtext(ax,915,y+12,'IPv6 主机 F','fontsize',10);
% 隧道端点
mbox(ax,290,y-32,110,64,'路由器 B','fontsize',10,'facecolor',[0.90 0.94 0.99]);
mbox(ax,680,y-32,110,64,'路由器 E','fontsize',10,'facecolor',[0.90 0.94 0.99]);
% IPv4 云
rectangle(ax,'Position',[420 y-55 270 110],'FaceColor',[0.97 0.94 0.90],'EdgeColor',[0.65 0.50 0.25],'LineWidth',1.2,'Curvature',[0.35 0.35]);
mtext(ax,555,y+20,'IPv4 网络','fontsize',12,'fontweight','bold','color',[0.55 0.42 0.18]);
mtext(ax,555,y-12,'外层首部：B → E','fontsize',9.5);
mtext(ax,555,y-34,'内层：A → F 的 IPv6 数据报','fontsize',9.5);
% 链路
marrow(ax,240,y,290,y,'color',[0.30 0.30 0.30],'linewidth',1.6,'head',8);
marrow(ax,400,y,420,y,'color',[0.30 0.30 0.30],'linewidth',1.6,'head',8);
marrow(ax,790,y,840,y,'color',[0.30 0.30 0.30],'linewidth',1.6,'head',8);
mtext(ax,815,y+14,'IPv6','fontsize',8.5);
mtext(ax,W/2,60,'迁移方案：双栈（同时运行 IPv4/IPv6）与隧道（把 IPv6 封装在 IPv4 中，或反之）', ...
  'fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig27_ipv6.png');
end
