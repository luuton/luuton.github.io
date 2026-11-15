function fig17_cwnd
% TCP 拥塞窗口曲线 + AIMD
[f,ax]=mnewfig(1100,700);
W=1100;H=700;
mtext(ax,W/2,H-26,'TCP 拥塞窗口：慢启动、拥塞避免、快速重传/恢复','fontsize',17,'fontweight','bold');

ax2=axes('Parent',ax.Parent,'Units','pixels','Position',[120 120 560 480]);
hold(ax2,'on'); box(ax2,'on'); grid(ax2,'on');
r=1:26;
cw=zeros(size(r));
% 0-4 慢启动 1,2,4,8 ; 4-12 拥塞避免 +1 ; 12 超时 -> 1 ; 13-16 慢启动 1,2,4,6 ; 16-22 +1 ; 22 三重复ACK -> 减半
cw(1)=1; cw(2)=2; cw(3)=4; cw(4)=8;
for k=5:12, cw(k)=cw(k-1)+1; end
cw(13)=1; cw(14)=2; cw(15)=4; cw(16)=6;
for k=17:22, cw(k)=cw(k-1)+1; end
cw(23)=6; for k=24:26, cw(k)=cw(k-1)+1; end
plot(ax2,r,cw,'-o','LineWidth',2.2,'MarkerSize',4,'Color',[0.16 0.42 0.72], ...
  'MarkerFaceColor',[0.16 0.42 0.72]);
xlabel(ax2,'传输回合（RTT）','FontName','Microsoft YaHei','FontSize',10);
ylabel(ax2,'cwnd（MSS）','FontName','Microsoft YaHei','FontSize',10);
set(ax2,'FontName','Microsoft YaHei','FontSize',9.5);
xlim(ax2,[1 26]); ylim(ax2,[0 17]);
% 标注
text(ax2,2.2,3.5,'慢启动','FontName','Microsoft YaHei','FontSize',9,'Color',[0.20 0.52 0.32]);
text(ax2,7,4.6,'拥塞避免（+1/RTT）','FontName','Microsoft YaHei','FontSize',9,'Color',[0.55 0.40 0.10]);
text(ax2,9.3,16.2,'超时：cwnd=1，ssthresh=cwnd/2','FontName','Microsoft YaHei','FontSize',8.5,'Color',[0.72 0.15 0.15]);
text(ax2,15.0,10.2,'三重复 ACK：减半','FontName','Microsoft YaHei','FontSize',8.5,'Color',[0.72 0.15 0.15]);
% 标注线
plot(ax2,[12 12],[0 9.3],'--','Color',[0.72 0.15 0.15],'LineWidth',1);
plot(ax2,[22 22],[0 7.3],'--','Color',[0.72 0.15 0.15],'LineWidth',1);

% 右：AIMD 二维示意
ax3=axes('Parent',ax.Parent,'Units','pixels','Position',[750 190 300 380]);
hold(ax3,'on'); box(ax3,'on'); grid(ax3,'on');
plot(ax3,[0 10],[0 10],'--','Color',[0.55 0.55 0.55],'LineWidth',1.2);
text(ax3,5.6,8.8,'公平线 x_1=x_2','FontName','Microsoft YaHei','FontSize',8.5,'Color',[0.40 0.40 0.40]);
plot(ax3,[0 9],[9 0],':','Color',[0.70 0.45 0.15],'LineWidth',1.2);
text(ax3,7.0,1.6,'效率线','FontName','Microsoft YaHei','FontSize',8.5,'Color',[0.70 0.45 0.15]);
x=2; y=7; xs=[]; ys=[];
for it=1:4
  % 加性增加
  x2=min(x+1.5,9); y2=min(y+1.5,9);
  plot(ax3,[x x2],[y y2],'-','Color',[0.16 0.42 0.72],'LineWidth',2);
  % 乘性减小
  plot(ax3,[x2 x2*0.6],[y2 y2*0.6],'-','Color',[0.72 0.20 0.20],'LineWidth',2);
  x=x2*0.6; y=y2*0.6;
end
xlabel(ax3,'流 1 窗口 x_1','FontName','Microsoft YaHei','FontSize',9);
ylabel(ax3,'流 2 窗口 x_2','FontName','Microsoft YaHei','FontSize',9);
xlim(ax3,[0 10]); ylim(ax3,[0 10]);
set(ax3,'FontName','Microsoft YaHei','FontSize',9);
title(ax3,'AIMD 收敛','FontName','Microsoft YaHei','FontSize',10);
mtext(ax,W/2,52,'无拥塞：每 RTT cwnd +1 MSS；拥塞：cwnd 减小（超时降为 1，3 个重复 ACK 减半）', ...
  'fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig17_cwnd.png');
end
