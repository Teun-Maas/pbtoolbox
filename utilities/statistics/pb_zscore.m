function Y = pb_zscore(X)
% PB_ZSCORE()
%
% PB_ZSCORE()  ...
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

   Y = (X-mean(X))/std(X);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

