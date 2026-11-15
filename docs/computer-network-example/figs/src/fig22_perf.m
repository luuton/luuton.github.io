function fig22_perf
% 排队时延与拥塞：knee / cliff
[f,ax]=mnewfig(1080,520);
W=1080;H=520;
mtext(ax,W/2,H-26,'网络性能：排队时延与拥塞','fontsize',17,'fontweight','bold');

ax1=axes('Parent',ax.Parent,'Units','pixels','Position',[90 110 400 360]);
hold(ax1,'on'); grid(ax1,'on'); box(ax1,'on');
r=0:0.01:0.99; d=0.2*r./(1-r);
plot(ax1,r,d,'LineWidth',2.2,'Color',[0.16 0.42 0.72]);
xlabel(ax1,'流量强度 \rho = La/R','FontName','Microsoft YaHei','FontSize',10);
ylabel(ax1,'平均排队时延（相对值）','FontName','Microsoft YaHei','FontSize',10);
title(ax1,'排队时延随负载急剧上升','FontName','Microsoft YaHei','FontSize',11);
set(ax1,'FontName','Microsoft YaHei','FontSize',9.5);
ylim(ax1,[0 18]); xlim(ax1,[0 1]);
text(ax1,0.30,2.5,'\rho 小：时延小','FontName','Microsoft YaHei','FontSize',9);
text(ax1,0.58,12,'\rho → 1：时延趋于无穷','FontName','Microsoft YaHei','FontSize',9,'Color',[0.72 0.15 0.15]);

ax2=axes('Parent',ax.Parent,'Units','pixels','Position',[620 110 400 360]);
hold(ax2,'on'); grid(ax2,'on'); box(ax2,'on');
L=0:0.01:1.2;
th=1.15*L; th(L>0.8)=1.15*0.8-3.4*(L(L>0.8)-0.8); th=max(th,0);
de=0.10+0.35*L+1.6*L.^6;
plot(ax2,L,th,'LineWidth',2.2,'Color',[0.16 0.42 0.72]);
plot(ax2,L,de,'LineWidth',2.2,'Color',[0.72 0.25 0.15]);
xlabel(ax2,'负载','FontName','Microsoft YaHei','FontSize',10);
ylabel(ax2,'归一化数值','FontName','Microsoft YaHei','FontSize',10);
title(ax2,'吞吐量 / 时延 vs 负载','FontName','Microsoft YaHei','FontSize',11);
legend(ax2,{'吞吐量','时延'},'FontName','Microsoft YaHei','FontSize',9,'Location','northwest');
set(ax2,'FontName','Microsoft YaHei','FontSize',9.5);
xlim(ax2,[0 1.2]); ylim(ax2,[0 2.0]);
plot(ax2,[0.8 0.8],[0 1.9],'--','Color',[0.55 0.55 0.55],'LineWidth',1,'HandleVisibility','off');
text(ax2,0.66,1.40,'knee','FontName','Microsoft YaHei','FontSize',9);
text(ax2,0.86,0.30,'cliff','FontName','Microsoft YaHei','FontSize',9,'Color',[0.72 0.15 0.15]);
mtext(ax,W/2,50,'拐点（knee）：吞吐增长变慢、时延上升；断崖（cliff）：吞吐骤降、时延趋于无穷（拥塞崩溃）', ...
  'fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig22_perf.png');
end
