function fig09_frames
% 以太网帧与 802.11 帧格式
[f,ax]=mnewfig(1100,620);
W=1100;H=620;
mtext(ax,W/2,H-26,'以太网帧与 802.11 帧格式（按位宽比例）','fontsize',17,'fontweight','bold');

% 以太网
mtext(ax,120,520,'以太网 802.3 帧','halign','left','fontsize',13,'fontweight','bold','color',[0.14 0.40 0.72]);
eth={ {'前导码',64,[0.90 0.90 0.90]}, {'目的 MAC',48,[0.82 0.90 0.98]}, ...
      {'源 MAC',48,[0.82 0.90 0.98]}, {'类型',16,[0.86 0.94 0.86]}, ...
      {'数据（46～1500 B）',368,[0.99 0.92 0.78]}, {'FCS',32,[0.96 0.84 0.86]} };
% 用比例示意（数据取 46B 最小）
mbitstrip(ax,150,440,860,54,eth,'fontsize',10.5,'showbits',false);
mtext(ax,150,424,'注：数据字段 46～1500 B；帧长（不含前导码）64～1518 B','fontsize',9.5,'color',[0.40 0.40 0.40]);

% 802.11
mtext(ax,110,390,'802.11 帧','halign','left','fontsize',13,'fontweight','bold','color',[0.62 0.20 0.20]);
wifi={ {'Frame Control',16,[0.90 0.90 0.90]}, {'Duration',16,[0.94 0.94 0.94]}, ...
       {'Address 1',48,[0.82 0.90 0.98]}, {'Address 2',48,[0.86 0.94 0.86]}, ...
       {'Address 3',48,[0.99 0.92 0.78]}, {'Seq',16,[0.94 0.94 0.94]}, ...
       {'Address 4',48,[0.96 0.84 0.86]}, {'Payload（0～2312 B）',320,[0.88 0.92 0.99]}, ...
       {'FCS',32,[0.90 0.90 0.90]} };
mbitstrip(ax,110,240,900,54,wifi,'fontsize',9.5,'showbits',false,'rotate',true);

% 地址说明
by=90;
rectangle(ax,'Position',[110 by 900 110],'Curvature',[0.05 0.08], ...
  'FaceColor',[0.98 0.98 0.99],'EdgeColor',[0.70 0.70 0.75],'LineWidth',1);
mtext(ax,140,by+88,'Address 1：本帧接收者（主机或 AP）的 MAC', 'halign','left','fontsize',10);
mtext(ax,140,by+64,'Address 2：本帧发送者（主机或 AP）的 MAC', 'halign','left','fontsize',10);
mtext(ax,140,by+40,'Address 3：AP 所连接的路由器 MAC（跨 BSS 转发的最终目的/源）', 'halign','left','fontsize',10);
mtext(ax,670,by+52,'Address 4：仅用于自组织模式','halign','left','fontsize',10);
mtext(ax,W/2,42,'802.11 帧最多 4 个地址字段，这是与以太网帧最显著的格式差异','fontsize',10.5,'color',[0.30 0.30 0.30]);
msave(f,'fig09_frames.png');
end
