function [obj,z,a]   = compute_forward(obj,x)
% COMPUTE_FORWARD
%
% COMPUTE_NODE_OUTPUT(obj,hnode,input) 
%
% See also PB_FEEDFORWARDNETWORK

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   % Define default & preallocate
   nlayers  = length(obj.weights);
   z        = cell(nlayers,1);
   a        = cell(nlayers,1);
   xT       = x;
   
   % Compute output (or  a(:,2))
   for iL = 1:nlayers
      z{iL}  = obj.weights{iL} * xT + obj.bias{iL};
      a{iL}  = obj.layers{iL}.compute_activation_function(z{iL});
      xT     = a{iL};
   end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 