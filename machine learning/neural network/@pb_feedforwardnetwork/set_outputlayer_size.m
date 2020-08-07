function obj = set_outputlayer_size(obj,num_output)
% SET_HIDDENLAYER_SIZE
%
% SET_HIDDENLAYER_SIZE determines the number of output units
% in the output layer of the neural network architecture.
%
% See also PB_FEEDFORWARDNETWORK

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if max(size(num_output))>1; error('Output layer definition should be a single number, reflecting the number of output units.'); end

   obj.dimensions.num_output = num_output;
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 