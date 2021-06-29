%% Non-Linear System identification VC
%
%  J. J. Heckman (2020)

%% Cross-validation of models
%
%  Perform 8-fold cross-validation
%     - Select train / test
%     - Build models
%        - Non linear: compute volterra kernels
%           - 1st order model
%           - 2nd order model
%           - 3d order model


%% Initialize
%  Load and merge data

%  Clean
cfn         = pb_clean;
data  	= '/Users/jjheckman/Desktop/PhD/Data/Chapter 1/noise/210525/125Hz/normalised/normalised_gwn_125Hz_001.mat';
load(data);

% Globals
GV = Data.GV;
D  = Data.signal;

%% Signal processing (IMPORTANT!)
%  Preprocess data: round, normalise

dataset     = 1:GV.N_FOLD; 
max_order   = 3;
  
for iD = 1:GV.N_SIG
   for iR = 1:GV.N_REP
      
      % Read input
      x = D(iD).tukey_signal .* D(iD).repeat(iR).amp;
      y = D(iD).repeat(iR).pv.vertical(1:1000)';
      x = round(x*10)/10;     % round input signal
      
      % Store pairs
      N(iD).x(iR,:) = x;
      N(iD).y(iR,:) = y;
   end
end

%  Graph In-Out relationship
cfn = pb_newfig(cfn);
hold on;
title('Rotary Behaviour');
plot(N(1).x(1,:));
plot(N(1).y(1,:));
pb_nicegraph('def',16);
legend('x(t)','y(t)');


%% Non-linear

% Compute Non-Linear system

clear('F')
if ~exist('F','var')
   for iN = 1:GV.N_FOLD

      %  Select data
      test_idx    = iN;
      train_idx   = dataset(dataset~=test_idx);
      testset  	= N(test_idx);
      trainset 	= N(train_idx);

      %  Make lists
      x_train     = vertcat(trainset.x);
      y_train     = vertcat(trainset.y);
      x_test      = testset.x;
      y_test      = testset.y;

      %  Determine list sizes
      train_len 	= size(x_train,1);
      test_len  	= size(x_test,1);

      % train  neural networks and compute volterra series
      for iT = 1:train_len
         % Loop over each signal in trainingset

         x  = x_train(iT,:);
         y  = y_train(iT,:);

         %  Normalise manually
         x = pb_mapminmax(x,'mapx',[-360 360]);
         y = pb_mapminmax(y,'mapx',[-360 360]);

         nsamples = length(x);
         x_inputs = zeros(GV.DELAYS,nsamples-GV.DELAYS+1);
         y_target = zeros(1,nsamples-GV.DELAYS+1);

         % Create input signal and matching output
         for iDT = 1:nsamples-GV.DELAYS+1
            xin               = x(iDT:iDT+GV.DELAYS-1);
            xin               = flip(xin);
            x_inputs(:,iDT)   = xin;
            y_target(iDT)     = y(iDT+GV.DELAYS-1);
         end

         %  Make network
         net   = feedforwardnet(GV.NODES);
         net.trainParam.showWindow  = false;
         net.inputs{1}.processFcns  = {'removeconstantrows'};     % No normalization
         net.outputs{2}.processFcns = {'removeconstantrows'};

         %  Train network
         net            = train(net,x_inputs,y_target);      
         NN(iT).net     = net;

         for iO = 1:max_order
            %  Compute Volterra kernels
            clear v
            v(iT) = pb_volterra(NN(iT).net);
            v(iT).compute_volterra_kernels(iO);

            %  Store fold
            F(iN).vs(iO).volterra    = v;
            F(iN).vs(iO).net         = NN;

            % Compute mean kernels
            volt                    = vertcat(v.kernels);
            F(iN).vs(iO).mvolt      = pb_volterra(net);
            F(iN).vs(iO).mvolt.set_normalisation('none')
         end
      end

      for iO = 1:max_order
         for iH = 1:iO+1
            if iH == 2 % dimension is flipped here, so dimension idx is different.
               vh   	= cat(1,volt(:,iH).kernel);
               F(iN).vs(iO).mkernels(iH).h            = mean(vh,1);
            else
               vh   	= cat(iH,volt(:,iH).kernel);
               F(iN).vs(iO).mkernels(iH).h            = mean(vh,iH);
            end
            %  Store kernels
            F(iN).vs(iO).mvolt.kernels(iH).kernel     = F(iN).vs(iO).mkernels(iH).h;
            F(iN).vs(iO).mvolt.kernels(iH).order      = iH-1;
         end
      end

      %  Predict testset
      for iT = 1:test_len

         %  Get test data
         x  = x_test(iT,:);
         y  = y_test(iT,:);
         x = pb_mapminmax(x,'mapx',[-360 360]);          %  Normalise manually

         for iO = 1:max_order
            F(iN).vs(iO).mvolt.predict_volterra_series(x);

            yhat  = F(end).vs(iO).mvolt.model.y;
            yhat    = pb_mapminmax(yhat,'mapx',[-360 360],'direction','reverse');

            % determine delay
            [a,i] = xcorr(y,yhat);
            delay = i(a==max(a));
            t     = (1:length(yhat))+delay;

            F(iN).vs(iO).modelfit(iT).mdl = fitlm(y(t),yhat);
         end
      end
   end
   %  Finished
   pb_handel
end

cfn = pb_newfig(cfn);
hold on;
plot(F(1).vs(1).mkernels(2).h);
plot(F(1).vs(2).mkernels(2).h);
plot(F(1).vs(3).mkernels(2).h);
pb_nicegraph('def',16);
legend('1st','2nd','3rd')

%% Linear Analyses

% for iN = 1:GV.N_FOLD
%    %  Select data
%    test_idx    = iN;
%    train_idx   = dataset(dataset~=test_idx);
%    testset  	= N(test_idx);
%    trainset 	= N(train_idx);
% 
%    %  Make lists
%    x_train     = vertcat(trainset.x);
%    y_train     = vertcat(trainset.y);
%    x_test      = testset.x;
%    y_test      = testset.y;
% 
%    %  Determine list sizes
%    train_len 	= size(x_train,1);
%    test_len  	= size(x_test,1);
%    
%    %  Linear Impulse response
%    ir = pb_noise2h(x_train,y_train);
%    
%    for iT = 1:size(y_test,1)
%    
%       x        = pb_mapminmax(x,'mapx',[-360 360]);
%       
%       yhat     = pb_linearconvolution(x,ir);
%       yhat     = pb_mapminmax(yhat,'mapx',[-360 360],'direction','reverse');
%       yhat(isnan(yhat))     = 0;
% 
%       % determine delay
%       [a,i]    = xcorr(y,yhat);
%       delay    = i(a==max(a));
%       t        = (1:length(yhat));
%       F(iN).lin.modelfit(iT).mdl = fitlm(y_test(iT,:),yhat);
%    end
% end


