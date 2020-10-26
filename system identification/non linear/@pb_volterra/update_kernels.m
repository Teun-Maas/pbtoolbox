function obj = update_kernels(obj,volterra_series)
% SET_POLYNOMIAL_METHOD()
%
% SET_POLYNOMIAL_METHOD()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

  % Normalize all kernels for each iteration
  
   serieslen   = length(volterra_series);
   order       = length(volterra_series(1).kernels)-1;
   memory      = volterra_series(1).netpar.ninput;
   
   kernels = struct;
   for iO = 1:order+1
      kernels(iO).kernel = zeros(size(volterra_series(1).kernels(iO).kernel));
   end
   
   
   for iS = 1:serieslen
      for iO = 1:order+1
         kernels(iO).kernel    	= kernels(iO).kernel + volterra_series(iS).kernels(iO).kernel;
         kernels(iO).order    	= iO-1; 
      end
   end
   
   for iO = 1:order+1
      kernels(iO).kernel = kernels(iO).kernel ./ serieslen;  % mean
   end
   obj.kernels = kernels;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

