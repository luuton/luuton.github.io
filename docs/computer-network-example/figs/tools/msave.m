function msave(f,name)
% 导出 PNG 到工程根目录下的 figs 文件夹
outdir = fullfile(fileparts(fileparts(mfilename('fullpath'))));
if ~exist(outdir,'dir'), mkdir(outdir); end
print(f,fullfile(outdir,name),'-dpng','-r200');
close(f);
fprintf('saved: %s\n', name);
end
