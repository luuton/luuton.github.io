function h = mdiamond(ax,x,y,w,hh,str,varargin)
% 判定框（菱形）：x,y 为中心
fc=[0.99 0.95 0.86]; ec=[0.72 0.52 0.20]; tc=[0.15 0.15 0.15];
lw=1.2; fs=11;
for i=1:2:numel(varargin)
  switch lower(varargin{i})
    case 'facecolor', fc=varargin{i+1};
    case 'edgecolor', ec=varargin{i+1};
    case 'textcolor', tc=varargin{i+1};
    case 'linewidth', lw=varargin{i+1};
    case 'fontsize',  fs=varargin{i+1};
  end
end
p=[x y+hh/2; x+w/2 y; x y-hh/2; x-w/2 y];
patch(ax,p(:,1),p(:,2),fc,'EdgeColor',ec,'LineWidth',lw);
h=text(ax,x,y,str,'HorizontalAlignment','center','VerticalAlignment','middle', ...
  'FontName','Microsoft YaHei','FontSize',fs,'Color',tc);
end
