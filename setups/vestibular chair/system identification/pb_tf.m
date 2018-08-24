function [tf,h] = pb_tf(sys)
% PB_TF()
%
% PB_TF()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   clear h s N D;
   syms h s N D;
   
   n = sys.Numerator;
   d = sys.Denominator;
   
   N(s) = 0; D(s) = 0;
   
   for iN = 1:length(n)
      N(s) = N(s) + (n(iN)* s ^ (length(n)-iN));
   end
 
   for iD = 1:length(d)
      D(s) = D(s) + (d(iD)* s ^ (length(d)-iD));
   end
   h(s) = N(s)/D(s);
   tf = vpa(h,4);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

