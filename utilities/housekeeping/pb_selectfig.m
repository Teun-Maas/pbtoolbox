function h = pb_selectfig(h)
% PB_SELECTFIG(h)
%
% PB_SELECTFIG(h) selects figure from handle.
%
% See also PB_SELECTAXIS, PB_IMPLOT
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if isnumeric(h) 
      g = groot; z = h;
      for iFig = 1:length(g.Children)
         if h == g.Children(iFig).Number
            h = g.Children(iFig);
         end
         h = figure(h);
      end
      if isnumeric(h)
         h = figure(gcf);
         disp(['The figure(' num2str(z) ') requested could not be found. The defaulft handle is figure(' num2str(h.Number) ')']);
      end
   elseif isgraphics(h)
      figure(h);
      return;
   else
      error('Input type for "h" should be either numeric or graphics');
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

