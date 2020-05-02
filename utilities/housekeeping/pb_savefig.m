function pb_savefig(varargin)
% PB_SAVEFIG(varargin)
%
% PB_SAVEFIG saves a figure in a directory.
%
% See also PB_SAVEFIGS

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   n = nargin;

   fig     = pb_keyval('fig',varargin,gcf);
   
   fname   = pb_keyval('fname',varargin);
   dir     = pb_keyval('dir',varargin,[pb_datadir 'PhD/Figures/']);
   ext     = pb_keyval('ext',varargin,'epsc');
   cd(dir);

   figure(fig);
   g = groot;

   if n == 0 && ~isempty(g.Children)
      filter = {'*.fig';'*.eps';'*.pdf'};
      h = get(g,'currentFigure');
      [fname, fpath] = uiputfile(filter,[],strcat('Fig_',num2str(h.Number)));
   elseif n >= 1 && ~isempty(g.Children)
      fpath = dir;
   end

   h = get(g,'currentFigure'); 
   fpath = [fpath fname];
   %savefig(h,fpath);
   saveas(h,fpath,ext);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

