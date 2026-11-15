function h = mbox(ax,x,y,w,hh,str,varargin)
% 圆角矩形 + 居中文字；x,y 为左下角
fc=[0.90 0.94 0.99]; ec=[0.16 0.42 0.72]; tc=[0.10 0.10 0.10];
lw=1.2; fs=12; fw='normal'; curv=[0.08 0.16];
for i=1:2:numel(varargin)
  switch lower(varargin{i})
    case 'facecolor',  fc=varargin{i+1};
    case 'edgecolor',  ec=varargin{i+1};
    case 'textcolor',  tc=varargin{i+1};
    case 'linewidth',  lw=varargin{i+1};
    case 'fontsize',   fs=varargin{i+1};
    case 'fontweight', fw=varargin{i+1};
    case 'curvature',  curv=varargin{i+1};
  end
end
rectangle(ax,'Position',[x y w hh],'Curvature',curv, ...
   'FaceColor',fc,'EdgeColor',ec,'LineWidth',lw);
h = text(ax,x+w/2,y+hh/2,str,'HorizontalAlignment','center', ...
   'VerticalAlignment','middle','FontName','Microsoft YaHei', ...
   'FontSize',fs,'Color',tc,'FontWeight',fw);
end
