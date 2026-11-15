function fig13_subnet
% 子网划分：212.1.2.0/23 -> /24,/25,/26,/27
[f,ax]=mnewfig(1120,620);
W=1120;H=620;
mtext(ax,W/2,H-26,'子网划分：从大到小分割地址块','fontsize',17,'fontweight','bold');

% 根
mbox(ax,380,520,240,54,'212.1.2.0/23（512 个地址）','fontsize',11,'fontweight','bold','facecolor',[0.88 0.93 0.99]);
% 一级：A /24 与 余下 /24
mbox(ax,150,420,200,46,'A：212.1.2.0/24','fontsize',10.5,'facecolor',[0.84 0.94 0.86],'edgecolor',[0.18 0.50 0.30]);
mbox(ax,560,420,240,46,'余下 212.1.3.0/24','fontsize',10.5,'facecolor',[0.98 0.92 0.86],'edgecolor',[0.62 0.45 0.20]);
mlink(ax,470,520,250,466,'color',[0.55 0.55 0.55]); mlink(ax,530,520,680,466,'color',[0.55 0.55 0.55]);
% 二级：B /25 + 余下 /25
mbox(ax,470,330,200,44,'B：212.1.3.0/25','fontsize',10.5,'facecolor',[0.84 0.94 0.86],'edgecolor',[0.18 0.50 0.30]);
mbox(ax,760,330,180,44,'余下 /25','fontsize',10.5,'facecolor',[0.98 0.92 0.86],'edgecolor',[0.62 0.45 0.20]);
mlink(ax,680,420,570,374,'color',[0.55 0.55 0.55]); mlink(ax,680,420,850,374,'color',[0.55 0.55 0.55]);
% 三级：C /26 + 余下 /26
mbox(ax,720,240,190,44,'C：212.1.3.128/26','fontsize',10.5,'facecolor',[0.84 0.94 0.86],'edgecolor',[0.18 0.50 0.30]);
mbox(ax,940,170,150,40,'余下 /26','fontsize',10,'facecolor',[0.98 0.92 0.86],'edgecolor',[0.62 0.45 0.20]);
mlink(ax,850,330,815,284,'color',[0.55 0.55 0.55]); mlink(ax,850,330,1010,210,'color',[0.55 0.55 0.55]);
% 四级：D /27、E /27
mbox(ax,690,135,150,40,'D：/27（23 台）','fontsize',9.8,'facecolor',[0.84 0.94 0.86],'edgecolor',[0.18 0.50 0.30]);
mbox(ax,860,70,150,40,'E：/27（16 台）','fontsize',9.8,'facecolor',[0.84 0.94 0.86],'edgecolor',[0.18 0.50 0.30]);
mlink(ax,1015,170,765,155,'color',[0.55 0.55 0.55]); mlink(ax,1015,170,935,110,'color',[0.55 0.55 0.55]);

% 说明
mtext(ax,190,330,'按主机数从大到小：','fontsize',10.5,'fontweight','bold');
mtext(ax,190,305,'A 180 → /24','fontsize',10);
mtext(ax,190,282,'B 110 → /25','fontsize',10);
mtext(ax,190,259,'C 52 → /26','fontsize',10);
mtext(ax,190,236,'D 23 → /27','fontsize',10);
mtext(ax,190,213,'E 16 → /27','fontsize',10);
mtext(ax,W/2,36,'校验：256 + 128 + 64 + 32 + 32 = 512，恰好覆盖整个 /23，且各子网不重叠', ...
  'fontsize',10.5,'color',[0.28 0.28 0.28]);
msave(f,'fig13_subnet.png');
end
