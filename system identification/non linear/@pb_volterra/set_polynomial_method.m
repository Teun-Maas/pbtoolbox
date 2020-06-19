function obj = set_polynomial_method(obj,polynomial_method)
% SET_POLYNOMIAL_METHOD()
%
% SET_POLYNOMIAL_METHOD()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   switch polynomial_method
      case 'activation_function'
         select = polynomial_method;
      otherwise
         select = 'bias_correction';
   end
   
   obj.polynomial_method = select;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

