function mlink(ax,x1,y1,x2,y2,varargin)
% 无箭头连线（拓扑边）
col=[0.45 0.45 0.45]; lw=1.2; dash='-';
for i=1:2:numel(varargin)
  switch lower(varargin{i})
    case 'color',     col=varargin{i+1};
    case 'linewidth', lw=varargin{i+1};
    case 'dash',      dash=varargin{i+1};
  end
end
plot(ax,[x1 x2],[y1 y2],dash,'Color',col,'LineWidth',lw);
end
