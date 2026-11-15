function fig07_gbn_sr
% Go-Back-N 与选择性重传对比（分组 2 丢失）
[f,ax]=mnewfig(1060,720);
W=1060;H=720;
mtext(ax,W/2,H-26,'Go-Back-N vs 选择性重传（分组 2 丢失）','fontsize',17,'fontweight','bold');
drawcase(ax,470,'Go-Back-N：丢弃 3、4、5，重传 2～5',false);
drawcase(ax,180,'选择性重传：缓存 3、4、5，只重传 2',true);
mtext(ax,W/2,56,'GBN 接收窗口 RWS=1，实现简单但重传量大；SR 接收窗口 RWS>1，效率高但需缓存乱序分组', ...
  'fontsize',10.5,'color',[0.28 0.28 0.28]);
msave(f,'fig07_gbn_sr.png');
end

function drawcase(ax,y0,titleStr,sel)
xs=120; xe=940; yS=y0+100; yR=y0;
mtext(ax,(xs+xe)/2,y0+168,titleStr,'fontsize',12.5,'fontweight','bold', ...
  'color',[0.62 0.20 0.20]);
plot(ax,[xs xe],[yS yS],'-','Color',[0.60 0.60 0.60],'LineWidth',1);
plot(ax,[xs xe],[yR yR],'-','Color',[0.60 0.60 0.60],'LineWidth',1);
mtext(ax,xs-14,yS,'发送方','halign','right','fontsize',10.5);
mtext(ax,xs-14,yR,'接收方','halign','right','fontsize',10.5);
maxis(ax,xs,xe,yR-38,'时间');
tx=[150 250 350 450 550];
names={'P0','P1','P2','P3','P4'};
for k=1:5
  if k==3 % P2 lost
    marrow(ax,tx(k),yS,tx(k)+55,(yS+yR)/2,'color',[0.16 0.42 0.72],'linewidth',1.7,'head',9);
    mtext(ax,tx(k)+45,(yS+yR)/2+14,'P2','fontsize',9,'color',[0.16 0.42 0.72]);
    plot(ax,tx(k)+30,(yS+yR)/2+4,'x','MarkerSize',14,'LineWidth',2.4,'Color',[0.80 0.15 0.15]);
    mtext(ax,tx(k)+12,(yS+yR)/2-16,'丢失','fontsize',9,'color',[0.80 0.15 0.15]);
  else
    marrow(ax,tx(k),yS,tx(k)+70,yR,'color',[0.16 0.42 0.72],'linewidth',1.6,'head',9);
    mtext(ax,tx(k)+34,(yS+yR)/2+12,names{k},'fontsize',9,'color',[0.16 0.42 0.72]);
  end
end
if ~sel
  % 接收方对 P3/P4 重复 ACK1
  for k=[4 5]
    marrow(ax,tx(k)+72,yR,tx(k)+120,yS,'color',[0.20 0.52 0.32],'linewidth',1.4,'head',8);
    mtext(ax,tx(k)+96,(yS+yR)/2-12,'ACK1','fontsize',8.5,'color',[0.20 0.52 0.32]);
  end
  % 超时重传 2..5
  rx=[640 735 830];
  for j=1:3
    k=j+2;
    marrow(ax,rx(j),yS,rx(j)+64,yR,'color',[0.80 0.44 0.10],'linewidth',1.9,'head',9);
    mtext(ax,rx(j)+30,(yS+yR)/2+14,names{k},'fontsize',9,'color',[0.80 0.44 0.10]);
  end
  mtext(ax,760,yS+38,'超时后回退重传 P2～P4','fontsize',9.5,'color',[0.80 0.44 0.10]);
else
  % ACK3/4/5 选择性确认
  for k=[4 5]
    marrow(ax,tx(k)+72,yR,tx(k)+120,yS,'color',[0.20 0.52 0.32],'linewidth',1.4,'head',8);
    mtext(ax,tx(k)+96,(yS+yR)/2-12,sprintf('ACK%d',k-1),'fontsize',8.5,'color',[0.20 0.52 0.32]);
  end
  % 只重传 P2
  marrow(ax,640,yS,704,yR,'color',[0.80 0.44 0.10],'linewidth',2.0,'head',9);
  mtext(ax,700,(yS+yR)/2+14,'只重传 P2','fontsize',9,'color',[0.80 0.44 0.10]);
  mtext(ax,760,yS+38,'接收方缓存 P3、P4、P5','fontsize',9.5,'color',[0.20 0.52 0.32]);
end
end
