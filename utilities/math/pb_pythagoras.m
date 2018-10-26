function c = pb_pythagoras(a,b)
% PB_PYTHAGORAS(a,b)
%
% PB_PYTHAGORAS(a,b)  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if mean(a)<0; sign = -1; else; sign = 1; end
   if mean(b)<0; sign = -1 * sign; end
   
   c = sqrt(a.^2 + b.^2) * sign;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

