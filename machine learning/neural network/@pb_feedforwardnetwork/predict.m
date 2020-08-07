function output  = predict(obj,x)
% COMPUTE_FORWARD
%
% COMPUTE_NODE_OUTPUT(obj,hnode,input) 
%
% See also PB_FEEDFORWARDNETWORK

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   % Check for input dimensions
   if min(size(x)) > 1 || length(x) ~= obj.dimensions.num_input
      error(['Input data did not match required dimensions (memory = ' num2str(obj.layers.num_input) ')']);
   end

   x           = flip(reshape(x,[obj.dimensions.num_input,1])); % force orientation input
   [~,~,a]     = compute_forward(obj,x);
   output      = a{end};
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 