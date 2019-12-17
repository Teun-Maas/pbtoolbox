function h = pb_puzzlegrid(h,sz,varargin)
% PB_PUZZLEGRID()
%
% PB_PUZZLEGRID()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   for i = length(h)
      h(i).Box          = 'on';
      h(i).XTickLabel   = {[]};
      h(i).YTickLabel   = {[]};
      h(i).XGrid        = 'on';
      h(i).YGrid        = 'on';

      h(i).XLim         = [1 sz(2)+1];
      h(i).YLim         = [1 sz(1)+1];

      axis square;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

