function R = pb_xcorr(x,y)
% PB_XCORR()
%
% PB_XCORR()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if nargin == 1; y = x; end
   
   % Get delays
   ndel     = length(x)*2-1;
   T        = floor(ndel/2);
   delays   = -T:T;
   
   
   R = 0;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

