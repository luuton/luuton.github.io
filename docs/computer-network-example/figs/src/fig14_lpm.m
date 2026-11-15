function fig14_lpm
% 最长前缀匹配
[f,ax]=mnewfig(1060,540);
W=1060;H=540;
mtext(ax,W/2,H-26,'最长前缀匹配：选择前缀最长的表项','fontsize',17,'fontweight','bold');

rows={ '199.199.240.0/22','Router A',22,'否';
       '199.199.0.0/17','Router B',17,'否';
       '200.200.16.0/20','Router C',20,'是';
       '200.200.21.0/24','Router D',24,'是（最长）'};
y0=420; dy=52; x0=120;
mtext(ax,x0+120,y0+40,'转发表项','fontsize',11,'fontweight','bold');
mtext(ax,x0+360,y0+40,'下一跳','fontsize',11,'fontweight','bold');
mtext(ax,x0+520,y0+40,'前缀长度','fontsize',11,'fontweight','bold');
for i=1:4
  y=y0-(i-1)*dy;
  if i==4 || i==3
    fc=[0.87 0.94 0.99];
  else
    fc=[1 1 1];
  end
  rectangle(ax,'Position',[x0 y-18 520 36],'FaceColor',fc,'EdgeColor',[0.72 0.72 0.72],'LineWidth',0.9);
  mtext(ax,x0+120,y,rows{i,1},'fontsize',10.5);
  mtext(ax,x0+360,y,rows{i,2},'fontsize',10.5);
  mtext(ax,x0+520,y,sprintf('/%d',rows{i,3}),'fontsize',10.5);
  % 前缀长度条
  rectangle(ax,'Position',[x0+580 y-8 6*rows{i,3} 16], ...
     'FaceColor',[0.55 0.72 0.92],'EdgeColor',[0.30 0.45 0.65]);
end
% 目的地址
by=110;
rectangle(ax,'Position',[120 by 520 42],'FaceColor',[0.99 0.93 0.82], ...
  'EdgeColor',[0.72 0.50 0.15],'LineWidth',1.2);
mtext(ax,380,by+21,'目的地址：200.200.21.1','fontsize',12,'fontweight','bold','color',[0.55 0.38 0.10]);
marrow(ax,380,by+42,380,by+70,'color',[0.72 0.50 0.15],'linewidth',1.8);
mtext(ax,640,by+21,'匹配 /20 与 /24','halign','left','fontsize',10.5);
mtext(ax,640,by-6,'取最长前缀 /24 → Router D','halign','left','fontsize',10.5,'color',[0.16 0.42 0.72],'fontweight','bold');
mtext(ax,W/2,40,'若无匹配表项，则使用默认路由；前缀越长，地址块越具体，优先级越高', ...
  'fontsize',10.5,'color',[0.28 0.28 0.28]);
msave(f,'fig14_lpm.png');
end
