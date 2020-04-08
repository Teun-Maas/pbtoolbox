function S = pb_stats(X)
% PB_STATS
%
% PB_STATS(X) obtains standard statistics from a data set
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   S.mu  = mean(X);
   S.std = std(X);
   S.se  = std(X)/sqrt(length(X));
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

