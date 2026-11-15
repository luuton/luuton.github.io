function fig12_ipfrag
% IP 分段：4000B -> MTU 1500
[f,ax]=mnewfig(1000,560);
W=1000;H=560;
mtext(ax,W/2,H-26,'IP 数据报分段（MTU = 1500 B）','fontsize',17,'fontweight','bold');

x0=150; h=46;
% 原始
y=430;
mtext(ax,x0-16,y+h/2,'原始数据报','halign','right','fontsize',11.5);
rectangle(ax,'Position',[x0 y 760 h],'FaceColor',[0.90 0.95 0.99],'EdgeColor',[0.25 0.35 0.55],'LineWidth',1.2);
rectangle(ax,'Position',[x0 y 90 h],'FaceColor',[0.78 0.88 0.98],'EdgeColor',[0.25 0.35 0.55],'LineWidth',1.2);
mtext(ax,x0+45,y+h/2,'首部 20B','fontsize',9.5);
mtext(ax,x0+90+335,y+h/2,'数据 3980 B','fontsize',11);
mtext(ax,x0+760+16,y+h/2,'4000 B','halign','left','fontsize',10,'color',[0.35 0.35 0.35]);
% 三段
ys=[300 220 140];
frags={'分片 1：数据 1480 B，偏移 0，MF=1', ...
       '分片 2：数据 1480 B，偏移 185，MF=1', ...
       '分片 3：数据 1020 B，偏移 370，MF=0'};
for k=1:3
  y=ys(k);
  mtext(ax,x0-16,y+h/2,sprintf('分片 %d',k),'halign','right','fontsize',11);
  Wd=670; if k==3, Wd=670*1020/1480; end
  rectangle(ax,'Position',[x0 y 90 h],'FaceColor',[0.78 0.88 0.98],'EdgeColor',[0.25 0.35 0.55],'LineWidth',1.2);
  rectangle(ax,'Position',[x0+90 y Wd h],'FaceColor',[0.99 0.92 0.78],'EdgeColor',[0.55 0.42 0.20],'LineWidth',1.2);
  mtext(ax,x0+45,y+h/2,'20B','fontsize',9);
  mtext(ax,x0+90+Wd/2,y+h+12,frags{k},'fontsize',9.3,'color',[0.35 0.28 0.12]);
end
mtext(ax,W/2,95,'每个分片都是自包含的数据报：相同 Identification，独立传输，只在目的主机重组', ...
  'fontsize',10.5,'color',[0.28 0.28 0.28]);
mtext(ax,W/2,70,'除最后一片外，每片数据长度必须是 8 的倍数（偏移字段以 8 B 为单位）', ...
  'fontsize',10.5,'color',[0.28 0.28 0.28]);
msave(f,'fig12_ipfrag.png');
end
