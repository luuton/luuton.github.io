function fig15_routing
% Dijkstra 示例：D 为源
[f,ax]=mnewfig(1030,560);
W=1030;H=560;
mtext(ax,W/2,H-26,'Dijkstra 前向搜索（以 D 为源）','fontsize',17,'fontweight','bold');

P=struct('D',[450 400],'C',[300 320],'B',[450 240],'A',[300 160]);
names=fieldnames(P);
% 边
E={'D','C',2; 'C','B',3; 'C','A',10; 'B','A',5; 'B','D',11};
for i=1:size(E,1)
  p1=P.(E{i,1}); p2=P.(E{i,2}); w=E{i,3};
  onpath = (strcmp(E{i,1},'D')&&strcmp(E{i,2},'C')) || ...
           (strcmp(E{i,1},'C')&&strcmp(E{i,2},'B')) || ...
           (strcmp(E{i,1},'B')&&strcmp(E{i,2},'A'));
  if onpath
    mlink(ax,p1(1),p1(2),p2(1),p2(2),'color',[0.16 0.55 0.28],'linewidth',3);
  else
    mlink(ax,p1(1),p1(2),p2(1),p2(2),'color',[0.70 0.70 0.70],'linewidth',1.6);
  end
  mx=(p1(1)+p2(1))/2; my=(p1(2)+p2(2))/2;
  mtext(ax,mx+10,my+10,sprintf('%d',w),'fontsize',11,'color',[0.35 0.35 0.35]);
end
for i=1:numel(names)
  p=P.(names{i});
  mnode(ax,p(1),p(2),25,names{i},'fontsize',12, ...
    'facecolor',[0.90 0.94 0.99],'edgecolor',[0.16 0.42 0.72]);
end
mtext(ax,450,70,'绿色：最短路径 D→C→B→A（开销 2+3+5=10）','fontsize',10.5,'color',[0.16 0.55 0.28]);

% 右表
x0=660; y0=420; dy=38;
mtext(ax,x0+80,y0+30,'节点','fontsize',10.5,'fontweight','bold');
mtext(ax,x0+170,y0+30,'开销','fontsize',10.5,'fontweight','bold');
mtext(ax,x0+240,y0+30,'下一跳','fontsize',10.5,'fontweight','bold');
tab={'C','2','C';'B','5','C';'A','10','C'};
for i=1:3
  y=y0-(i-1)*dy;
  rectangle(ax,'Position',[x0 y-16 280 32],'FaceColor',[1 1 1],'EdgeColor',[0.78 0.78 0.78]);
  mtext(ax,x0+80,y,tab{i,1},'fontsize',10.5);
  mtext(ax,x0+170,y,tab{i,2},'fontsize',10.5);
  mtext(ax,x0+240,y,tab{i,3},'fontsize',10.5);
end
mtext(ax,x0+145,y0-3*dy-2,'D 的路由表','fontsize',10.5,'color',[0.35 0.35 0.35]);
msave(f,'fig15_routing.png');
end
