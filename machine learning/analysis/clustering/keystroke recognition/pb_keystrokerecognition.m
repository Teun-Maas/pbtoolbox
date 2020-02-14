%% Initialize Machine Learning - Read Keyboard
%  Clean and initialize

cfn = pb_clean;

%% Load data set

load([pb_userpath 'machine learning/analysis/clustering/keystroke recognition/data/keyrecognition.mat']);

%% Create data set

%  Initalize
cfn = pb_clean;

%  Create audio recording
fs                = 44100;
recObj            = audiorecorder(fs,24,2);
recObj.StartFcn   = 'disp(''>> Recording started...'')';
recObj.StopFcn    = 'disp(''>> Recording stopped...'')';

%  Experimental parameters
trialsz     = 3000;

%  Create GUI
col         = pb_selectcolor(3,2);
[~,h]       = pb_newfig(999);
h.Color     = [1 1 1];
a           = axes('XColor',[1 1 1], ...
                     'YColor',[1 1 1], ...
                     'Color','none', ...
                     'XTick',[], ...
                     'YTick',[]);
                  
ttl         = sgtitle('Keystroke Classification (ML)','FontSize',20,'FontWeight','Bold');
txt(1)      = text(0.40,0.65,'Current Keystroke:','FontSize',13);
txt(2)      = text(0.46,0.5,'...','FontSize',50,'Color',col(1,:));

%  Run experiment
recObj.record;
keystroke   = repmat(' ',trialsz,1);
samples     = zeros(1,trialsz);
for iTrial = 1:trialsz
   %  Get keystroke
   k              = waitforbuttonpress;
   samples(iTrial)   = recObj.CurrentSample;
   value             = get(gcf,'CurrentCharacter');
   
   %  Display Keystroke
   txt(2).String = value;
   pause(1);
   txt(2).String = '.';
   for i = 1:2
      pause(0.05);
      txt(2).String = [txt(2).String '.'];
   end
   pause(0.3);
   txt(2).String = '';
   
   %  Store data
   keystroke(iTrial) = value;
end

%  Save audio
recObj.stop;

%  Display
y     = recObj.getaudiodata;
cfn   = pb_newfig(cfn);
plot(y);
pb_vline(samples);
pb_nicegraph;

%  Clear
recObj.delete;

%
samplesz = length(samples);
signals = zeros(samplesz,6615);
for iSig = 1:samplesz
   ind(1) = (samples(iSig) - 1504);
   ind(2) = (samples(iSig) + 5110);
   signals(iSig,:) = y(ind(1):ind(2),1);
   
   cfn = pb_newfig(cfn);
   plot(signals(iSig,:))
   pb_nicegraph;
end

%% Shuffle 

%  Shuffle data
seq         = randperm(samplesz);
keystroke   = keystroke(seq);
signals     = signals(seq,:);

%% Convert data fft

for iFFT = 1:samplesz
   Y     = fft(signals(iFFT,:));
   P2    = abs(Y/samplesz);
   P1    = P2(1:samplesz/2+1);
   
   
   P1(2:end-1)          = 2*P1(2:end-1);
   signalsfft(iFFT,:)   = P1;
end

%% Train & Validate

%  Make training- and testset
clc;
trainingind = 1:700;
testind     = trainingind(end)+1:samplesz;
trainset    = signalsfft(trainingind,:);
trainlbl    = keystroke(trainingind);
testset     = signalsfft(testind,:);
testlbl     = keystroke(testind);

%  Use discriminant analysis clasifier
mdl         = fitcdiscr(trainset,trainlbl,...
               'OptimizeHyperparameters','auto',...
               'HyperparameterOptimizationOptions',...
               struct('AcquisitionFunctionName','expected-improvement-plus'));

predictions	= mdl.predict(testset);

iscorrect      = predictions == testlbl; 
accuracy       = sum(iscorrect)/numel(iscorrect);

pb_newfig(999);
cm    = confusionchart(testlbl, predictions, ...
    'ColumnSummary','column-normalized', ...
    'RowSummary','row-normalized');
 
title(['Confusion Chart: (' num2str(1-accuracy,3) ' misrate)']);

%% Test (prove)

%  Experimental parameters
trialsz     = 10;

%  Create GUI
col         = pb_selectcolor(3,2);
[~,h]       = pb_newfig(999);
h.Color     = [1 1 1];
a           = axes('XColor',[1 1 1], ...
                     'YColor',[1 1 1], ...
                     'Color','none', ...
                     'XTick',[], ...
                     'YTick',[]);
                  
ttl         = sgtitle('Keystroke Classification (ML)','FontSize',20,'FontWeight','Bold');
txt(1)      = text(0.3,0.65,'Keystroke:','FontSize',13);
txt(2)      = text(0.31,0.5,'...','FontSize',50,'Color',col(1,:));

txt(3)      = text(0.6,0.65,'Predict:','FontSize',13);
txt(4)      = text(0.60,0.5,'...','FontSize',50,'Color',col(2,:));

%%  Run experiment

for iTrial = 1:trialsz
   %  Get keystroke
   
   %  Create audio recording
   fs                = 44100;
   recObj            = audiorecorder(fs,24,2);
   recObj.record;
   
   k                 = waitforbuttonpress;
   sample            = recObj.CurrentSample;
   value             = get(gcf,'CurrentCharacter');
   
   txt(2).String     = value;
   
   %  Save audio
   pause(0.15)
   recObj.stop;
   
   %  Compute fft
   y        = recObj.getaudiodata;
   ind(1)   = (sample - 1504);
   ind(2)   = (sample + 5110);
   y        = y(ind(1):ind(2),1);
   Y     	= fft(y);
   P2       = abs(Y/samplesz);
   P1       = P2(1:samplesz/2+1);
   P1(2:end-1) 	= 2*P1(2:end-1);
   
   output   = mdl.predict(P1');
   
   txt(4).String     = output;
   pause(1);
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

