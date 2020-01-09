function y = pb_logspace(d1, d2, n, base)
% PB_LOGSPACE(D1,D2,N,BASE)
%
% Returns a log-spaced array of your input.
%
% PB_LOGSPACE(D1,D2,N,BASE) returns the logaritmic spaced array from d1 to
% d2 of size n.
%
% See also PB_LOG
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
   if nargin < 3; n = 50; end
   if nargin < 4; base = 10; end

   d1    = pb_log(d1,base);
   d2    = pb_log(d2,base);
   y     = base .^ linspace(d1, d2, n);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

