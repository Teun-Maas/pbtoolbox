%% Calculate Volterra kernels.
%
%  J.J. Heckman (2020)

%  This part of the code will preprocess the data from raw traces to normalised
%  data (mapminmax).

%% Initialize
%  Load and merge data

%  Clean
cfn = pb_clean('cd','/Users/jjheckman/Desktop/PhD/Data/Chapter 1/noise/200504/06hz/');

% Load data
fname = 'vc_sysident_gwn_06hz_40amp.mat';
load(fname);

% Globals
GV.N_SIG          = length(Data.signal);
GV.N_REP          = length(Data.signal(1).repeat);
GV.N_SAMPLES      = length(Data.signal(1).tukey_signal);

GV.N_FOLD         = GV.N_SIG;    %  8-fold!
GV.N_MODELS       = 4;           %  linear, 1st, 2nd, and 3d order volterra. 
GV.N_MEASURES     = 3;           %  R^2, RMSE, and MAE

GV.DELAYS         = 20;
GV.NODES          = 10;


%% Show example data
%  Show data

example_idx    = randi(8);
amplitude      = Data.signal(example_idx).repeat(1).amp;
t              =  0.1:0.1:100;

true_signal    = Data.signal(example_idx).true_signal * amplitude;
tukey_signal   = Data.signal(example_idx).tukey_signal * amplitude;
sv             = Data.signal(example_idx).repeat(1).sv.vertical(1:length(t));
pv             = Data.signal(example_idx).repeat(1).pv.vertical(1:length(t));

%  Graph
cfn = pb_newfig(cfn);
title('Raw data')
hold on;

plot(t,true_signal);
plot(t,tukey_signal);
plot(t,sv);
plot(t,pv);

xlabel('Time (s)');
ylabel('Position ($^{\circ}$)');
ylim([-40 40])

pb_nicegraph('def',16,'linewidth',2);
legend('true','tukey','sv','pv');


%% Normalise data
%  Mapminmax data r = q + 360/360 -1 with qeR (-360:360]

clear sv pv    % empty variables

map_range = [-360 360];

for iS = 1:GV.N_SIG
   for iR = 1:GV.N_REP
      
      % Read chair positions
      sv    = Data.signal(iS).repeat(iR).sv.vertical;
      pv    = Data.signal(iS).repeat(iR).pv.vertical;
      
      % Normalise data
      Data.signal(iS).norm_repeat(iR).sv = pb_mapminmax(sv,'mapx',map_range);
      Data.signal(iS).norm_repeat(iR).pv = pb_mapminmax(pv,'mapx',map_range);
   end
end

%% Show example normalised data
%  Show data

sv             = Data.signal(example_idx).norm_repeat(1).sv(1:length(t));
pv             = Data.signal(example_idx).norm_repeat(1).pv(1:length(t));

%  Graph
cfn = pb_newfig(cfn);
title('Normalised data');
hold on;

plot(t,sv);
plot(t,pv);

xlabel('Time (s)');
ylabel('Position ($^{\circ}$)');
ylim([-0.1 0.1]);

pb_nicegraph('def',16,'linewidth',2);
legend('sv','pv');


%% Store data
%  store data in new file

Data.GV  = GV;

%  read old data
fn       = 'normalised_gwn_06Hz_';
l        = dir(['normalised' filesep fn '*.mat']);

%  compute filename
idx      = length(l)+1;
sfx      = num2str(idx,'%03.f');
fn       = ['normalised' filesep fn sfx '.mat'];

save(fn,'Data');



