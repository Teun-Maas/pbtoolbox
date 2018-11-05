function [n,p] = pb_defsubplot(fig)    
% PB_DEFSUBPLOT
%
% Defines the number of Axes, their orientation in the figure and the
% number of plots per axes
%
% PB_DEFSUBPLOT(FIG) scans figure for number of axes, thier orientation and number of plots.
%
% See also PB_NICEGRAPH

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   figure(fig);
   h = flipud(findobj(gcf,'Type','Axes'));
   n = length(h);

   p = zeros(1,n);

   for i = 1:n
      p(i) =  length(findobj(h(i),'Type','Line')) + ... 
      length(findobj(h(i),'Type','FunctionLine')) + ...
      length(findobj(h(i),'Type','Bar')) + ...
      length(findobj(h(i),'Type','Area')) + ...
      length(findobj(h(i),'Type','ErrorBar')) + ...
      length(findobj(h(i),'Type','Histogram'));
   end
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
