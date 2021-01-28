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

   h = pb_fobj(fig,'Type','Axes');
   n = length(h);

   p = zeros(1,n);

   for i = 1:n
      p(i) =  length(pb_fobj(h(i),'Type','Line','-not','Tag','Fixed')) + ... 
      length(pb_fobj(h(i),'Type','FunctionLine','-not','Tag','Fixed')) + ...
      length(pb_fobj(h(i),'Type','Bar','-not','Tag','Fixed')) + ...
      length(pb_fobj(h(i),'Type','Area','-not','Tag','Fixed')) + ...
      length(pb_fobj(h(i),'Type','ErrorBar','-not','Tag','Fixed')) + ...
      length(pb_fobj(h(i),'Type','Stem','-not','Tag','Fixed')) + ...
      length(pb_fobj(h(i),'Type','Histogram','-not','Tag','Fixed')) + ...
      length(pb_fobj(h(i),'Type','Patch','-not','Tag','Fixed'));
   end
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
