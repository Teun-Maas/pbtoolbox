classdef pb_feedforwardnetwork < matlab.mixin.Copyable
% PB_FEEDFORWARDNETWORK
% 
% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   % Properties
   properties (GetAccess = public, SetAccess = public)
      dimensions;
      layers;
      weights;
      bias;
   end
   
   properties (Access = public, Hidden = true)
      num_epochs           = 100;
      num_batches          = 1;
      batch_size           = 10;
      activation_function  = 'tanh';
      cost_function        = 'mse';
      train_test_ratio     = [0.75, 0.25];
      visualize_training   = true;
   end

   properties (Access = protected, Hidden = true)
      app_handle;
      data;
      compute_activation_function;
      compute_cost_function;
      delta;
      db;
      d;
   end

   methods (Access = public)
        
      function obj = pb_feedforwardnetwork(input,hidden,output,varargin)
         % Construct network

         % Specify dimensions of the network architecture
         if nargin < 3; output = 1; end
         if nargin < 2; hidden = [2,1]; end
         if nargin < 1; input = 2; end
         
         % Construction function
         obj = set_inputlayer_size(obj,input);
         obj = set_hiddenlayer_size(obj,hidden);
         obj = set_outputlayer_size(obj,output);
         obj = initialize_network(obj);
      end
      
      % Public methods
      obj = set_inputlayer_size(obj,num_input);
      obj = set_hiddenlayer_size(obj,num_hidden);
      obj = set_outputlayer_size(obj,output)
      obj = set_activation_function(obj); 
      obj = train_network(obj,x,y);
      output = predict(obj,x);
   end
   
   methods (Access = private)
      % Private methods
      obj = create_app(obj);
      obj = update_app_handle(obj,varargin);
      obj = parse_data(obj,x,y);
      obj = initiliaze_network(obj);
      
      output      = compute_node_output(obj,hnode,input);
      [obj,z,a]   = compute_forward(obj,x);
   end
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

