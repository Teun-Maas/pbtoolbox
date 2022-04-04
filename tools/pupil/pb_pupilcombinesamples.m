function [az,el] = pb_pupilcombinesamples(az,el,varargin)
% PB_PUPILMEANSAMPLE()
%
% PB_PUPILMEANSAMPLE()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

   method = pb_keyval('method',varargin,'mean');

   % make even (so there always is a pair)!
   if ~iseven(length(az))
      az(end+1) = nan; el(end+1) = nan;
   end

   switch method
      case 'mean'
         az = nanmean([az(1:2:end); az(2:2:end)]);
         el = nanmean([el(1:2:end); el(2:2:end)]);
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

