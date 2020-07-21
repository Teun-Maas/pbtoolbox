classdef pb_feedforwardnetwork < matlab.mixin.Copyable
% PB_FEEDFORWARDNETWORK
% 
% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   % Properties
   properties (GetAccess = public, SetAccess = private)
      layers
      weights;
      bias;
   end
   
   properties (Access = public, Hidden = true)
      visualize_training   = true;
      num_epochs           = 1000;
      activation_function  = 'tanh';
      cost_function        = 'mse';
      train_test_ratio     = [0.75, 0.25];
   end

   properties (Access = protected, Hidden = true)
      app_handle;
      data;
      compute_activation_function;
      compute_cost_function;
   end

   methods (Access = public)
        
      function obj = pb_feedforwardnetwork(layers,varargin)
         % Construct network

         if nargin == 0; layers = [1,1]; end
         
         obj = set_inputlayer_size(obj,layers(1));
         obj = set_hiddenlayer_size(obj,layers(2));
         obj = initialize_network(obj);
      end

      obj = set_inputlayer_size(obj,num_input);
      obj = set_hiddenlayer_size(obj,num_hidden);
      obj = set_activation_function(obj); 
      obj = train_network(obj,x,y);
   end
   
   methods (Access = private)
      obj = create_app(obj);
      obj = update_app_handle(obj);
      obj = parse_data(obj,x,y);
      obj = initiliaze_network(obj);
      
      output = compute_node_output(obj,hnode,input);
   end
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

