function fig24_fsm
% TCP 状态机（主要路径）
[f,ax]=mnewfig(1100,620);
W=1100;H=620;
mtext(ax,W/2,H-26,'TCP 状态机（主要路径）','fontsize',17,'fontweight','bold');
S=struct();
S.CLOSED=[120 480]; S.LISTEN=[300 540]; S.SYN_RCVD=[500 540];
S.SYN_SENT=[300 400]; S.ESTAB=[520 400];
S.FIN1=[720 480]; S.FIN2=[880 480]; S.TIMEW=[880 340];
S.CLOSEW=[720 300]; S.LASTACK=[880 220];
fn=fieldnames(S);
for i=1:numel(fn)
  p=S.(fn{i});
  mbox(ax,p(1)-55,p(2)-18,110,36,fn{i},'fontsize',9.5,'fontweight','bold', ...
    'facecolor',[0.90 0.94 0.99]);
end
arr=@(a,b,str,dx,dy) arrowlab(ax,S.(a),S.(b),str,dx,dy);
arr('CLOSED','LISTEN','被动打开',0,16);
arr('CLOSED','SYN_SENT','主动打开/发SYN',0,-16);
arr('LISTEN','SYN_RCVD','收SYN/发SYNACK',0,16);
arr('SYN_SENT','ESTAB','收SYNACK/发ACK',0,-16);
arr('SYN_RCVD','ESTAB','收ACK',0,16);
arr('ESTAB','FIN1','关闭/发FIN',0,16);
arr('ESTAB','CLOSEW','收FIN/发ACK',0,-16);
arr('FIN1','FIN2','收ACK',0,16);
arr('FIN2','TIMEW','收FIN/发ACK',-30,0);
arr('CLOSEW','LASTACK','关闭/发FIN',30,0);
arr('LASTACK','CLOSED','收ACK',0,-16);
arr('TIMEW','CLOSED','2MSL 超时',0,-16);
mtext(ax,W/2,60,'同时关闭时还会经过 CLOSING 状态；TIME_WAIT 等待 2MSL，确保最后 ACK 可重传并让旧报文消失', ...
  'fontsize',10.2,'color',[0.28 0.28 0.28]);
msave(f,'fig24_fsm.png');
end

function arrowlab(ax,p1,p2,str,dx,dy)
marrow(ax,p1(1)+dx,p1(2)+dy,p2(1)+dx,p2(2)+dy,'color',[0.35 0.45 0.60],'linewidth',1.5,'head',8);
mx=(p1(1)+p2(1))/2+dx; my=(p1(2)+p2(2))/2+dy;
mtext(ax,mx,my+8,str,'fontsize',8.2,'color',[0.30 0.30 0.30]);
end
