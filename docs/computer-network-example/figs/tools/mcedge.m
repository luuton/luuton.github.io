function h = mcedge(ax,p1,p2,r1,r2,varargin)
% 沿两个圆心的连线绘制箭头：起点、终点均落在圆周上，可整体垂直偏移
col=[0.40 0.40 0.40]; lw=1.5; hs=9; dash='-'; off=0;
for i=1:2:numel(varargin)
  switch lower(varargin{i})
    case 'color',     col=varargin{i+1};
    case 'linewidth', lw=varargin{i+1};
    case 'head',      hs=varargin{i+1};
    case 'dash',      dash=varargin{i+1};
    case 'offset',    off=varargin{i+1};
  end
end
d=p2-p1; L=norm(d); u=d/L; nrm=[-u(2) u(1)];
a=p1+u*r1+nrm*off;
b=p2-u*r2+nrm*off;
h=plot(ax,[a(1) b(1)],[a(2) b(2)],dash,'Color',col,'LineWidth',lw);
ang=atan2(b(2)-a(2),b(1)-a(1));
base=b-hs*[cos(ang) sin(ang)];
nn=[-sin(ang) cos(ang)];
tri=[b; base+nn*hs*0.42; base-nn*hs*0.42];
patch(ax,tri(:,1),tri(:,2),col,'EdgeColor',col,'LineWidth',0.1);
end
