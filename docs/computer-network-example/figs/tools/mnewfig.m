function [f,ax] = mnewfig(w,h)
% 新建白底、无坐标轴的绘图画布；坐标系单位为像素（左下角为原点）
f = figure('Visible','off','Color',[1 1 1],'Units','pixels', ...
           'Position',[80 80 w h],'PaperPositionMode','auto');
ax = axes(f,'Units','pixels','Position',[0 0 w h]);
hold(ax,'on');
axis(ax,[0 w 0 h]);
axis(ax,'off');
set(ax,'Clipping','off');
end
