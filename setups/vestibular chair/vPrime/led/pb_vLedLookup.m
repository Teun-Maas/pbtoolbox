function ledArray = pb_vLedLookup(ledArray)
% PB_VLEDLOOKUP()
%
% PB_VLEDLOOKUP()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin == 0; return; end
   tmp = ledArray;
   
   for i = numel(ledArray)
      tmp(i) = lookup();
   end
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

