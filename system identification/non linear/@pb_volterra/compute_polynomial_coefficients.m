function obj = compute_polynomial_coefficients(obj)
% GET_POLYNOMIALCOEFFICIENTS()
%
% GET_POLYNOMIALCOEFFICIENTS()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   % Get relevant
   net      = obj.feedforwardnet;
   nhidden  = obj.netpar.nhidden;
   ninput   = obj.netpar.ninput;
   
   a = zeros([ninput,nhidden]);           % preallocate coefficients
   
   switch obj.polynomial_method
      
      case 'bias_correction'
         % Taylor series around zero by shifting the bias
         % Use: max bias exceeds pi/2
         
         % Single run symbolic derivatives for memory
         s = struct;
         for iD = 1:ninput
            if iD <= length(obj.kv.deriv_sigfun) 
               s(iD).sigf  = obj.kv.deriv_sigfun(iD).sigf; 
            else
               syms x
               sderiv   	= diff(tanh(x),iD-1);
               s(iD).sigf  = matlabFunction(sderiv);
            end
         end
         
         % Compute the coefficients
         for i = 1:nhidden
            for j = 1:ninput
               % Calculate the a_ji coefficients of p_i
               bias      	= obj.weights.bias(i);
               a(j,i)   	= 1/factorial(j-1) * s(j).sigf(bias); % * 2/pi
            end
         end
         
      case 'activation_function'
         % Calculate coefficients for using the output function
         % Use: small bias (<pi/2) and easy network activation function (no tansig!)
         fun = obj.netpar.activation_function;
         for i = 1:nhidden
            for j = 1:ninput
               % a(j,1) = ;
            end
         end
   end
   
   % Store coefficient
   obj.a    = a;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

