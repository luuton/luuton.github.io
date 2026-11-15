function fig08_csmacd
% CSMA/CD 冲突时空图与最小帧长
[f,ax]=mnewfig(980,680);
W=980;H=680;
mtext(ax,W/2,H-26,'CSMA/CD 冲突检测与最小帧长','fontsize',17,'fontweight','bold');

% 坐标：x 位置 0..L，y 时间(向下增大)
x0=150; xL=830; y0=560; yT=150;
mtext(ax,x0-24,y0+8,'A','halign','right','fontsize',13,'fontweight','bold');
mtext(ax,xL+24,y0+8,'B','halign','left','fontsize',13,'fontweight','bold');
plot(ax,[x0 xL],[y0 y0],'-','Color',[0.30 0.30 0.30],'LineWidth',2.5);
mtext(ax,(x0+xL)/2,y0+26,'共享介质（最远 2500 m）','fontsize',10.5,'color',[0.30 0.30 0.30]);
% 时间轴向下
plot(ax,[x0-90 x0-90],[y0 yT],'-','Color',[0.55 0.55 0.55],'LineWidth',1.2);
p=[x0-90 yT; x0-98 yT+10; x0-82 yT+10];
patch(ax,p(:,1),p(:,2),[0.55 0.55 0.55],'EdgeColor',[0.55 0.55 0.55]);
mtext(ax,x0-104,yT+28,'时间','halign','right','fontsize',10,'color',[0.40 0.40 0.40]);

tt=1.0;  % 单程传播时延对应纵向尺度
% A 的信号：从 (x0,y0) 到 (xL,y0+tt*280)
yA=y0-300; yB=y0-20; yBe=y0-280;
plot(ax,[x0 xL],[y0 yA],'-','Color',[0.16 0.42 0.72],'LineWidth',2);
plot(ax,[xL x0],[yB yBe],'-','Color',[0.72 0.30 0.18],'LineWidth',2);
% 冲突点
xc=(x0+xL)/2; yc=(y0+yA)/2-6;
plot(ax,xc,yc,'o','MarkerSize',11,'MarkerFaceColor',[0.85 0.20 0.20],'MarkerEdgeColor',[0.65 0.10 0.10]);
mtext(ax,xc+14,yc-16,'冲突','halign','left','fontsize',10.5,'color',[0.72 0.15 0.15]);
% 检测到冲突时刻标注
plot(ax,[x0 x0],[y0 yA],':','Color',[0.6 0.6 0.6]);
mtext(ax,x0-16,yA,'A 检测到冲突','halign','right','fontsize',9.5,'color',[0.16 0.42 0.72]);
mtext(ax,x0-16,y0-6,'t = 0：A 开始发送','halign','right','fontsize',9.5,'color',[0.30 0.30 0.30]);
mtext(ax,xL-6,yBe+16,'B 检测到冲突','halign','right','fontsize',9.5,'color',[0.72 0.30 0.18]);

% 说明框
bx=170; by=90; bw=640; bh=150;
rectangle(ax,'Position',[bx by bw bh],'Curvature',[0.04 0.08], ...
  'FaceColor',[0.97 0.97 0.99],'EdgeColor',[0.55 0.62 0.75],'LineWidth',1);
mtext(ax,bx+bw/2,by+bh-24,'最坏情况：两主机位于电缆两端','fontsize',11.5,'fontweight','bold');
mtext(ax,bx+bw/2,by+bh-52,'A 发出帧后，冲突信号最迟需 2\tau 才回到 A；','fontsize',10.3);
mtext(ax,bx+bw/2,by+bh-76,'因此 A 必须持续发送至少 2\tau，才能检测到冲突。','fontsize',10.3);
mtext(ax,bx+bw/2,by+34,'L_{min} = R \times 2\tau = 10 Mbps \times 51.2 \mu s = 512 bit = 64 B','fontsize',11,'color',[0.16 0.42 0.72],'fontweight','bold');
mtext(ax,W/2,44,'检测到冲突后：发送 32 bit 干扰信号，停止发送，进入指数回退','fontsize',10.3,'color',[0.35 0.35 0.35]);
msave(f,'fig08_csmacd.png');
end
