function [A,ind] = pb_rmnan(A)
% PB_RMNAN()
%
% PB_RMNAN() will remove all NaN values from array
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   ind = isnan(A);
   A = A(~ind);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

