function col = pb_selectcolor(N,def)
% PB_SELECTCOLOR()
%
%   in: number of colors, and type
%
%   out: array of selected colors.
% See also PB_NICEGRAPH, PB_STATCOLOR.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin < 1; N = length(findobj(gca,'Type','line')); end
   if nargin < 2; def = 2; end

   col = pb_statcolor(N,[],[],[],'def',def);
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 