function fig23_crc
% CRC 模2除法与比特填充
[f,ax]=mnewfig(1060,560);
W=1060;H=560;
mtext(ax,W/2,H-26,'CRC 模 2 除法与比特填充','fontsize',17,'fontweight','bold');

% CRC 竖式（简化）
x0=80; y0=450;
mtext(ax,x0,500,'CRC：数据 10010110，C(x)=x^3+1（除数 1001）','halign','left','fontsize',11.5,'fontweight','bold','color',[0.14 0.40 0.72]);
lines={'10010110000','1001','00000110000','    1001','     01010','      1001','      0011 0','       0000','        110'};
% 更清晰的展示：直接给出步骤表
steps={ '① 数据后补 3 个 0','10010110 000';
        '② 模 2 除以 1001','余数 = 110';
        '③ 发送数据','10010110 110';
        '④ 接收方除 1001','余数 0 → 无错'};
for i=1:4
  y=430-(i-1)*62;
  mtext(ax,x0,y,steps{i,1},'halign','left','fontsize',11);
  mtext(ax,x0+210,y,steps{i,2},'halign','left','fontsize',11,'fontweight','bold','color',[0.16 0.42 0.72]);
end
mtext(ax,20,130,'模 2 运算：加/减不进位、不借位，等价于异或','halign','left','fontsize',9.8,'color',[0.35 0.35 0.35]);

% 比特填充
bx=560;
mtext(ax,bx,500,'比特填充：每 5 个连续 1 后插入 1 个 0','halign','left','fontsize',11.5,'fontweight','bold','color',[0.62 0.20 0.20]);
bits='011111101111110';
out='01111101011111010';
mtext(ax,bx,450,'原始比特：','halign','left','fontsize',10.5);
mtext(ax,bx+100,450,bits,'halign','left','fontsize',14,'fontname','Consolas');
mtext(ax,bx,410,'填充后：','halign','left','fontsize',10.5);
mtext(ax,bx+100,410,out,'halign','left','fontsize',14,'fontname','Consolas');
% 标记插入的0
for k=1:numel(out)
  if k<=numel(bits) && out(k)=='0'
  end
end
mtext(ax,bx,350,'接收方：5 个连续 1 后看到 0 → 删除；10 → 帧结束；11 → 错误', ...
  'halign','left','fontsize',9.6,'color',[0.35 0.35 0.35]);
mtext(ax,bx,320,'帧的起止：0x7E = 01111110','halign','left','fontsize',9.6,'color',[0.35 0.35 0.35]);
mtext(ax,bx,270,'HDLC、PPP 等面向比特的成帧采用比特填充；','halign','left','fontsize',9.6);
mtext(ax,bx,244,'面向字节的 BISYNC/PPP 采用字节填充（转义字符）。','halign','left','fontsize',9.6);

mtext(ax,W/2,50,'CRC 检错能力强、易于硬件实现；比特填充解决帧定界符在数据中出现的问题', ...
  'fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig23_crc.png');
end
