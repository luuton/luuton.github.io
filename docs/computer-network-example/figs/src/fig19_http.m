function fig19_http
% HTTP 非坚持/坚持/流水线 时间对比
[f,ax]=mnewfig(1080,650);
W=1080;H=650;
mtext(ax,W/2,H-26,'HTTP：非坚持式 vs 坚持式（RTT 开销）','fontsize',17,'fontweight','bold');
drawhttp(ax,480,'非坚持式：每个对象 2 RTT',0);
drawhttp(ax,300,'坚持式：基础对象 2 RTT，之后每个对象 1 RTT',1);
drawhttp(ax,120,'坚持式 + 流水线：所有引用对象共用 1 RTT',2);
mtext(ax,W/2,46,'忽略传输时间；非坚持式每个对象都要重新建立 TCP 连接，RTT 开销最大', ...
  'fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig19_http.png');
end

function drawhttp(ax,y0,titleStr,mode)
x0=120; xEnd=940;
mtext(ax,x0,y0+80,titleStr,'halign','left','fontsize',11.5,'fontweight','bold','color',[0.14 0.40 0.72]);
plot(ax,[x0 xEnd],[y0 y0],'-','Color',[0.70 0.70 0.70],'LineWidth',1);
maxis(ax,x0,xEnd,y0-28,'时间');
n=10; % 引用对象数
if mode==0
  R=0.032; % 每个对象 2RTT 宽度
  for k=0:n
    xx=x0+20+k*2*R*760;
    rectangle(ax,'Position',[xx y0-8 R*760 16],'FaceColor',[0.80 0.88 0.98],'EdgeColor',[0.25 0.45 0.70]);
    mtext(ax,xx+R*760/2,y0,'TCP','fontsize',6.5);
    rectangle(ax,'Position',[xx+R*760 y0-8 R*760 16],'FaceColor',[0.86 0.94 0.86],'EdgeColor',[0.25 0.55 0.30]);
    mtext(ax,xx+1.5*R*760,y0,'请求/响应','fontsize',6.2);
  end
elseif mode==1
  % 基础对象 2RTT，然后每个对象 1RTT
  xx=x0+20;
  rectangle(ax,'Position',[xx y0-8 2*0.035*760 16],'FaceColor',[0.80 0.88 0.98],'EdgeColor',[0.25 0.45 0.70]);
  mtext(ax,xx+0.035*760,y0,'基础 HTML（2RTT）','fontsize',7.5);
  xx=xx+2*0.035*760;
  for k=1:n
    rectangle(ax,'Position',[xx y0-8 0.035*760 16],'FaceColor',[0.86 0.94 0.86],'EdgeColor',[0.25 0.55 0.30]);
    mtext(ax,xx+0.0175*760,y0,sprintf('%d',k),'fontsize',6.5);
    xx=xx+0.035*760;
  end
else
  xx=x0+20;
  rectangle(ax,'Position',[xx y0-8 2*0.035*760 16],'FaceColor',[0.80 0.88 0.98],'EdgeColor',[0.25 0.45 0.70]);
  mtext(ax,xx+0.035*760,y0,'基础 HTML（2RTT）','fontsize',7.5);
  xx=xx+2*0.035*760;
  rectangle(ax,'Position',[xx y0-8 0.035*760 16],'FaceColor',[0.86 0.94 0.86],'EdgeColor',[0.25 0.55 0.30]);
  mtext(ax,xx+0.0175*760,y0,'全部引用对象（1RTT）','fontsize',7.2);
end
end
