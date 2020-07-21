function output = compute_node_output(obj,hnode,input)
% COMPUTE_NODE_OUTPUT
%
% COMPUTE_NODE_OUTPUT(obj,hnode,input) 
%
% See also PB_FEEDFORWARDNETWORK

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl


   delays      = obj.layers.num_input;
   weights     = obj.weights{1};
   bias        = obj.bias;
   
   z        = sum(weights(:,hnode) .* input) + bias(hnode);
   output   = obj.compute_activation_function(z);
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 