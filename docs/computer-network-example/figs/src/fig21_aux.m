function fig21_aux
% ARP 与 DHCP 报文交互
[f,ax]=mnewfig(1080,620);
W=1080;H=620;
mtext(ax,W/2,H-26,'辅助协议：ARP 与 DHCP','fontsize',17,'fontweight','bold');

mtext(ax,80,530,'ARP：广播请求、单播应答','halign','left','fontsize',12,'fontweight','bold','color',[0.14 0.40 0.72]);
xL=150; xR=520; yA=470; yB=370;
plot(ax,[xL xL],[yA yB],'-','Color',[0.65 0.65 0.65]);
plot(ax,[xR xR],[yA yB],'-','Color',[0.65 0.65 0.65]);
mtext(ax,xL,yA+16,'主机 X','fontsize',10.5);
mtext(ax,xR,yA+16,'主机 D','fontsize',10.5);
marrow(ax,xL+4,yA-10,xR-4,yA-40,'color',[0.16 0.42 0.72],'linewidth',1.8,'head',9);
mtext(ax,(xL+xR)/2,yA-8,'ARP 请求（广播）：谁是 137.196.7.78？','fontsize',8.8,'color',[0.16 0.42 0.72]);
marrow(ax,xR-4,yA-55,xL+4,yA-85,'color',[0.20 0.52 0.32],'linewidth',1.8,'head',9);
mtext(ax,(xL+xR)/2,yA-85,'ARP 应答（单播）：MAC = 1A-2F-BB-76-09-AD','fontsize',8.8,'color',[0.20 0.52 0.32]);
mtext(ax,335,yB-12,'缓存 <IP, MAC, TTL>','fontsize',8.5,'color',[0.40 0.40 0.40]);

mtext(ax,570,530,'DHCP：四报文获取配置','halign','left','fontsize',12,'fontweight','bold','color',[0.62 0.20 0.20]);
xd=650; xs=950; yTop=470; yBot=250;
plot(ax,[xd xd],[yBot yTop],'-','Color',[0.65 0.65 0.65]);
plot(ax,[xs xs],[yBot yTop],'-','Color',[0.65 0.65 0.65]);
mtext(ax,xd,yTop+16,'客户机','fontsize',10.5);
mtext(ax,xs,yTop+16,'DHCP 服务器','fontsize',10.5);
msgs={'DISCOVER（广播）','OFFER','REQUEST（广播）','ACK'};
yy=[445 395 345 295];
for k=1:4
  if mod(k,2)==1
    marrow(ax,xd+4,yy(k),xs-4,yy(k)-18,'color',[0.62 0.20 0.20],'linewidth',1.6,'head',8);
  else
    marrow(ax,xs-4,yy(k),xd+4,yy(k)-18,'color',[0.20 0.52 0.32],'linewidth',1.6,'head',8);
  end
  mtext(ax,(xd+xs)/2,yy(k)+2,msgs{k},'fontsize',8.5);
end
mtext(ax,800,yBot-14,'UDP 67 / 68','fontsize',8.5,'color',[0.40 0.40 0.40]);

mtext(ax,W/2,50,'ARP 只在本局域网内解析下一跳 MAC；DHCP 为主机动态分配 IP、掩码、默认网关和 DNS','fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig21_aux.png');
end
