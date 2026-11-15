function h = melbow(ax,pts,varargin)
% 正交折线箭头：pts 为 N x 2 顶点（列：x y），箭头画在最后一段终点
col=[0.40 0.40 0.40]; lw=1.5; hs=9; dash='-';
for i=1:2:numel(varargin)
  switch lower(varargin{i})
    case 'color',     col=varargin{i+1};
    case 'linewidth', lw=varargin{i+1};
    case 'head',      hs=varargin{i+1};
    case 'dash',      dash=varargin{i+1};
  end
end
h = plot(ax,pts(:,1),pts(:,2),dash,'Color',col,'LineWidth',lw);
% 箭头
p1=pts(end-1,:); p2=pts(end,:);
ang=atan2(p2(2)-p1(2),p2(1)-p1(1));
tip=p2;
base=p2-hs*[cos(ang) sin(ang)];
n=[-sin(ang) cos(ang)];
tri=[tip; base+n*hs*0.42; base-n*hs*0.42];
patch(ax,tri(:,1),tri(:,2),col,'EdgeColor',col,'LineWidth',0.1);
end
