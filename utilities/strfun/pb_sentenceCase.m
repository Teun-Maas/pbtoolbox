function str = pb_sentenceCase(str)
% PB_SENTENCECASE(STR)
%
% PB_SENTENCECASE(STR) returns any input string in sentence case
% capitalization.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if isempty(str)
      return
   elseif length(str) == 1
      str = upper(str(1));
   elseif length(str) == 2
      str = [upper(str(1)) lower(str(2))];
   else
      str = [upper(str(1)) lower(str(2:end))];
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

