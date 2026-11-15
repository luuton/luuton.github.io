function fig28_switch
% 交换机自学习与帧转发（严格网格对齐版）
[f,ax]=mnewfig(1080,900);
W=1080;H=900;
mtext(ax,W/2,H-28,'以太网交换机：自学习与帧转发','fontsize',17,'fontweight','bold');

% 列坐标
cMain=470;   % 主列
cLeft=250;   % 左侧“是”分支列
cDiscard=100;   % 与第二判定框左顶点对齐
cRight=820;  % 右侧“否”分支列
% 行坐标（自下而上）
yStart=800; yLearn=700; yDecide=590; yLookup=470;
yDecide2=360; yEnd=240; yFlood=470;

% 节点
mbox(ax,cMain-110,yStart-23,220,46,'收到一帧','fontsize',11.5,'fontweight','bold');
mbox(ax,cMain-170,yLearn-23,340,46,'学习：源 MAC 与 输入端口','fontsize',11, ...
  'facecolor',[0.86 0.94 0.86],'edgecolor',[0.20 0.52 0.32]);
mdiamond(ax,cMain,yDecide,260,84,'转发表中有目的 MAC？','fontsize',10.5);
mbox(ax,cLeft-110,yLookup-23,220,46,'查表得到输出端口','fontsize',10.5);
mdiamond(ax,cLeft,yDecide2,300,86,'输出端口 = 输入端口？','fontsize',9.8);
mbox(ax,cDiscard-70,yEnd-22,140,44,'丢弃','fontsize',10.5, ...
  'facecolor',[0.97 0.90 0.90],'edgecolor',[0.70 0.25 0.25]);
mbox(ax,cLeft+150-90,yEnd-22,180,44,'从该端口转发','fontsize',10.5, ...
  'facecolor',[0.86 0.94 0.86],'edgecolor',[0.20 0.52 0.32]);
mbox(ax,cRight-120,yFlood-23,240,46,'洪泛：除输入端口外','fontsize',10.2, ...
  'facecolor',[0.99 0.92 0.86],'edgecolor',[0.62 0.45 0.20]);
mtext(ax,cRight,yFlood-52,'向所有其它端口转发','fontsize',9.5,'color',[0.55 0.40 0.15]);

% 连线（全部正交）
% 收到一帧 -> 学习
melbow(ax,[cMain yStart-23; cMain yLearn+23],'color',[0.40 0.40 0.40],'linewidth',1.6);
% 学习 -> 判定
melbow(ax,[cMain yLearn-23; cMain yDecide+42],'color',[0.40 0.40 0.40],'linewidth',1.6);
% 判定“是” -> 左列 -> 查表
melbow(ax,[cMain-130 yDecide; cLeft yDecide; cLeft yLookup+23],'color',[0.40 0.40 0.40],'linewidth',1.6);
% 判定“否” -> 右列 -> 洪泛
melbow(ax,[cMain+130 yDecide; cRight yDecide; cRight yFlood+23],'color',[0.40 0.40 0.40],'linewidth',1.6);
% 查表 -> 第二判定
melbow(ax,[cLeft yLookup-23; cLeft yDecide2+40],'color',[0.40 0.40 0.40],'linewidth',1.6);
% 第二判定“是” -> 丢弃
melbow(ax,[cLeft-150 yDecide2; cDiscard yDecide2; cDiscard yEnd+22],'color',[0.40 0.40 0.40],'linewidth',1.5);
% 第二判定“否” -> 转发
melbow(ax,[cLeft+150 yDecide2; cLeft+150 yEnd+22],'color',[0.40 0.40 0.40],'linewidth',1.5);

% 分支标注
mtext(ax,cMain-150,yDecide+14,'是','fontsize',10,'color',[0.20 0.52 0.32]);
mtext(ax,cMain+150,yDecide+14,'否','fontsize',10,'color',[0.80 0.44 0.10]);
mtext(ax,cLeft-182,yDecide2+18,'是','fontsize',9.5);
mtext(ax,cLeft+182,yDecide2+18,'否','fontsize',9.5);

% 说明
mtext(ax,W/2,150,'表项带时间戳（软状态），超时删除；未知目的地址洪泛；','fontsize',10.4,'color',[0.30 0.30 0.30]);
mtext(ax,W/2,124,'交换机透明、即插即用；同时支持多个端口并行转发。','fontsize',10.4,'color',[0.30 0.30 0.30]);
msave(f,'fig28_switch.png');
end
