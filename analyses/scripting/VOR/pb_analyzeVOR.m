%% Initialize
%  Empty, Clear, Clean, Set globals.

pb_clean;

cfn         = 0;
% [fn,path]   = pb_getfile('dir',pb_datapath);
% fullname    = [path fn];
blocknumber = 9;
fullname = '/Users/jjheckman/Documents/Data/PhD/Experiment/e1_vor/JJH-0007-20-02-25/converted_data_JJH-0007-20-02-25.mat';
load(fullname);

datl        = length(D);

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
   if isfield(D(iD).Pup.Data,'gaze_normal_3d')
      gaze_normalsrot = D(iD).Pup.Data.gaze_normal_3d*Rot;
   else
     	gaze_normalsrot = D(iD).Pup.Data.base_data.base_data.circle_3d.normal * Rot; % in case 2D gaze
   end
   
   % Convert to angles
   D(iD).AzEl.Eye = - pb_xyz2azel(gaze_normalsrot(:,1),gaze_normalsrot(:,2),gaze_normalsrot(:,3));
end

%% Interpolate VC data (find lsl_ts for tsVC(1) = 0! )
%  Read in Data, synchronize VC/SH, define tsVC(1) as 0 for all LSL streams

FsVC = 9.98;

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

amplitude  = D(1).Block_Info.signal.ver.amplitude;
pb_hline([amplitude -amplitude]);

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
Pup               = D(blocknumber).AzEl.Eye(:,1);

% Remove Outliers (Hampel filter)
k              = 3;
nsigma         = 3;
[hPup, out]   	= hampel(Pup,k,nsigma);

cfn = pb_newfig(cfn);
hold on;

plot(tscPup,Pup,'.');
plot(tscPup,hPup);

title(['Remove outliers using Hampel filtering (k = ' num2str(k) ', \sigma = ' num2str(nsigma) ')']);
legend('Sampled Data','Hampel Filtered');
xlabel('Time (s)');
ylabel('Position ({\circ})');
ylim([-40 40]);

text(10, -30,['Outliers filter: ' num2str(sum(out)) ' samples (' num2str(100*(sum(out)/length(out)),'%.1f') '%)'],'Fontsize',15)
pb_nicegraph;
xlim([0 30])

Pup = hPup;     % Use hampel filtered signal for further filtering

%% Compare smoothing filters (Butterworth LPF vs Savitzky-Golay) 
%  Savitzky-Golay seems slightly better!

%  Original Data
cfn = pb_newfig(cfn);
subplot(3,1,1);
hold on;

plot(tscPup, Pup,'.')
plot(tscPup, Pup)

title('Original Raw Eye Data');
legend('Original','Overfit');
xlabel('Time (s)');
ylabel('Position ({\circ})');

% Smooth (Butterworth LPF)
subplot(3,1,2);
hold on;

fsPup       = 120;
Fc       = 40;
Wn       = Fc/((fsPup/2)+0.01);
order   	= 9;
[b,a]    = butter(order,Wn);
fPup     = filtfilt(b,a,Pup);

plot(tscPup, Pup,'.')
plot(tscPup,fPup)

title('Filtered Data');
legend('Original','Butterworth LPF');
xlabel('Time (s)');
ylabel('Position ({\circ})');

% Smooth (Savitzky-Golay filter)
order       = 1;
framelen    = 3;
fPup      	= sgolayfilt(Pup,order,framelen);

subplot(3,1,3);
hold on;

plot(tscPup, Pup,'.')
plot(tscPup,fPup,'-')

title('Filtered Eye Data');
legend('Original','Savitzky-Golay');
xlabel('Time (s)');
ylabel('Position ({\circ})');

pb_nicegraph;
linkaxes;
xlim([45 55]);
ylim([-30 30]);

%% Powerspectra

fsPup = 120;                  % Sampling frequency                    
T     = 1/fsPup;              % Sampling period       
L     = length(tscPup);       % Length of signal

% Form a signal containing a 50 Hz sinusoid of amplitude 0.7 and a 120 Hz sinusoid of amplitude 1.
cfn = pb_newfig(cfn);
subplot(2,1,1);
hold on;

plot(tscPup,Pup,'.')
plot(tscPup,fPup,'-');
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('t (milliseconds)')
ylabel('X(t)')
legend('Sampled','Savinzky-Golay')

yVEST  = fft(Pup);
fY = fft(fPup);

% Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
P2 = abs(yVEST/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = fsPup*(0:(L/2))/L;

% Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
fP2 = abs(fY/L);
fP1 = fP2(1:L/2+1);
fP1(2:end-1) = 2*fP1(2:end-1);

%  Plot
h = subplot(2,1,2);
hold on;

plot(f,P1) 
plot(f,fP1)

title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
legend('Sampled','Savinzky-Golay')

pb_nicegraph('linewidth',1)
h.YScale = 'log';

%% Select Data
%  Select data chunk without noise

[selStart,~]   = ginput(1);
[selStop,~]    = ginput(1);

%% Preprocess K-means clustering
%  

% Variables
fsPup              	= length(tscPup)/tscPup(end); % 120;
fsSH                 = length(tscSense)/tscSense(end); % 50;
pupil_velD          	= gradient(fPup) * fsPup;
tsVC                 = tscVest;
vestibular_velDI     = gradient(vestibular_posDI) * fsSH; 

% Input data format
E        = pupil_velD;
H        = vestibular_velDI;                                            	% velocity profile of vc
HI       = interp1(tsVC,H,tscPup,'pchip');
kInput   = E .* transpose(sign(HI));
kInput2  = abs(gradient(kInput));

% Figure
cfn   = pb_newfig(cfn); 
h(1)  = subplot(3,1,1);
hold on;

plot(tscVest, vestibular_posDI);
plot(tscPup,fPup);

legend('VC','Pupil')
title('Position Profiles');

h(2)  = subplot(3,1,2);
hold on;

plot(tscVest,vestibular_velDI);
plot(tscPup,pupil_velD);

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



%% Machine learning: K-means (Unsupervised clustering)
%  Select data, do kmeans

%  Get data selection
siStart  =  find(tscPup >= selStart, 1);
siStop   =  find(tscPup >= selStop, 1);

%  Machine Learning
xVEST     	= kInput(siStart : siStop);
IDX         = kmeans(xVEST , 2 , 'distance' , 'sqEuclidean');

% 
cfn = pb_newfig(cfn);
hold on;

binsz = 5;
histogram(xVEST(IDX==1),'BinWidth',binsz);
histogram(xVEST(IDX==2),'BinWidth',binsz);

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
slowphase                     = zeros(size(fPup));
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
plot(tscPup,fPup);

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

plot(tscPup,fPup,'.');
plot(tscPup,slowphase)

xlabel('Time (s)');
ylabel('Position ({\circ})');
legend('Eye position','Slowphase')
xlim([selStart selStop])

subplot(212);
hold on;
plot(tscPup,fPup,'.');
plot(tscPup(~slowphase),fPup(~slowphase),'.');

xlabel('Time (s)');
ylabel('Position ({\circ})');
legend('Slowphase','Quickphase')

pb_nicegraph;
xlim([selStart selStop])



%% Fix border edges
%  set fPup = NaN for slowphase == 0

% Correct edges
starts   = strfind(slowphase, [0 1])+1;
stops    = strfind(slowphase, [1 0]);

if stops(1) < starts(1)
   stops    = stops(2:end);
   starts   = starts(1:length(stops));
end

l        = stops-starts+1;

for iSeg = 2:length(starts) % ignore first start
   % Correct each segment (check for over segmentation of slowphases)!
   
   chunckpos      = fPup(starts(iSeg):stops(iSeg));
   chuncksign     =  transpose(diff(chunckpos));
   signs          = sign(chuncksign);
   
   nsamples       = l(iSeg);
   if nsamples <= 50 && nsamples > 4
      ncheck      = ceil(nsamples/4);       % Edge regions
      meansign    = sign(sum(signs));
      
      % Check begin slowphase
      region = signs(1 : ncheck);
      if abs(sum(region)) < ncheck
         
         sel = region == meansign * ones(1,length(region));
         ind = strfind(sel,[0 1]);
         
         if ~isempty(ind)
            flipedge                = starts(iSeg):starts(iSeg)+ind-1;
            slowphase(flipedge)     = 0;
         end
         
      end
      
      % Check begin slowphase
      region = signs(end-ncheck+1:end);
      if abs(sum(region)) < ncheck
         
       	sel = region == meansign * ones(1,length(region));
         ind = strfind(fliplr(sel),[0 1]);
         
         if ~isempty(ind)
            flipedge                = stops(iSeg)-ind+1:stops(iSeg);
            slowphase(flipedge)     = 0;
         end

      end
   end
end

%  Data
nPup              = fPup;
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

% dVOR  = [0; diff(VOR)];
% dVest = [0 diff(vestibular_posDI)];
% 
% pdVOR    = nancumsum(dVOR,[],2);
% pdVest   = cumsum(dVest);
% 
% % nanx        = isnan(dVOR);
% % t           = 1:numel(dVOR);
% % dVOR(nanx)  = interp1(t(~nanx), dVOR(~nanx), t(nanx),'pchip');
% % dVOR        = lowpass(dVOR,'Fc',.3,'Fs',120,'order',30);
% 
% cfn = pb_newfig(cfn);
% 
% subplot(211);
% hold on
% 
% plot(tscPup,dVOR);
% plot(tsVestibularI,dVest);
% 
% subplot(212);
% hold on
% 
% plot(tscPup,pdVOR);
% plot(tsVestibularI,vestibular_posDI);
% 
% pb_nicegraph;
% maxVVC = findpeaks(abs(dVest(15 < tsVestibularI < 70)),tsVestibularI(15<tsVestibularI<70),'MinPeakProminence',1);
% maxVVC = mean(maxVVC);

%% Interpolate Timestamps Vestibular and VOR signals
%  In order to make phase shift accurate we have to have same starting
%  point for both sinewaves

tscVestI = tscPup;
vestI    = interp1(tsVestibularI,vestibular_posDI,tscPup, 'pchip');

xVOR     = (tscPup(~isnan(VOR)));
yVOR     = transpose(VOR(~isnan(VOR)));

indStart = find(tscVestI >= xVOR(1));
indStop  = find(tscVestI >= xVOR(end));
range    = indStart:indStop;
xVEST    = tscVestI(range);
yVEST    = vestI(range);

xVOR     = xVOR(2:end);
yVOR     = yVOR(2:end);
xVEST    = xVEST(2:end);
yVEST    = yVEST(2:end);

%% Fit Sines
%  Get sinefits

frVest   = 0.2; % change this based on the actual frequency

%  Get fit parameters
parVor   = sineFit(xVOR,yVOR);                         % increment the cfn
parVest  = sineFit(xVEST,yVEST);

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

relPhase = parVor(4)-parVest(4);
gain     = parVor(2)/parVest(2);

%% Remove drift VOR
%  Select peaks to control for drift

% Adjust for drift in yVOR signal
cfn = pb_newfig(cfn);
hold on;

plot(xVOR,yVOR,'.');

xlim([xVOR(1) xVOR(end)]);
pb_nicegraph('linewidth',2);
 
[xV,~]         = ginput(2);            % select 2 peaks, one at the beginning and one at the end of the signal (either 2 lower peaks, or 2 higher peaks)
[~, ind(1)]   	= min(abs(xVOR-xV(1)));
[~, ind(2)]   	= min(abs(xVOR-xV(2)));

xn          = (yVOR(ind(2)) - yVOR(ind(1))) / (xVOR(ind(2)) - xVOR(ind(1)));
drift       = yVOR(ind(1)) + xVOR * xn - xn * xVOR(ind(1));
yVORd       = yVOR - (yVOR(ind(1))+ xVOR * xn - xn * xVOR(ind(1)));
yVORdmc     = yVORd - mean(yVORd);

plot(xVOR,yVORdmc,'.');
plot(xVOR,drift,'--');

c_leg       = {'Raw VOR','corrected VOR','Drift'};

pb_hline(0);
pb_nicegraph('linewidth',2);
legend(c_leg)


%% Fit Sines
%  Fit sines to Eye and head (chair) data.

%  Get fit parameters
fits        = struct([]);
fits(1).par = sineFit(xVOR,yVORdmc);            % Vestibulo-Ocular Reflex
fits(1).x   = xVOR;

fits(2).par = sineFit(xVEST,yVEST);             % Vestibular
fits(2).x   = xVEST;

cfn = pb_newfig(cfn);
hold on

plot(xVOR,yVORdmc,'.');
plot(xVEST,yVEST,'.');

for  iFit = 1:length(fits)
   
   sineP    = fits(iFit).par;
   
   %  Parameters
   u        = sineP(1);
   A        = sineP(2);
   w        = 2*pi*sineP(3);
   P        = sineP(4);
   t        = fits(iFit).x;
   
   %  Fit
   sinefit  = A * sin(w*t + P) + u;
   fits(iFit).sineFit = sinefit;
   
   plot(fits(iFit).x,fits(iFit).sineFit);
end

ncol  = 2;
col   = pb_selectcolor(ncol,2);
col   = [col/1.5; col];

pb_nicegraph;

h = pb_fobj(gca,'Type','Line');

for iCol = 1:length(h)
   h(iCol).Color     = col(iCol,:);
   
   h(iCol).LineWidth    = 1;
   h(iCol).MarkerSize   = 1;
   
   if iCol > 2; h(iCol).LineWidth = 2; end
end

c_leg   = {'Raw Chair','Raw Eye','Vestibular Fit','VOR Fit'};
legend(c_leg);

fits(1).par(2)

%%

ft       = fittype('sin(2*pi*freq*x+shift)*yscale','coefficients',{'shift','freq','yscale'});
mdlVEST  = fit(xVEST',yVEST'-mean(yVEST),ft,'startpoint',[sineP(4),sineP(3),sineP(2)]);
fVEST2   = mdlVEST.yscale*sin(2*pi*mdlVEST.freq*xVEST+mdlVEST.shift);

ft       = fittype('sin(2*pi*freq*x+shift)*yscale','coefficients',{'shift','freq','yscale'});
mdlVOR   = fit(xVOR',yVOR'-mean(yVOR),ft,'startpoint',[parVest(4),parVest(3),parVest(2)*0.5]);
fVOR2    = mdlVOR.yscale*sin(2*pi*mdlVOR.freq*xVOR+mdlVOR.shift);


%  Plot data
cfn = pb_newfig(cfn);
subplot(211);
hold on;

h = gobjects(0);
%h(end+1) = plot(xVOR,yVOR,'.');
h(end+1) = plot(xVOR,yVORdmc,'.');
h(end+1) = plot(xVOR,fVOR2,'--');
%h(end+1) = plot(xVOR,fVOR,'--');

subplot(212);
hold on;

h(end+1) = plot(xVEST,yVEST);
h(end+1) = plot(xVEST,fVEST2,'--');
%h(end+1) = plot(xVEST,fVEST,'--');

pb_nicegraph;

for i = 1:length(h)
   h(i).LineWidth = 2;
end

linkaxes;
xlim([xVEST(1) xVEST(end)])

relPhase    = fits(1).par(4)-fits(2).par(4)
gain        = fits(1).par(2)/fits(2).par(2)

relPhase    = mdlVOR.shift-mdlVEST.shift
gain        = mdlVOR.yscale/-mdlVEST.yscale


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

