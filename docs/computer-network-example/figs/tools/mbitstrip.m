function mbitstrip(ax,x,y,W,h,fields,varargin)
% 按位宽比例绘制横向字段条带
% fields 支持两种形式：
%   N x 3 cell：{label, bits, facecolor; ...}
%   1 x N cell：{{label,bits,color}, ...}
fs=10; showbits=true; rot=false; narrow=0;
for i=1:2:numel(varargin)
  switch lower(varargin{i})
    case 'fontsize',  fs=varargin{i+1};
    case 'showbits',  showbits=varargin{i+1};
    case 'rotate',    rot=varargin{i+1};
  end
end
if numel(fields)==1 && iscell(fields{1}) && numel(fields{1})==3
  fields = fields{1};
end
if iscell(fields{1})
  fields = vertcat(fields{:});
end
tot=sum(cell2mat(fields(:,2)));
cx=x;
for i=1:size(fields,1)
  w=W*fields{i,2}/tot;
  rectangle(ax,'Position',[cx y w h],'FaceColor',fields{i,3}, ...
     'EdgeColor',[0.28 0.28 0.28],'LineWidth',1.0);
  if w>56
    text(ax,cx+w/2,y+h/2,fields{i,1},'HorizontalAlignment','center', ...
      'VerticalAlignment','middle','FontName','Microsoft YaHei','FontSize',fs);
  elseif rot
    narrow=narrow+1;
    yoff=6+mod(narrow-1,3)*22;
    text(ax,cx+w/2,y+h+yoff,fields{i,1},'HorizontalAlignment','left', ...
      'VerticalAlignment','bottom','FontName','Microsoft YaHei','FontSize',fs-2,'Rotation',90);
  else
    text(ax,cx+w/2,y+h+9,fields{i,1},'HorizontalAlignment','center', ...
      'VerticalAlignment','bottom','FontName','Microsoft YaHei','FontSize',fs-1);
  end
  if showbits
    text(ax,cx+w/2,y-9,sprintf('%d bit',fields{i,2}), ...
      'HorizontalAlignment','center','VerticalAlignment','top', ...
      'FontName','Microsoft YaHei','FontSize',fs-2,'Color',[0.42 0.42 0.42]);
  end
  cx=cx+w;
end
plot(ax,[x x+W],[y y],'Color',[0.28 0.28 0.28],'LineWidth',1.0);
plot(ax,[x x+W],[y+h y+h],'Color',[0.28 0.28 0.28],'LineWidth',1.0);
end
