function runfigs(which)
% 批量生成图片：runfigs 或 runfigs({'fig01_encapsulation'})
here = fileparts(mfilename('fullpath'));
addpath(here);
addpath(fullfile(here,'src'));
addpath(fullfile(here,'tools'));
if nargin<1 || isempty(which)
    d = dir(fullfile(here,'src','fig*.m'));
    which = cellfun(@(s) s(1:end-2), {d.name}, 'UniformOutput', false);
elseif ischar(which)
    which = {which};
end
for i=1:numel(which)
    fprintf('--- %s ---\n',which{i});
    feval(which{i});
end
end
