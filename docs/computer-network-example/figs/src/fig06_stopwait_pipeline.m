function fig06_stopwait_pipeline
% 停止等待 vs 流水线（滑动窗口）
[f,ax]=mnewfig(1040,720);
W=1040;H=720;
mtext(ax,W/2,H-26,'停止等待 vs 流水线发送','fontsize',17,'fontweight','bold');

drawpanel(ax,480,'停止等待：每个 RTT 只发送 1 个分组',false);
drawpanel(ax,190,'滑动窗口：连续发送多个分组（SWS = 4）',true);
mtext(ax,W/2,60,'流水线发送使发送方在等待 ACK 期间继续占用链路，发送批量接近时延带宽积 RTT×R 时可填满管道', ...
  'fontsize',10.5,'color',[0.28 0.28 0.28]);
msave(f,'fig06_stopwait_pipeline.png');
end

function drawpanel(ax,y0,titleStr,pipeline)
xs=130; xe=930; yS=y0+95; yR=y0;
mtext(ax,(xs+xe)/2,y0+165,titleStr,'fontsize',12.5,'fontweight','bold', ...
  'color',[0.14 0.40 0.72]);
plot(ax,[xs xe],[yS yS],'-','Color',[0.60 0.60 0.60],'LineWidth',1);
plot(ax,[xs xe],[yR yR],'-','Color',[0.60 0.60 0.60],'LineWidth',1);
mtext(ax,xs-16,yS,'发送方','halign','right','fontsize',10.5);
mtext(ax,xs-16,yR,'接收方','halign','right','fontsize',10.5);
maxis(ax,xs,xe,yR-38,'时间');
if ~pipeline
  ts=[170 400 630];
  for k=1:3
    marrow(ax,ts(k),yS,ts(k)+70,yR,'color',[0.16 0.42 0.72],'linewidth',1.8,'head',9);
    mtext(ax,ts(k)+35,(yS+yR)/2+10,sprintf('数据 %d',k),'fontsize',9,'color',[0.16 0.42 0.72]);
    marrow(ax,ts(k)+80,yR,ts(k)+150,yS,'color',[0.20 0.52 0.32],'linewidth',1.8,'head',9);
    mtext(ax,ts(k)+118,(yS+yR)/2-12,sprintf('ACK %d',k),'fontsize',9,'color',[0.20 0.52 0.32]);
    % 空闲区
    rectangle(ax,'Position',[ts(k)+70 yS-8 80 16],'FaceColor',[0.93 0.93 0.93], ...
      'EdgeColor',[0.80 0.80 0.80],'LineWidth',0.8);
    mtext(ax,ts(k)+110,yS,'链路空闲','fontsize',8.5,'color',[0.55 0.55 0.55]);
  end
else
  ts=150:95:530;
  for k=1:5
    marrow(ax,ts(k),yS,ts(k)+70,yR,'color',[0.16 0.42 0.72],'linewidth',1.7,'head',9);
    mtext(ax,ts(k)+34,(yS+yR)/2+10,sprintf('P%d',k),'fontsize',9,'color',[0.16 0.42 0.72]);
    if k<=4
      marrow(ax,ts(k)+80,yR,ts(k)+150,yS,'color',[0.20 0.52 0.32],'linewidth',1.5,'head',8);
      mtext(ax,ts(k)+116,(yS+yR)/2-12,sprintf('ACK%d',k),'fontsize',8.5,'color',[0.20 0.52 0.32]);
    end
  end
  rectangle(ax,'Position',[ts(1) yS+16 ts(4)+70-ts(1) 18],'FaceColor',[0.90 0.95 0.99], ...
    'EdgeColor',[0.16 0.42 0.72],'LineWidth',0.9,'Curvature',[0.2 0.5]);
  mtext(ax,(ts(1)+ts(4)+70)/2,yS+25,'SWS = 4：未收到 ACK 前可连续发送','fontsize',9,'color',[0.16 0.42 0.72]);
end
end
