function obj = train_network(obj,x,y)
% TRAIN_NETWORK
%
% TRAIN_NETWORK(obj,x,y)  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   % Parse data
   if nargin < 3; error('No training data was provided...'); end
   obj = parse_data(obj,x,y);

   % Build app
   if obj.visualize_training; obj = create_app(obj); end

   trainlen = length(obj.data.train.y);
   % Train network
   for iE = 1:trainlen
      obj   = update_app_handle(obj);
      
      xinput      = obj.data.train.x(:,iE);
      output_nlin = zeros(obj.layers.num_hidden,1);
      for iH = 1:obj.layers.num_hidden
         output_nlin(iH) = compute_node_output(obj,iH,xinput);
      end
      yhat(iE) = sum(obj.weights{2} .* output_nlin);
      cost(iE) = obj.compute_cost_function(yhat(iE),obj.data.train.y(iE)); % compute mean cost for several batches?
   end

   % Test network;
   
   % IMPLEMENT THIS PART LATER! FIRST DO TRAIN + BACKPROPAGATION
   
   
   % Close app
   if obj.visualize_training; close(obj.app_handle.handle); end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 