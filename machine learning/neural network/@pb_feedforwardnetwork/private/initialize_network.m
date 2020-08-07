function obj = initialize_network(obj)
% INITIALIZE_NETWORK
%
% INITIALIZE_NETWORK(obj) defines default values for your network, e.g.
% the initial weights and biases for each layer, the activation function,
% and the cost function.
%
% See also PB_FEEDFORWARDNETWORK

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   % Random starting values weights and biases
   arch_in        = [obj.dimensions.num_input, obj.dimensions.num_hidden];
   arch_out       = [obj.dimensions.num_hidden, obj.dimensions.num_output];
   num_layer      = length(arch_in);
   
   obj.weights    = cell(1,num_layer);    % Preallocate weights and biases
   obj.bias       = cell(1,num_layer);
   for iL = 1:num_layer
      % Iterate over number of layers of network
      
      % Define layers
      if iL < num_layer      
         % Hidden layers
         obj.layers{iL}.name                 = ['hidden layer ' num2str(iL)];
         obj.layers{iL}.activation           = 'non-linear';
         obj.layers{iL}.activation_function	= 'tanh';
         obj.layers{iL}.compute_activation_function	= @tanh;
      else
         % Output layer
         obj.layers{iL}.name                 = 'output layer';
         obj.layers{iL}.activation           = 'linear';
         obj.layers{iL}.activation_function	= 'purelin';
         obj.layers{iL}.compute_activation_function	= @purelin;
      end
      obj.layers{iL}.layer_index     = iL;
      obj.layers{iL}.num_of_units    = arch_out(iL);

      
      obj.weights{iL}   = randn(arch_out(iL),arch_in(iL)) * sqrt(2/arch_in(iL)); % Matrix [output x input], then normalize for number input units in layer
      obj.bias{iL}      = zeros(arch_out(iL),1); 
   end
   
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