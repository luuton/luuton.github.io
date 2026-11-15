function maxis(ax,x1,x2,y,str)
% 时间/数值轴
plot(ax,[x1 x2],[y y],'-','Color',[0.35 0.35 0.35],'LineWidth',1.2);
hs=8; ang=0;
p=[x2 y; x2-hs*cos(ang-0.34) y-hs*sin(ang-0.34); x2-hs*cos(ang+0.34) y-hs*sin(ang+0.34)];
patch(ax,p(:,1),p(:,2),[0.35 0.35 0.35],'EdgeColor',[0.35 0.35 0.35]);
text(ax,x2+6,y,str,'HorizontalAlignment','left','VerticalAlignment','middle', ...
  'FontName','Microsoft YaHei','FontSize',10,'Color',[0.35 0.35 0.35]);
end
