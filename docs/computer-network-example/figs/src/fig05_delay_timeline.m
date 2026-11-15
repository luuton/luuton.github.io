function fig05_delay_timeline
% 分组传输时序瀑布图：传输、传播、排队/处理时延
[f,ax]=mnewfig(1000,620);
W=1000;H=620;
mtext(ax,W/2,H-26,'分组传输时序与节点时延构成','fontsize',17,'fontweight','bold');

x0=120; sx=78; y1=130; dy=95;
nodes={'源主机','交换机 1','交换机 2','目的主机'};
ys=[y1+3*dy, y1+2*dy, y1+dy, y1];
for i=1:4
  mtext(ax,x0-18,ys(i),nodes{i},'halign','right','fontsize',11.5);
  plot(ax,[x0-8 x0+8*sx],[ys(i) ys(i)],'-','Color',[0.62 0.62 0.62],'LineWidth',1);
end
% 时间轴
maxis(ax,x0,x0+8.2*sx,y1-58,'时间 t');

% 每跳：传输时长1，传播时长1
% 源主机：包k在 [k-1,k] 传输
for k=1:3
  rectangle(ax,'Position',[x0+((k-1)*sx) ys(1)-11 sx 22], ...
    'FaceColor',[0.84 0.90 0.98],'EdgeColor',[0.20 0.38 0.65],'LineWidth',1);
  mtext(ax,x0+(k-0.5)*sx,ys(1),sprintf('P%d',k),'fontsize',9.5);
end
% 交换机1/2、目的主机
for k=1:3
  tS1=k+1; tS2=k+3; tD=k+5;
  rectangle(ax,'Position',[x0+tS1*sx ys(2)-11 sx 22], ...
    'FaceColor',[0.84 0.94 0.86],'EdgeColor',[0.18 0.48 0.28],'LineWidth',1);
  mtext(ax,x0+(tS1+0.5)*sx,ys(2),sprintf('P%d',k),'fontsize',9.5);
  rectangle(ax,'Position',[x0+tS2*sx ys(3)-11 sx 22], ...
    'FaceColor',[0.84 0.94 0.86],'EdgeColor',[0.18 0.48 0.28],'LineWidth',1);
  mtext(ax,x0+(tS2+0.5)*sx,ys(3),sprintf('P%d',k),'fontsize',9.5);
  rectangle(ax,'Position',[x0+tD*sx ys(4)-11 sx 22], ...
    'FaceColor',[0.98 0.90 0.88],'EdgeColor',[0.62 0.24 0.20],'LineWidth',1);
  mtext(ax,x0+(tD+0.5)*sx,ys(4),sprintf('P%d',k),'fontsize',9.5);
  % 传播斜线
  plot(ax,[x0+k*sx x0+tS1*sx],[ys(1) ys(2)],'-','Color',[0.35 0.35 0.35],'LineWidth',1.1);
  plot(ax,[x0+(tS1+1)*sx x0+tS2*sx],[ys(2) ys(3)],'-','Color',[0.35 0.35 0.35],'LineWidth',1.1);
  plot(ax,[x0+(tS2+1)*sx x0+tD*sx],[ys(3) ys(4)],'-','Color',[0.35 0.35 0.35],'LineWidth',1.1);
end

% 标注
% 传输时延
plot(ax,[x0 x0],[ys(1)-26 ys(1)-14],'-','Color',[0.20 0.38 0.65],'LineWidth',1.2);
plot(ax,[x0+sx x0+sx],[ys(1)-26 ys(1)-14],'-','Color',[0.20 0.38 0.65],'LineWidth',1.2);
mtext(ax,x0+0.5*sx,ys(1)-36,'d_{trans}=L/R','fontsize',10,'color',[0.20 0.38 0.65]);
% 传播时延
plot(ax,[x0+sx x0+2*sx],[ys(1)-56 ys(1)-56],'-','Color',[0.55 0.25 0.55],'LineWidth',1.2);
mtext(ax,x0+1.5*sx,ys(1)-70,'d_{prop}=d/s','fontsize',10,'color',[0.55 0.25 0.55]);
% 排队/处理
mtext(ax,x0+3.0*sx,ys(2)+32,'节点处理 + 排队','fontsize',9.5,'color',[0.72 0.42 0.10]);
marrow(ax,x0+3.0*sx,ys(2)+24,x0+3.0*sx,ys(2)+14,'color',[0.72 0.42 0.10],'head',7);

mtext(ax,W/2,58,'总时延 = 处理 + 排队 + 传输 + 传播；传播时延由物理距离决定，与带宽无关', ...
  'fontsize',10.8,'color',[0.28 0.28 0.28]);
msave(f,'fig05_delay_timeline.png');
end
