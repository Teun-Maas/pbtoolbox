function [modulo,div] = pb_mod(a,b)
% PB_MOD
%
% PB_MOD(a,b) returns the modulo and the number of full divisions.
%
% See also MOD, REM

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   modulo   = mod(a,b);
   div      = floor(a/b);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

