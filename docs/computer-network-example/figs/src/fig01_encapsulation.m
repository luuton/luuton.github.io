function fig01_encapsulation
% 逐层封装与解封装
[f,ax]=mnewfig(980,520);
W=980;H=520;
mtext(ax,W/2,H-28,'逐层数据封装与解封装','fontsize',16,'fontweight','bold');

names={'应用层','传输层','网络层','数据链路层'};
pdu   ={'消息 message','报文段 segment','数据报 datagram','帧 frame'};
colors=struct('M',[0.98 0.90 0.72],'Ht',[0.80 0.89 0.98], ...
              'Hn',[0.78 0.93 0.83],'Hl',[0.96 0.83 0.86]);
hdrs  ={{},{'Ht'},{'Hn','Ht'},{'Hl','Hn','Ht'}};

x0=250; ytop=400; dy=78;
for i=1:4
  y=ytop-(i-1)*dy;
  mtext(ax,x0-24,y+22,names{i},'halign','right','fontsize',12,'fontweight','bold');
  fields={};
  for k=1:numel(hdrs{i})
    fields(end+1,:)={hdrs{i}{k},70,colors.(hdrs{i}{k})}; %#ok<AGROW>
  end
  fields(end+1,:)={'M',240,colors.M};
  mbitstrip(ax,x0,y,360,44,fields,'fontsize',12,'showbits',false);
  mtext(ax,x0+400,y+22,pdu{i},'halign','left','fontsize',11,'color',[0.35 0.35 0.35]);
end
marrow(ax,88,410,88,140,'color',[0.16 0.42 0.72],'linewidth',1.8);
mtext(ax,88,424,'封装','fontsize',12,'color',[0.16 0.42 0.72],'fontweight','bold');
mtext(ax,72,118,'（发送方：逐层加首部）','halign','left','fontsize',10,'color',[0.35 0.35 0.35]);
marrow(ax,900,410,900,140,'color',[0.72 0.25 0.25],'linewidth',1.8);
mtext(ax,900,424,'解封装','fontsize',12,'color',[0.72 0.25 0.25],'fontweight','bold');
mtext(ax,958,118,'（接收方：逐层剥首部）','halign','right','fontsize',10,'color',[0.35 0.35 0.35]);
mtext(ax,W/2,74,'首部只在对应层有意义：路由器只处理到 Hn，交换机只处理到 Hl','fontsize',11,'color',[0.30 0.30 0.30]);
msave(f,'fig01_encapsulation.png');
end
