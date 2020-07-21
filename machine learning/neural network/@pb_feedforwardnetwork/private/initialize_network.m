function obj = initialize_network(obj)
% COMPUTE_NODE_OUTPUT
%
% COMPUTE_NODE_OUTPUT(obj,hnode,input) 
%
% See also PB_FEEDFORWARDNETWORK

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   % Random starting values
   weights_nlin    = rand(obj.layers.num_input,obj.layers.num_hidden);
   weights_lin     = rand(obj.layers.num_hidden,1); 
   obj.weights    = {weights_nlin, weights_lin};       
   obj.bias       = zeros(1,obj.layers.num_hidden);
   
   % Activation function
   switch obj.activation_function
      otherwise
         fun = @(z) tanh(z);
         obj.activation_function = 'tanh';
   end
   
   obj.compute_activation_function = fun;
   
   % Cost function
   switch obj.cost_function
      otherwise
         obj.cost_function = 'mse';
         fun = @(yhat,y) (yhat-y)^2;
   end
   
   obj.compute_cost_function = fun;
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 