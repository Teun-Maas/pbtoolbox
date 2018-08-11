function bool = pb_or(logic)
% PB_OR(LOGIC)
%
% Iterates 'or'-logical operation on all elements of input argument.
%
% PB_OR(LOGIC)  returns true when any element is true, if all elements are
% false it will return false. If no input was provided, it returns false.
%
% See also PB_AND
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 

   if nargin <1
      bool = false;
      return
   end
    
   logic = logic(:);
   bool = logic(1);
   for i=1:length(logic)-1
      logic = logic(2:end);
      bool = or(bool,logic(1));
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

