%% Initialize
%  Empty, Clear, Clean, Set globals.

pb_clean;
path        = '/Users/jjheckman/Documents/Data/PhD/Experiment/vestibular_frequencies/JJH-0004-19-09-24/';
fn          = 'Converted_Data.mat';
fullname    = [path fn];
blocknumber = 4;
cfn         = 0;

load(fullname);
changefonts;      % set fonts to avenir next

%% Convert 2 AzEl
%  Take eye x, y, z traces and transform 2 azimuth and elevation

if length(D) ~= datl; D(datl) = struct([]); end

for iD = 1:datl
   % Loop over data
   q        = quaternion(D(iD).Opt.Data.qw,D(iD).Opt.Data.qx,D(iD).Opt.Data.qy,D(iD).Opt.Data.qz);
   vp       = transpose(RotateVector(q,[0 0 1]',1));
   AzEl     = -VCxyz2azel(vp(:,1),vp(:,2),vp(:,3));

   D(iD).AzEl.Head = AzEl;

   normv = D(iD).Pup.Data.gaze_normal_3d(1:10,:);
   normv = median(normv);
   
   % Estimate rotation matrix
   GG = @(A,B) [ dot(A,B) -norm(cross(A,B)) 0;
       norm(cross(A,B)) dot(A,B)  0;
       0              0           1];

   FFi = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];

   UU    = @(Fi,G) Fi * G * inv(Fi);
   b     = normv'; 
   a     = [0 0 1]';
   Rot   = UU(FFi(a,b), GG(a,b));

   % Rotate
   gaze_normalsrot = D(iD).Pup.Data.gaze_normal_3d*Rot;

   % Convert to angles
   D(iD).AzEl.Eye = -VCxyz2azel(gaze_normalsrot(:,1),gaze_normalsrot(:,2),gaze_normalsrot(:,3));
end

%% Interpolate VC data (find lsl_ts for tsVC(1) = 0! )
%  Read in Data, synchronize VC/SH, define tsVC(1) as 0 for all LSL streams

FsVC = 9.95;

%  Sensehat data
sensehat_posD     = rad2deg(cumsum(D(blocknumber).Sensehat.gyro_y - D(blocknumber).Sensehat.gyro_y(1)))/-100;
sensehat_posD     = sensehat_posD - sensehat_posD(1);                      % Force sine start at 0
% sensehat_posD     = sensehat_posD/max(abs(sensehat_posD));
lsl_tsSense       = D(blocknumber).Timestamp.Sense;
tsSense           = lsl_tsSense - lsl_tsSense(1);                          % Set ts(1) = 0

%  Vestibular data
vestibular_posD  	= pb_cleanSP(D(blocknumber).VC.pv.vertical);          	% Strip tail from VC signal
% vestibular_posD   = vestibular_posD/max(abs(vestibular_posD));
tsVestibular    	= (0:length(vestibular_posD)-1)/FsVC;                      % Create VC timestamps (0:0.1:Nx)

%  Interpolate vestibular data 
vestibular_posDI  = interp1(tsVestibular, vestibular_posD, tsSense, 'pchip');
tsVestibularI     = tsSense;

%  Clip extrapolation
inds                    = find(tsVestibularI >= max(tsVestibular));        % find index extrapolated values
vestibular_posDI(inds)  = [];
tsVestibularI(inds)     = [];

%  XCorr synchronization
fsPup      	= length(tsVestibularI)/tsVestibularI(end);
[r,lag]     = xcorr(vestibular_posDI,sensehat_posD);
[~,I]       = max(abs(r));
lagDiff     = lag(I)/fsPup;
tsSense     = tsSense+lagDiff;                                           	% Correct lagdiff in Sensets

% Flip Vestibulars
vestibular_posDI     = - vestibular_posDI;
sensehat_posD        = -sensehat_posD;

% Plot
cfn = pb_newfig(cfn);
hold on;

plot(tsSense, sensehat_posD,'.');
plot(tsVestibularI, vestibular_posDI,'.');

pb_hline([45 -45]);

title(['Cross-correlate VC and Sensehat signal (lag = ' num2str(lagDiff,'%.2f') ' s)'] );
legend('FusionPose','VC PV')
xlabel('Time (s)');
ylabel('Position ({\circ})')

pb_nicegraph;

tsMin = 0;
tsMax = round(max(tsVestibularI)/100)*100;
xlim([tsMin tsMax])

disp(['Lag difference between tsVC and tsSense: ' num2str(lagDiff,3)]);

%% Synchronize lsl data
%  Synchronize lsl data

%  Do some weird presynch to force proper pupil timestamps
lsl_tsPupRaw   = D(blocknumber).Timestamp.Pup;
lsl_tsPup      = D(blocknumber).Pup.Timestamps - D(blocknumber).Pup.Timestamps(6) + lsl_tsPupRaw(6);

%  Find lsl timeshift
ind      = find(tsSense >= 0, 1);   % find index where tsSense > 0 
lslTS    = -lsl_tsSense(ind);       % set index in original lsl_sense data as absolute lsl delay

%  Correct all streams!
tscVest        = tsVestibularI;
tscSense     	= lslTS + lsl_tsSense;
tscPup       	= lslTS + lsl_tsPup;
tscOpt       	= lslTS + D(blocknumber).Timestamp.Opt;

% Correct lsl timestamps pupil (2nd!)
tsPupRaw             = tscPup;
Pupil                = D(blocknumber).Timestamp.Pup;
tscPup               = Pupil - Pupil(6) + tsPupRaw(6);
diffs                = abs(tscPup - tsPupRaw);
tscPup(diffs>10)     = tsPupRaw(diffs>10);

%  Plot
cfn   = pb_newfig(cfn);
subs  = 3;

%  Vestibular
h(1) = subplot(subs,1,1);
hold on;

plot(tscVest, vestibular_posDI,'.');
plot(tscSense, sensehat_posD,'.');

pb_hline([45 -45]);

title('Vestibular Chair' );
legend('Vestibular','Sensehat')
xlabel('Time (s)');
ylabel('Position ({\circ})')

%  Eye
h(2) = subplot(subs,1,2);
hold on;

plot(tscPup, D(blocknumber).AzEl.Eye,'.');      % plot both Azimuth and Elevation!

title('Eye traces');
legend('Azimuth','Elevation')
xlabel('Time (s)');
ylabel('Position ({\circ})')

% Head
h(3) = subplot(subs,1,3);
hold on;

plot(tscOpt, D(blocknumber).AzEl.Head - D(blocknumber).AzEl.Head(1,:),'.'); % plot both Azimuth and Elevation!

pb_hline([45 -45]);

title('Head traces');
legend('Azimuth','Elevation')
xlabel('Time (s)');
ylabel('Position ({\circ})')

pb_nicegraph;
linkaxes(h)
zoom xon;

%% Get Data
%  Obtain data, and filter outliers using hampel filter

%  Original Data
Pup_Az         = D(blocknumber).AzEl.Eye(:,1);
Pup_El         = D(blocknumber).AzEl.Eye(:,2);

% Remove Outliers (Hampel filter)
k          	= 3;
nsigma     	= 3;
Pup_Az   	= hampel(Pup_Az,k,nsigma);
Pup_El     = hampel(Pup_El,k,nsigma);

% Smooth (Savitzky-Golay filter)
order       = 1;
framelen    = 3;
fPup_Az     = sgolayfilt(Pup_Az,order,framelen);
fPup_El     = sgolayfilt(Pup_El,order,framelen);

%  Plot Data
cfn = pb_newfig(cfn);
hold on;

plot(tscPup,fPup_El,'-')
plot(tscPup,fPup_Az,'-')

title('Filtered Eye Data');
legend('Original-El','Filter-El','Original-Az','Filter-Az');
xlabel('Time (s)');
ylabel('Position ({\circ})');

pb_nicegraph('linewidth',2);

%% Select Data
%  Select data chunk without noise

[selStart,~]   = ginput(1);
[selStop,~]    = ginput(1);

%% Preprocess K-means clustering
%  Select the clustering input data, cluster: k-means

% Variables
fsPup              	= length(tscPup)/tscPup(end); % 120;
fsSH                 = length(tscSense)/tscSense(end); % 50;
pupil_Az_velD        = gradient(fPup_Az) * fsPup;
pupil_El_velD        = gradient(fPup_El) * fsPup;

tsVC                 = tscVest;
vestibular_velDI     = gradient(vestibular_posDI) * fsSH; 

% Input data format
E_Az        = pupil_Az_velD;
E_El        = pupil_El_velD;
H           = vestibular_velDI;                                            	% velocity profile of vc
HI          = interp1(tsVC,H,tscPup,'pchip');
kInput      = E_Az .* transpose(sign(HI));
kInput2     = abs(E_El); % .* transpose(sign(HI));

% Figure
cfn   = pb_newfig(cfn); 
h(1)  = subplot(3,1,1);
hold on;

plot(tscVest, vestibular_posDI);
plot(tscPup,fPup_Az);

legend('VC','Pupil')
title('Position Profiles');

h(2)  = subplot(3,1,2);
hold on;

plot(tscVest,vestibular_velDI);
plot(tscPup,pupil_Az_velD);

legend('VC','Pupil')
title('Velocity Profiles');

h(3)  = subplot(3,1,3);
hold on;

plot(tscPup,kInput);
plot(tscPup,kInput2);

legend('kInput','kInput2')
title('Velocity Profiles');

linkaxes(h,'x')
xlim([35 45]);
pb_nicegraph;

%% 2D kInput
%  Think about second dimension for kInput. To make it better then just a
%  cutoff velocity in a histogram.

cfn = pb_newfig(cfn);
hold on;

plot(kInput,kInput2,'.')

pb_nicegraph;

%% Machine learning: K-means (Unsupervised clustering)
%  Select data, do kmeans

%  Get data selection
siStart  =  find(tscPup >= selStart, 1);
siStop   =  find(tscPup >= selStop, 1);

%  Machine Learning
xVEST          = kInput(siStart : siStop);
yVEST          = kInput2(siStart : siStop);
IDX            = kmeans([xVEST; yVEST], 3, 'distance' , 'sqEuclidean');

% 
cfn = pb_newfig(cfn);
hold on;

binsz = 5;
%histogram(xVEST(IDX==1),'BinWidth',binsz);
plot(xVEST(IDX==1),yVEST(IDX==1),'.')
plot(xVEST(IDX==2),yVEST(IDX==2),'.')
%histogram(xVEST(IDX==2),'BinWidth',binsz);

legend('Cluster 1','Cluster 2')
xlabel('Velocity')
ylabel('Frequency (#)');
pb_nicegraph;

%% Separate the data into two groups

%  Clusters
G1 = xVEST(IDX == 1, : );
G2 = xVEST(IDX == 2, : );

%  Identify slowphase & quickphase
%  Use mean velocity to identify not cluster size!
if abs(mean(G1)) < abs(mean(G2))
   slowIDX = 1; 
else
   slowIDX = 2;
end
quickIDX        = ~(slowIDX-1) + 1;

%  Slowphase boolean
slowchunck                    = zeros(size(xVEST));
slowchunck(IDX == slowIDX)    = 1;
slowphase                     = zeros(size(fPup_Az));
slowphase(siStart : siStop)   = slowchunck;
slowphase                     = transpose(slowphase);
slowphase                     = logical(slowphase);

kcluster_slow                 = kInput;
kcluster_quick                = kInput;
kcluster_slow(~slowphase)     = nan;
kcluster_quick(slowphase)     = nan;

% Cluster
cfn = pb_newfig(cfn);
hold on;

plot(slowphase)

title('Clutstered Input Data')
xlabel('Time (s)');
ylabel('Phase');
legend('Slowphase')

pb_nicegraph;

%  Plot Results
cfn = pb_newfig(cfn);
subplot(211);
hold on;

plot(tscPup,(kInput./10));
plot(tscPup,fPup_Az);

title('Input');
xlabel('Time (s)')
ylabel('[AU]');
legend('K-means Input','Eye position')
xlim([25 40])

subplot(212);
hold on;
plot(tscPup,kcluster_slow);
plot(tscPup,kcluster_quick);

title('Output');
xlabel('Time (s)')
ylabel('[AU]');
legend(['Slowphase (Cluster: ' num2str(slowIDX) ')'],['Quickphase (Cluster: ' num2str(quickIDX) ')'])

pb_nicegraph;
linkaxes(findall(gcf,'type','axes'),'x')
pb_nicegraph;
xlim([selStart selStop])


%% Zoom data

cfn = pb_newfig(cfn);
sgtitle('Segmentated VOR','Fontweight','Bold','Fontsize',15)
subplot(211);
hold on;

plot(tscPup,fPup_Az,'.');
plot(tscPup,slowphase)

xlabel('Time (s)');
ylabel('Position ({\circ})');
legend('Eye position','Slowphase')
xlim([selStart selStop])

subplot(212);
hold on;
plot(tscPup,fPup_Az,'.');
plot(tscPup(~slowphase),fPup_Az(~slowphase),'.');

xlabel('Time (s)');
ylabel('Position ({\circ})');
legend('Slowphase','Quickphase')

pb_nicegraph;
xlim([selStart selStop])

%% Fix border edges
%  set fPup = NaN for slowphase == 0

% Correct edges
starts   = strfind(slowphase, [1 0])+1;
stops    = strfind(slowphase, [0 1]);
l        = stops-starts+1;

for iSeg = 2:length(starts) % ignore first start
   % Correct each segment (check for over segmentation of slowphases)!
   
   chunck =  transpose(diff(fPup_Az(starts(iSeg):stops(iSeg))));
   sign(chunck);
end

%  Data
nPup              = fPup_Az;
nPup(~slowphase)  = NaN;

%  Clean small chuncks
minlengthquick   	= 1;
minlengthslow   	= 2;
slowphase         = transpose(isnan(nPup));

cfn = pb_newfig(cfn);
hold on;

plot(tscPup,nPup,'.');

title('Segmentated VOR');
xlabel('Time (s)');
ylabel('Position ({\circ})');
legend('Slowphase');

pb_nicegraph;


%% Display  VOR 2 VC

%  Shift Slowphases
starts   = strfind(slowphase, [1 0])+1;
stops    = strfind(slowphase, [0 1]);
l        = stops-starts+1;

nanstarts   = [];
VOR         = nPup;

for iSeg = 2:length(starts) % ignore first start
   % Correct each segment (check for accidental quickphasese)!
   
   vRange         = starts(iSeg):length(VOR);
   
   nanstart       = stops(iSeg-1)+1;
   nanstop        = starts(iSeg)-1;
   nanlen         = nanstop-nanstart;
   
   prevpos       = nanstart-nanlen-1;
   nextpos        = nanstop+1+nanlen;
   
   
   R              = nPup(stops(iSeg-1)) - nPup(starts(iSeg));              %  Correct for previous amplitude
   VORdiff     	= diff( VOR(prevpos:nextpos) );
   C              = nanmean(VORdiff) * nanlen;                             %  Correct for previous duration (Linear for now..)
   C              = 0;
   
   VOR(vRange) 	= VOR(starts(iSeg):end) + R + C; 
   nanstarts      = [nanstarts; nanstart];
end

cfn      = pb_newfig(cfn);
hold on;

plot(tsVestibularI,vestibular_posDI,'.')
plot(tscPup,VOR,'.');


title('Vestibulo-Ocular Reflix');
xlabel('Time (s)');
ylabel('Position ({\circ})');
legend('VC','VOR');

pb_vline(tscPup(nanstarts));
pb_nicegraph;

beginVOR = tscPup(starts(1)); 
endVOR   = tscPup(stops(end));
xlim([beginVOR endVOR])
%%

dVOR  = [0; diff(VOR)];
dVest = [0 diff(vestibular_posDI)];

pdVOR    = nancumsum(dVOR,[],2);
pdVest   = cumsum(dVest);

% nanx        = isnan(dVOR);
% t           = 1:numel(dVOR);
% dVOR(nanx)  = interp1(t(~nanx), dVOR(~nanx), t(nanx),'pchip');
% dVOR        = lowpass(dVOR,'Fc',.3,'Fs',120,'order',30);

cfn = pb_newfig(cfn);

subplot(211);
hold on

plot(tscPup,dVOR);
plot(tsVestibularI,dVest);

subplot(212);
hold on

plot(tscPup,pdVOR);
plot(tsVestibularI,vestibular_posDI);

pb_nicegraph;
maxVVC = findpeaks(abs(dVest(15<tsVestibularI<70)),tsVestibularI(15<tsVestibularI<70),'MinPeakProminence',1);
maxVVC = mean(maxVVC);

%% Interpolate Timestamps Vestibular and VOR signals
%  In order to make phase shift accurate we have to have same starting
%  point for both sinewaves

tscVestI = tscPup;
vestI    = interp1(tsVestibularI,vestibular_posDI,tscPup, 'pchip');

xVOR = (tscPup(~isnan(VOR)));
yVOR = transpose(VOR(~isnan(VOR)));

indStart = find(tscVestI >= xVOR(1));
indStop  = find(tscVestI >= xVOR(end));
range    = indStart:indStop;
xVEST        = tscVestI(range);
yVEST        = vestI(range);

xVOR        = xVOR(2:end);
yVOR        = yVOR(2:end);
xVEST        = xVEST(2:end);
yVEST        = yVEST(2:end);

%% Fit Sines
%  Get sinefits

frVest   = 0.2; % change this based on the actual frequency

%  Get fit parameters
parVor   = sineFit(xVOR,yVOR);
cfn      = cfn+2;                           % increment the cfn
parVest  = sineFit(xVEST,yVEST);
cfn      = cfn+2;                           % increment the cfn

parVor(4)   = parVor(4)+.3;                 % THIS SHOULD BE FIXED; SEE WEIRD ARBITRARY CONSTANT
parVest(4)	= parVest(4)-.17;

%  Make fit
fVOR     = parVor(2) * sin(2*pi*frVest * xVOR + parVor(4)) + parVor(1);
fVEST    = parVest(2) * sin(2*pi*frVest * xVEST + parVest(4)) + parVest(1);

%  Plot data
cfn = pb_newfig(cfn);
hold on;

h(1) = plot(xVOR,yVOR);
h(2) = plot(xVEST,yVEST);
h(3) = plot(xVOR,fVOR,'--');
h(4) = plot(xVEST,fVEST,'--');

pb_nicegraph;
linkaxes;

for i = 1:4
   h(i).LineWidth = 2;
end

xlim([xVEST(1) xVEST(end)])

relPhase = parVor(4)-parVest(4)
gain     = parVor(2)/parVest(2)



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

