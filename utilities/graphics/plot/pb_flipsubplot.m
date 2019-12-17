function pb_flipsubplot(varargin)
% PB_FLIPSUBPLOT()
%
% PB_FLIPSUBPLOT()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   v  = varargin;
   fig      = pb_keyval('fig',v,gcf);
   square 	= pb_keyval('axis',v,1);
   nicegr   = pb_keyval('nicegraph',v,1);
   
   h        = pb_fobj(fig,'Type','Axes');
   axesPos  = get(h, 'Position');
   hl       = length(h);
   
   %  Get Orientation
   col = [];
   row = [];
   for iAx = 1:hl
      col = [col axesPos{iAx}(1)];
      row = [row axesPos{iAx}(2)];
   end
   nrow = length(unique(col));
   ncol = length(unique(row));
   
   %  Swoop em
   tmp = figure('Position',[0 1 1 1]);
   for iRepos = 1:hl
      hSub(iRepos)         = subplot(nrow,ncol,iRepos);
      h(iRepos).Position   = hSub(iRepos).Position;
   end
   close(tmp);
   
   %  Set extra's
   if square
      for iAx = 1:length(h)
         h(iAx).PlotBoxAspectRatio = [1 1 1];
         h(iAx).PlotBoxAspectRatioMode = 'manual';
      end
   end
   if nicegr
      pb_nicegraph;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

