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

   %% Backprop
   % Number of runs over data / epochs
   
   for iE = 1:obj.num_epochs
      
      % Determine batch size
      trainlen       = length(obj.data.train.y);
      N              = obj.batch_size;
      N              = 1;
      num_of_batches = floor(trainlen/N);       % Note that there may be some excess samples not included dude the rounding down 

      for iB = 0:num_of_batches-1
         % Iterate over number of batches
         
         % Gradient descent
         num_layer   = length(obj.dimensions.num_hidden)+1;
         obj.delta   = cell(1,num_layer);  % Create an empty delta cell for every layer
         obj.db      = cell(1,num_layer);
         obj.d       = cell(1,num_layer);
         for iD = 1:num_layer
            obj.delta{iD}  = zeros(size(obj.weights{iD}));  	% Fill zeros
            obj.db{iD}     = zeros(length(obj.weights{iD}));
         end
      	
         % Shuffle training data
         r_perm = randperm(length(obj.data.train.x));    % Compensate random sampling of the rounding down of your training data
         obj.data.train.x(:,r_perm);
         obj.data.train.y(:,r_perm);
         
         for iT = iB*N+1:(iB+1)*N
            % Iterate over the range of your mini batch

            % Select data
            X           = obj.data.train.x(:,iT);
            Y           = obj.data.train.y(:,iT);

            % Compute forward
            [obj,z,a]   = compute_forward(obj,X);
            
            % Backprop
           Li = flip(1:num_layer);
            for iL = 1:num_layer
               if iL == 1
                  obj.d{Li(iL)}     = a{Li(iL)} - Y;
               else
                  sig               = obj.layers{Li(iL)}.compute_activation_function(z{iL});
                  obj.d{Li(iL)}     = (obj.weights{Li(iL)}' * obj.d{Li(iL)+1}) * (sig .* (1-sig));
               end
               
               obj.delta{Li(iL)}    = obj.delta{Li(iL)} +  obj.d{Li(iL)} * a{Li(iL)}; %fix multiplication！
               obj.db{Li(iL)}       = obj.db{Li(iL)} + obj.d{Li(iL)};
            end
            
            %  Update weights
            lr = 0.00000001;
            for iL = 1:num_layer
               obj.weights{iL}   = obj.weights{iL} - (lr * obj.delta{iL} / N);
               obj.bias{iL}      = obj.bias{iL} - (lr * obj.bias{iL} / N);
            end         
         end       
      end
      % Count epoch
      obj 	= update_app_handle(obj,'epoch');
   end

   %% Close
   % Close app
   if obj.visualize_training; close(obj.app_handle.handle); end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 