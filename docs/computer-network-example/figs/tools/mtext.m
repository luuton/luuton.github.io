function h = mtext(ax,x,y,str,varargin)
fs=11; col=[0.15 0.15 0.15]; ha='center'; va='middle'; fw='normal'; rot=0;
for i=1:2:numel(varargin)
  switch lower(varargin{i})
    case 'fontsize',   fs=varargin{i+1};
    case 'color',      col=varargin{i+1};
    case 'halign',     ha=varargin{i+1};
    case 'valign',     va=varargin{i+1};
    case 'fontweight', fw=varargin{i+1};
    case 'rotation',   rot=varargin{i+1};
  end
end
h = text(ax,x,y,str,'HorizontalAlignment',ha,'VerticalAlignment',va, ...
   'FontName','Microsoft YaHei','FontSize',fs,'Color',col, ...
   'FontWeight',fw,'Rotation',rot);
end
