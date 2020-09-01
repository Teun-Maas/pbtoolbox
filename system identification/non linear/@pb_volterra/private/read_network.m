function obj = read_network(obj)
% GETWEIGHTS()
%
% GETWEIGHTS()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   net               = obj.feedforwardnet;
   obj.weights.c     = net.LW{2,1};
   obj.weights.w     = net.IW{1,1};
   obj.weights.bias  = net.b{1,1};
   
   [hidden,input]                   = size(obj.weights.w); 
   obj.netpar.nhidden               = hidden;
   obj.netpar.ninput                = input;
   obj.netpar.activation_function   = net.layers{1}.transferFcn;
   
   obj.process.input                = net.inputs{1}.processSettings{1};
   obj.process.output               = net.outputs{2}.processSettings{1};
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

