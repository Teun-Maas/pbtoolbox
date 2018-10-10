function strOut = pb_sentenceCase(strIn)
% PB_SENTENCECASE(STR)
%
% PB_SENTENCECASE(STR) returns any input string in sentence case
% capitalization.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   strOut      = [];
   fullstop    = '. ';
   
   indFS       = strfind(strIn,fullstop);
   
   indFS(end+1) = length(strIn); indFS = unique(indFS);
   
   spStr = 1;
   
   for iFS = 1:length(indFS)
      tmp         = strIn(spStr:indFS(iFS));

      if isempty(tmp)
         return
      elseif length(tmp) == 1
         tmp = upper(tmp(1));
      elseif length(tmp) == 2
         tmp = [upper(tmp(1)) lower(tmp(2))];
      else
         tmp = [upper(tmp(1)) lower(tmp(2:end))];
      end
      
      if  length(strIn) < indFS(iFS)
            spStr = indFS(iFS)+1;
            if strIn(spStr) == ' '
               spStr = spStr+1;
               strOut(end+1) = ' ';
            end
      end
      
      
      strOut   = [strOut tmp];
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

