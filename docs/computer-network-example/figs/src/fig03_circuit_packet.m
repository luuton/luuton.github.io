function fig03_circuit_packet
% 电路交换（TDM 确定型复用） vs 分组交换（统计型复用）
[f,ax]=mnewfig(1080,760);
W=1080;H=760;
mtext(ax,W/2,H-26,'电路交换 vs 分组交换：资源共享方式','fontsize',17,'fontweight','bold');

T=10; x0=165; WX=690; ns=4; hb=26; dg=8;
% ---- 电路交换 ----
yA=556;
mtext(ax,W/2,yA+64,'电路交换：每个呼叫固定占用时隙（确定型复用）','fontsize',12.5,'fontweight','bold','color',[0.62 0.40 0.14]);
pat=[1 1 0 1 1 0 1 0 0 1;
     0 0 1 0 0 1 0 1 1 0;
     1 0 0 1 0 0 0 0 1 0;
     0 1 0 0 1 0 1 1 0 0];
for u=1:ns
  y=yA-(u-1)*(hb+dg);
  mtext(ax,x0-16,y+hb/2,sprintf('呼叫 %d',u),'halign','right','fontsize',11);
  for t=1:T
    xx=x0+(t-1)*WX/T;
    if pat(u,t)
      rectangle(ax,'Position',[xx y WX/T hb],'FaceColor',[0.84 0.90 0.98], ...
        'EdgeColor',[0.25 0.35 0.60],'LineWidth',0.9);
      mtext(ax,xx+WX/T/2,y+hb/2,'数据','fontsize',8.5,'color',[0.22 0.30 0.55]);
    else
      rectangle(ax,'Position',[xx y WX/T hb],'FaceColor',[0.95 0.95 0.95], ...
        'EdgeColor',[0.72 0.72 0.72],'LineWidth',0.9,'LineStyle',':');
      mtext(ax,xx+WX/T/2,y+hb/2,'空闲','fontsize',8.5,'color',[0.60 0.60 0.60]);
    end
  end
end
maxis(ax,x0,x0+WX,yA-ns*(hb+dg)-14,'时间');
mtext(ax,x0+WX+56,yA+40,{'资源片闲置时','不能给其它','呼叫使用'},'halign','left','fontsize',9.5,'color',[0.72 0.22 0.22]);

% ---- 分组交换 ----
yB=306;
mtext(ax,W/2,yB+62,'分组交换：按需占用（统计型复用）','fontsize',12.5,'fontweight','bold','color',[0.14 0.40 0.72]);
cols=[0.80 0.88 0.98; 0.98 0.86 0.82; 0.84 0.94 0.84; 0.98 0.94 0.80];
ons={[1 2 3 6 9],[2 5 6 7],[1 4 8 9 10],[3 4 8]};
for u=1:ns
  y=yB-(u-1)*(hb+dg);
  mtext(ax,x0-16,y+hb/2,sprintf('流 %d',u),'halign','right','fontsize',11);
  for t=1:T
    xx=x0+(t-1)*WX/T;
    if any(ons{u}==t)
      rectangle(ax,'Position',[xx y WX/T hb],'FaceColor',cols(u,:), ...
        'EdgeColor',[0.35 0.35 0.35],'LineWidth',0.9);
      mtext(ax,xx+WX/T/2,y+hb/2,'分组','fontsize',8.5);
    else
      rectangle(ax,'Position',[xx y WX/T hb],'FaceColor',[1 1 1], ...
        'EdgeColor',[0.86 0.86 0.86],'LineWidth',0.9);
    end
  end
end
maxis(ax,x0,x0+WX,yB-ns*(hb+dg)-14,'时间');
mtext(ax,x0+WX+56,yB+40,{'空闲资源可被','其它分组流','按需使用'},'halign','left','fontsize',9.5,'color',[0.14 0.40 0.72]);

mtext(ax,W/2,36,'电路交换：资源利用率低，但带宽/时延有保证；分组交换：利用率高，但存在拥塞与丢包', ...
  'fontsize',11,'color',[0.28 0.28 0.28]);
msave(f,'fig03_circuit_packet.png');
end
