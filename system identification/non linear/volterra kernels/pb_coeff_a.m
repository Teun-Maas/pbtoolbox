function a = pb_coeff_a(net,varargin)
% PB_COEFF_A()
%
% PB_COEFF_A() returns an array of a_ji coefficents
%
% See also ...
 
% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
 
   kmax  = pb_keyval('kmax',varargin,10);
   
   [nhidden,ninput]  = size(net.IW{1});
   
   a = zeros([ninput,nhidden]);        % preallocate coefficients
   for i = 1:nhidden
      for j = 1:ninput
         % Calculate the a_ji coefficients of p_i
         syms x
         sderiv   	= diff(tanh(x),j-1);
         sigfun   	= matlabFunction(sderiv);
         bias      	= net.b{1}(i);
         a(j,i)   	= 1/factorial(j-1) * sigfun(bias);
      end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

