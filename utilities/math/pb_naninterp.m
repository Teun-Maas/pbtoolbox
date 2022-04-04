function y = pb_naninterp(x,varargin)
% PB_NANINTERP
%
% PB_NANINTERP(x)  will interpolate nan values in array data.
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl
   
   x = x(:);

   nanbool  = isnan(x);
   anbool   = ~nanbool;
   numidx   = find(anbool);
   
   first = x(numidx(1));
   last  = x(numidx(end));
   
   xn    = [first; x; last];
   
   dnan  = [0; diff(double([0; nanbool; 0]))];
   don   = find(dnan == 1);
   doff  = find(dnan == -1);
   
   for iN = 1:length(don)
      xn(don(iN):doff(iN)-1) = ones(size(don(iN):doff(iN)-1)) * mean([xn(don(iN)-1) xn(doff(iN))]);
   end
   
   y = xn(2:end-1);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

