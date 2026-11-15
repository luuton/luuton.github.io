function fig11_spanning
% 生成树：有环拓扑 -> 无环树
[f,ax]=mnewfig(1120,600);
W=1120;H=600;
mtext(ax,W/2,H-26,'生成树算法：消除二层环路','fontsize',17,'fontweight','bold');

drawring(ax,90,'有环拓扑（广播风暴风险）',true);
drawring(ax,590,'生成树（阻塞冗余端口）',false);
mtext(ax,W/2,80,'根网桥 = 最小 ID；每个网段选距根最近的指定网桥；只有根和指定网桥转发帧', ...
  'fontsize',10.5,'color',[0.28 0.28 0.28]);
msave(f,'fig11_spanning.png');
end

function drawring(ax,xoff,titleStr,cyclic)
cx=xoff+200; cy=310; R=120;
mtext(ax,cx,cy+182,titleStr,'fontsize',12.5,'fontweight','bold','color',[0.14 0.40 0.72]);
ang=[45 135 225 315]'*pi/180;
P=[cx+R*cos(ang), cy+R*sin(ang)];
lan=[cx cy+108; cx-108 cy; cx cy-108; cx+108 cy];
% 桥
for i=1:4
  mnode(ax,P(i,1),P(i,2),26,sprintf('B%d',i),'fontsize',10, ...
     'facecolor',[0.90 0.94 0.99],'edgecolor',[0.16 0.42 0.72]);
end
% 桥间链路
for i=1:4
  j=mod(i,4)+1;
  if ~cyclic && (i==3)
    plot(ax,[P(i,1) P(j,1)],[P(i,2) P(j,2)],':','Color',[0.80 0.30 0.30],'LineWidth',2.2);
    mx=(P(i,1)+P(j,1))/2; my=(P(i,2)+P(j,2))/2;
    plot(ax,mx,my,'x','MarkerSize',13,'LineWidth',2.6,'Color',[0.80 0.20 0.20]);
    mtext(ax,mx-14,my+16,'阻塞','halign','right','fontsize',9,'color',[0.80 0.20 0.20]);
  else
    mlink(ax,P(i,1),P(i,2),P(j,1),P(j,2),'color',[0.40 0.40 0.40],'linewidth',2);
  end
end
lans={{P(1,:),lan(1,:)},{P(2,:),lan(2,:)},{P(3,:),lan(3,:)},{P(4,:),lan(4,:)}};
for i=1:4
  a=lans{i}{1}; b=lans{i}{2};
  mlink(ax,a(1),a(2),b(1),b(2),'color',[0.55 0.55 0.55],'linewidth',1.4);
  rectangle(ax,'Position',[b(1)-26 b(2)-11 52 22],'Curvature',[0.45 0.45], ...
     'FaceColor',[0.94 0.94 0.90],'EdgeColor',[0.55 0.55 0.45],'LineWidth',1);
  mtext(ax,b(1),b(2),sprintf('LAN%d',i),'fontsize',8.5);
end
% 最后重绘桥节点，覆盖穿过圆形的链路
for i=1:4
  mnode(ax,P(i,1),P(i,2),26,sprintf('B%d',i),'fontsize',10, ...
     'facecolor',[0.90 0.94 0.99],'edgecolor',[0.16 0.42 0.72]);
end
end
