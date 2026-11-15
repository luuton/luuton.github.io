function fig02_architecture
% OSI 七层 / 五层 / TCP-IP 四层 对照（应用层在顶部）
[f,ax]=mnewfig(1400,620);
W=1400;H=620;
mtext(ax,W/2,H-28,'三种网络体系结构对照','fontsize',17,'fontweight','bold');

names5={'应用层','传输层','网络层','数据链路层','物理层'};
u      =[1.55 1.0 1.0 1.0 1.0];
top0=505; gap=6;
s=(top0-95-4*gap)/sum(u);
hL=s*u;
bot=zeros(1,5); top=zeros(1,5);
acc=top0;
for i=1:5
  top(i)=acc; bot(i)=acc-hL(i); acc=bot(i)-gap;
end
% 五层
for i=1:5
  mbox(ax,335,bot(i),160,hL(i),names5{i},'fontsize',13,'fontweight','bold');
end
mtext(ax,415,top0+22,'五层原理性体系结构','fontsize',12.5,'fontweight','bold');
% OSI：应用层占三格
h3=hL(1)/3;
osi={'应用层','表示层','会话层','传输层','网络层','数据链路层','物理层'};
for k=1:3
  mbox(ax,95,top(1)-h3*k,160,h3-4,osi{k},'fontsize',11, ...
    'facecolor',[0.985 0.955 0.90],'edgecolor',[0.60 0.46 0.20]);
end
for i=2:5
  mbox(ax,95,bot(i),160,hL(i),osi{i+2},'fontsize',11, ...
    'facecolor',[0.985 0.955 0.90],'edgecolor',[0.60 0.46 0.20]);
end
mtext(ax,175,top0+22,'OSI 七层参考模型','fontsize',12.5,'fontweight','bold');
% TCP/IP
ec=[0.18 0.50 0.30]; fc=[0.89 0.96 0.90];
mbox(ax,595,bot(1),170,hL(1),'应用层','fontsize',12,'facecolor',fc,'edgecolor',ec);
mbox(ax,595,bot(2),170,hL(2),'传输层','fontsize',12,'facecolor',fc,'edgecolor',ec);
mbox(ax,595,bot(3),170,hL(3),'互联网层','fontsize',12,'facecolor',fc,'edgecolor',ec);
mbox(ax,595,bot(5),170,top(4)-bot(5),'网络接入层','fontsize',12,'facecolor',fc,'edgecolor',ec);
mtext(ax,680,top0+22,'TCP/IP 四层','fontsize',12.5,'fontweight','bold');

fn={{'向应用提供特定服务：','HTTP、DNS'}, {'进程之间数据传输：','TCP、UDP'}, ...
    {'主机之间传输数据包，','网络互联：IP'}, {'相邻接口之间传输帧：','以太网、802.11'}, ...
    {'在物理链路上传输原始比特：','编码'}};
for i=1:5
  mtext(ax,790,(bot(i)+top(i))/2,fn{i},'halign','left','fontsize',10.8,'color',[0.22 0.22 0.22]);
end
for i=1:5
  yc=(bot(i)+top(i))/2;
  marrow(ax,257,yc,333,yc,'head',6,'color',[0.58 0.58 0.58]);
  marrow(ax,497,yc,593,yc,'head',6,'color',[0.58 0.58 0.58]);
end
mtext(ax,545,(bot(4)+top(5))/2,'网络接入层 = 数据链路层 + 物理层', ...
  'rotation',90,'fontsize',9.5,'color',[0.40 0.40 0.40]);
mtext(ax,W/2,40,'OSI 是参考模型（7 层）；教学采用五层原理性体系结构；Internet 实际为四层 TCP/IP 架构', ...
  'fontsize',10.5,'color',[0.32 0.32 0.32]);
msave(f,'fig02_architecture.png');
end
