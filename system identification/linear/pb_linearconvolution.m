function yhat = pb_linearconvolution(x,h)
% PB_LINEARCONVOLUTION
%
% PB_LINEARCONVOLUTION(x,y,h)  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   memory   = length(h);
   yhat     = nan(size(x));
   ylen     = length(x);
   
   for iS = memory:ylen
      current_value  = 0;
      xsel           = fliplr(x(iS-(memory-1):iS)); 
   
      for iI = 1:memory
         current_value  = current_value + (xsel(iI) .* h(iI));
      end
      yhat(iS) = current_value;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 