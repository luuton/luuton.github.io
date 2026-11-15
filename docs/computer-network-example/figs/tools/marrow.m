function h = marrow(ax,x1,y1,x2,y2,varargin)
% 带箭头直线
col=[0.30 0.30 0.30]; lw=1.3; hs=9; dash='-'; both=false;
for i=1:2:numel(varargin)
  switch lower(varargin{i})
    case 'color',     col=varargin{i+1};
    case 'linewidth', lw=varargin{i+1};
    case 'head',      hs=varargin{i+1};
    case 'dash',      dash=varargin{i+1};
    case 'both',      both=varargin{i+1};
  end
end
ang=atan2(y2-y1,x2-x1);
h = plot(ax,[x1 x2],[y1 y2],dash,'Color',col,'LineWidth',lw);
p=[x2 y2; x2-hs*cos(ang-0.34) y2-hs*sin(ang-0.34); ...
   x2-hs*cos(ang+0.34) y2-hs*sin(ang+0.34)];
patch(ax,p(:,1),p(:,2),col,'EdgeColor',col,'LineWidth',0.1);
if both
  a2=ang+pi;
  q=[x1 y1; x1-hs*cos(a2-0.34) y1-hs*sin(a2-0.34); ...
     x1-hs*cos(a2+0.34) y1-hs*sin(a2+0.34)];
  patch(ax,q(:,1),q(:,2),col,'EdgeColor',col,'LineWidth',0.1);
end
end
