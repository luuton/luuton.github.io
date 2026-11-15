function h = mnode(ax,x,y,r,str,varargin)
% 圆形节点
fc=[1 1 1]; ec=[0.30 0.30 0.30]; tc=[0.15 0.15 0.15]; lw=1.4; fs=12; fw='bold';
for i=1:2:numel(varargin)
  switch lower(varargin{i})
    case 'facecolor', fc=varargin{i+1};
    case 'edgecolor', ec=varargin{i+1};
    case 'textcolor', tc=varargin{i+1};
    case 'linewidth', lw=varargin{i+1};
    case 'fontsize',  fs=varargin{i+1};
    case 'fontweight',fw=varargin{i+1};
  end
end
th=linspace(0,2*pi,80);
patch(ax,x+r*cos(th),y+r*sin(th),fc,'EdgeColor',ec,'LineWidth',lw);
h=text(ax,x,y,str,'HorizontalAlignment','center','VerticalAlignment','middle', ...
  'FontName','Microsoft YaHei','FontSize',fs,'FontWeight',fw,'Color',tc);
end
