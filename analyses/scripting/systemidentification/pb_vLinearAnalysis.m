%% Calculate Volterra kernels.
%
%  J.J. Heckman (2020)

%  This part of the code will preprocess the data from raw traces to normalised
%  data (mapminmax).

%% Initialize
%  Load and merge data

%  Clean
cfn = pb_clean('cd','/Users/jjheckman/Desktop/PhD/Data/Chapter 1/noise/200504/06hz/');

l = dir([cd filesep 'normalised' filesep '*.mat']);

% Load data
load([l(end).folder filesep l(end).name]);

% Add extra globals
Data.GV.MAX_POLES    = 4;
Data.GV.MAX_ZEROES   = Data.GV.MAX_POLES-1;
iodelay              = 0;


%% Visualize data

example_idx = randi(length(Data.signal));

t     	= 0.1:0.1:100;
sv     	= Data.signal(example_idx).norm_repeat(1).sv(1:length(t));     % input: x(t)
pv     	= Data.signal(example_idx).norm_repeat(1).pv(1:length(t));     % output: y(t)

%  Graph
cfn = pb_newfig(cfn);
title('Normalised data');
hold on;
axis square;

plot(t,sv);
plot(t,pv);

xlabel('Time (s)');
ylabel('Position ($^{\circ}$)');
ylim([-0.1 0.1]);

pb_nicegraph('def',16,'linewidth',2);
legend('sv','pv');

%% Cross validation of data

% Create IDD data
sampling_rate = 0.1;

for iD = 1:Data.GV.N_SIG
   %  Run over signals to create IDD data for cross-validation
   signal_idx  = iD;
   
   % get input/output data
   sv          = Data.signal(signal_idx).norm_repeat(1).sv(1:Data.GV.N_SAMPLES);
   pv          = Data.signal(signal_idx).norm_repeat(1).pv(1:Data.GV.N_SAMPLES);
   
   % convert to iddata object
   Data.signal(iD).idd = iddata(pv,sv,sampling_rate, ...
                                 'Tstart',            0.1, ...
                                 'ExperimentName',    ['Recording ' num2str(iD)], ...
                                 'InputUnit',         'Rotations', ...
                                 'OutputUnit',        'Rotations', ...
                                 'InputName',         'x', ...
                                 'OutputName',        'y', ...
                                 'Name',              'System Identification VC');
end

% Cross-validation
data_idx_list = 1:Data.GV.N_FOLD;
for iN = data_idx_list
   % N-fold cross validation with each iteration being a fold.
   
   % Split data
   train_idx	= data_idx_list(data_idx_list ~= iN);  % select data indices
   test_idx    = iN;
   
   ID = iddata;      % empty
   for iF = 1:Data.GV.N_FOLD-1
      % Merge training data (i.e. append idd for selected idx)
      
      signal_idx = train_idx(iF);
      
      % Select data
      if iF > 1
         ID = merge(ID,Data.signal(signal_idx).idd); 
      else
         ID = Data.signal(signal_idx).idd;
      end
   end
   
   % Write cv data
   Data.cross_validation(iN).fold               = iN;
   Data.cross_validation(iN).train_idx          = train_idx;
   Data.cross_validation(iN).test_idx           = test_idx;
   Data.cross_validation(iN).data_sets.train    = ID;
   Data.cross_validation(iN).data_sets.test     = Data.signal(test_idx).idd;
end


% Make models
for iP = 1:Data.GV.MAX_POLES
   %  Run over poles & zeroes
   
   iZ = iP-1;  % number of zeroes
   
   % create empty parameters
   model.num      = zeros(Data.GV.N_SIG, iZ+1);
   model.denom    = zeros(Data.GV.N_SIG, iP+1);
   weights        = zeros(Data.GV.N_SIG, 1);
   
   for iC = 1:length(Data.cross_validation)
      % Run over cross validation 

      % Split data
      train = Data.cross_validation(iC).data_sets.train;
      test  = Data.cross_validation(iC).data_sets.test;

      % Build model & test fit
      sys         = tfest(train,iP,iZ,iodelay);
      [~,fit,~]   = compare(test,sys);

      model.num(iC,:)   = sys.Numerator;
      model.denom(iC,:) = sys.Denominator;
      weights(iC)       = fit;
   end
   
   %  Weighted TF models
   w_num    = pb_weightedaverage(model.num,weights);
   w_denom  = pb_weightedaverage(model.denom,weights);
   
   sys.Numerator     = w_num;
   sys.Denominator   = w_denom;
   
   idd_train_all	= merge(train,test);
   [y,fit,~]      = compare(idd_train_all, sys);
   avg_fit        = mean(cell2mat(fit));
   
   % Make pole-zeroes plot
   pb_syspoleszeroes(sys);
   ax = gca; t = ax.Title.String; 
   title([t ' [' num2str(avg_fit) '\%]'])
   
   % Store data
   Data.models(iP).sys   = sys;
   Data.models(iP).pz    = [iP iZ];
   Data.models(iP).fit   = avg_fit;
end



%% Build IR (example)
%  

%     2.009
%   ---------
%   s + 2.033


%     2.221 s + 14.88
%   ---------------------
%   s^2 + 9.701 s + 14.89


%      2.183 s^2 + 11.81 s + 0.06868
%   -----------------------------------
%   s^3 + 8.134 s^2 + 11.84 s + 0.07004


%      2.186 s^3 + 15.11 s^2 + 21.58 s + 0.122
%   ----------------------------------------------
%   s^4 + 9.629 s^3 + 25.95 s^2 + 21.65 s + 0.1239

syms G s

H10     = 2.009 / (s+2.033);
H21     = (2.221 * s + 14.88) / (s^2 + 9.701 * s + 14.89);
H32     = (2.183 * s^2 + 11.81 * s + 0.06868) / (s^3 + 8.134 * s^2 + 11.84 * s + 0.07004);
H43     = (2.186 * s^3 + 15.11 * s^2 + 21.58 * s + 0.122) / (s^4 + 9.629 * s^3 + 25.95 * s^2 + 21.65 * s + 0.1239);

h10     = ilaplace(H10);
h21     = ilaplace(H21);
h32     = ilaplace(H32);
mfh10      = matlabFunction(h10);
mfh21      = matlabFunction(h21);
%mfh32     = matlabFunction(h32)
t        = 0.1:0.1:2.5;


cfn = pb_newfig(pb_cfn);
title('impulse response');
hold on;
plot(t,mfh10(t))
plot(t,mfh21(t))
pb_nicegraph;
legend('$h_{10}(\tau)$','$h_{21}(\tau)$')
xlabel('$\tau$')
ylabel('$A.U.$');














%%




return

% Model parameters

iodelay 	= 0;

% Model of your system
sys      = tfest(idd,npoles,nzeros,iodelay)
               
 Data.cross_validation(1)
