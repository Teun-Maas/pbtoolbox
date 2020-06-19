function obj = compute_volterra_series(obj,order)
% SET_POLYNOMIAL_METHOD()
%
% SET_POLYNOMIAL_METHOD()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   % Check for kernels size
   if nargin < 2; order = 2; end
   len = obj.netpar.ninput;
   if len-1 < order; order = len-1; end
   
   % Add (additional) kernels if not computed
   if length(obj.kernels) < order+1 
      obj = compute_volterra_kernels(obj,order);
   end
   
   %% STILL TO DO
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

