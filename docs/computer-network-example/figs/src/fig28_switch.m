function fig28_switch
% 交换机自学习与帧转发（清晰分支布局）
[f,ax]=mnewfig(980,760);
W=980;H=760;
mtext(ax,W/2,H-26,'以太网交换机：自学习与帧转发','fontsize',17,'fontweight','bold');

cx=420;
% 主流程
mbox(ax,cx-100,640,200,46,'收到一帧','fontsize',11.5,'fontweight','bold');
mbox(ax,cx-150,560,300,46,'学习：源 MAC 与 输入端口','fontsize',11, ...
  'facecolor',[0.86 0.94 0.86],'edgecolor',[0.20 0.52 0.32]);
mdiamond(ax,cx,480,230,78,'转发表中有目的 MAC？','fontsize',10.8);

% 是分支（左下）
mbox(ax,cx-210,360,180,46,'查表得到输出端口','fontsize',10.5);
mdiamond(ax,cx-120,280,200,72,'输出端口 = 输入端口？','fontsize',9.8);
mbox(ax,cx-340,200,120,44,'丢弃','fontsize',10.5, ...
  'facecolor',[0.97 0.90 0.90],'edgecolor',[0.70 0.25 0.25]);
mbox(ax,cx-140,200,150,44,'从该端口转发','fontsize',10.5, ...
  'facecolor',[0.86 0.94 0.86],'edgecolor',[0.20 0.52 0.32]);

% 否分支（右侧）
mbox(ax,cx+150,420,190,46,'洪泛：除输入端口外','fontsize',10.2, ...
  'facecolor',[0.99 0.92 0.86],'edgecolor',[0.62 0.45 0.20]);
mtext(ax,cx+245,396,'向所有其它端口转发','fontsize',9.5,'color',[0.55 0.40 0.15]);

% 连线
marrow(ax,cx,640,cx,608,'color',[0.40 0.40 0.40],'linewidth',1.5);
marrow(ax,cx,560,cx,520,'color',[0.40 0.40 0.40],'linewidth',1.5);
% 是
marrow(ax,cx-115,465,cx-210,408,'color',[0.40 0.40 0.40],'linewidth',1.5);
mtext(ax,cx-190,452,'是','fontsize',10,'color',[0.20 0.52 0.32]);
% 否
marrow(ax,cx+115,465,cx+190,468,'color',[0.40 0.40 0.40],'linewidth',1.5);
mtext(ax,cx+150,492,'否','fontsize',10,'color',[0.80 0.44 0.10]);
% 查表→判定
marrow(ax,cx-120,360,cx-120,318,'color',[0.40 0.40 0.40],'linewidth',1.5);
% 判定→丢弃/转发
marrow(ax,cx-210,265,cx-280,245,'color',[0.40 0.40 0.40],'linewidth',1.4);
mtext(ax,cx-270,270,'是','fontsize',9.5);
marrow(ax,cx-30,265,cx-70,245,'color',[0.40 0.40 0.40],'linewidth',1.4);
mtext(ax,cx-50,272,'否','fontsize',9.5);

% 说明
mtext(ax,W/2,110,'表项带时间戳（软状态），超时删除；未知目的地址洪泛；','fontsize',10.2,'color',[0.30 0.30 0.30]);
mtext(ax,W/2,86,'交换机透明、即插即用；同时支持多个端口并行转发。','fontsize',10.2,'color',[0.30 0.30 0.30]);
msave(f,'fig28_switch.png');
end
