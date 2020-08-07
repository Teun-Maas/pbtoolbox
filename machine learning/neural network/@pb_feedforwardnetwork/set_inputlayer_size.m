function obj = set_inputlayer_size(obj,num_input)
% SET_INPUTLAYER_SIZE
%
% SET_INPUTLAYER_SIZE determines the number of input units
% in the input layer of the neural network architecture.
%
% See also PB_FEEDFORWARDNETWORK

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
  if max(size(num_input))>1; error('Input layer definition should be a single number, reflecting the number of input units.'); end

   obj.dimensions.num_input = num_input;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 