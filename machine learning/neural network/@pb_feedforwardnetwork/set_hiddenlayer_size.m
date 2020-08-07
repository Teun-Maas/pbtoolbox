function obj = set_hiddenlayer_size(obj,num_hidden)
% SET_HIDDENLAYER_SIZE
%
% SET_HIDDENLAYER_SIZE determines the number of hidden layers  and uniots
% in each layer for your neural network architecture.
%
% See also PB_FEEDFORWARDNETWORK

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if min(size(num_hidden))>1; error('Hidden layer definition should be in the form of an array: [h1,h2,..,hn]'); end

   obj.dimensions.num_hidden = reshape(num_hidden,[1,length(num_hidden)]);
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 