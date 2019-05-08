% Below script was used to:
% - Analyse calibration pulses
% - Calculate background noise level
% - Generate plots that show the calibration pulse and background noise
% level

% Written by: JB van der Heijdt
% Date: April 2019

clearvars;
% Calibration
CAL = load('JH-2019-03-21-calibrator.mat');

cal   = CAL.Sounds.recorded; % [V]
% [B,A]	= butter(4,60/CAL.fsRZ6,'high'); % Filtering removes about 0.5% from
% overall rms. Makes sense based on 40 dB difference of LF components
% cal		= filtfilt(B,A,cal);

Ppulse  = rms(cal);
DBref = 94 - 0.3; % dB SPL
Pref  = 10^((DBref)/20); % [Pa] -0.3 dB correction for free-field microphones

scaling  = Pref/Ppulse;
Pcal = scaling*cal;

nfftCal = 2^(nextpow2(length(cal)-1));

[Farray,Fcal]	=	genfft(Pcal,nfftCal,CAL.fs);
Fcal			=	sqrt(2)/length(cal) * Fcal;
Fdb				=	20*log10(Fcal/P0);

%% PLOT: Calibrator pulse and scaling
fs=CAL.fs;
hFig = figure(3);
ax = subplot(1,3,1);
plot(1/fs:1/fs:12,cal);
xlabel('Time (s)','FontSize',24);
ylabel('Amplitude','FontSize',24);
title('Calibrator pulse','FontSize',24);
ax.FontSize = 24;
axis square

ax = subplot(1,3,2);
plot(1/fs:1/fs:0.012,cal(1:length(cal)/1e3));
xlabel('Time (s)','FontSize',24);
ylabel('Amplitude','FontSize',24);
title('Calibrator pulse (detail)','FontSize',24);
axis square
ax.FontSize = 24;
ax = subplot(1,3,3);
[f,a] = getpower(Pcal,fs,'display',false,'nfft',nfftCal);
semilogx(f,a,'color',[0 0 0]);
grid on
xlabel('Frequency (kHz)','FontSize',24);
ylabel('Sound level (dB SPL)','FontSize',24);
title('Power spectrum','FontSize',24);
axis square
ax.FontSize = 20;
		set(gca,'XTick',[0.05 1  5 10]*1000,...
			'XTickLabel',[0.05 1  5 10]);
w = aweight(f);
m = a+w;
		
p		= 10.^(a/20);
psum	= sqrt(sum(p.^2));
L		= 20*log10(psum);

p		= 10.^(m/20);
psum	= sqrt(sum(p.^2));
La		= 20*log10(psum);

levels = [20*log10(rms(Pcal)) L La]

str = ['L_{rms} = ' num2str((levels(1)))];
text(1000+100,94-3,str,'FontSize',20);

% nicegraph(gcf)

%% Analysis: quiet (has different scaling value, too)
CAL = load('JH-linsweep-2019-03-28-calibrator.mat');
cal   = CAL.Sounds.recorded; % [V]

Ppulse  = rms(cal);
P0 = 1;
DBref = 94 - 0.3; % dB SPL
Pref  = P0*10^((DBref)/20); % [Pa] -0.3 dB correction for free-field microphones

scaling  = Pref/Ppulse;
Pcal = scaling*cal;

% nfftCal = 2^(nextpow2(length(cal)-1));
%  for ii = 1:19
% 	[Farray,Fcal]	=	genfft(Pcal(floor((ii:ii+1)*length(Pcal)/20)),nfftCal,CAL.fsRZ6);
% 	Fcal	=	sqrt(2)/length(cal) * Fcal;
% 	Fdb(ii,:)			= 20*log10(Fcal/P0);
%  end
%
 % Load background noise recording
load('/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/Sweeps/JH-9998-2019-03-27/JH-linsweep-8888-2019-03-27-0001-quiet.mat')

recordQuiet = scaling*Sounds.recorded;
recordQuietA = filterA(recordQuiet,fsRZ6);
% [b,a]=butter(4,100/fsRZ6,'high');
% recordQuietFilt=filter(b,a,recordQuiet);
overallNoise = 20*log10(rms(recordQuietA))
%
nfft = 2^(nextpow2(length(recordQuiet))-1);

[fArray,fQuiet] = genfft(recordQuiet,nfft,fsRZ6);
Nlength = length(fArray)/2 + 1; % remove mirrored FFT
fArray = fArray(1:Nlength);
fQuiet = fQuiet(1:Nlength);
fQuiet = sqrt(2)/length(recordQuiet) * fQuiet; % Correction (Parseval theorem)
fQuiet= 20*log10(fQuiet/P0); % dB conversion
tArray = (1:length(recordQuiet))/fsRZ6;

% Now use Welch' method (windowing reduces noise)
nWin = 300; % number of windows (300 windows = 0.1 s for 30s recording).
win = length(recordQuiet)/nWin;
nfft=[];
[pRaw,freqArray] = pwelch(recordQuiet,win,[],nfft,fsRZ6);
pQuiet = 20*log10(pRaw);
% [pFilt,~] = pwelch(recordQuietFilt,win,[],nfft,fsRZ6);
% pFilt = 20*log10(pFilt);


% Add a-weighting filter
[W,A]=aweight(freqArray); % A-weighted dB value (additive)
pQuietA = W'+pQuiet;

% preset labels etc.
xVal = [1e2 5e2 1e3 5e3 1e4];
xName = [0.1 0.5 1 5 10]; % kHz
xLabName = 'Frequency (kHz)';

% Plotting
hFig2 = figure(2);
clf;
hAx(1) = subplot(1,3,1); % Time domain unscaled
plot(tArray,recordQuiet/scaling);
xlabel('Time (s)','FontSize',24);
ylabel('Unscaled mplitude (V)','FontSize',24);
title('Time domain','FontSize',24);

hAx(2) = subplot(1,3,2); % dB SPL
semilogx(freqArray,pQuiet); 
% semilogx(fArray,fQuiet);
xlim([10 fsRZ6/2]);
xlabel(xLabName,'FontSize',24);
ylabel('Sound level (dB SPL)','FontSize',24);
title('Frequency Domain','FontSize',24);
xticks(xVal);
xticklabels(xName);

hAx(3) = subplot(1,3,3); % A-weighted
semilogx(freqArray,pQuietA); 
% semilogx(freqArray,pFilt);
hold on
% semilogx(fArray,fQuiet+W);

xlim([10 fsRZ6/2]);
xlabel(xLabName,'FontSize',24);
ylabel('Sound level (dB A)','FontSize',24);
title('A-weighted frequency domain','FontSize',24);
xticks(xVal);
xticklabels(xName);

% Xticks fontsize
for iAx = 1:length(hAx)
	hAx(iAx).FontSize = 24;
end
hTxt = suptitle('Recording of background noise');
hTxt.FontSize = 36;
str = ['L_{rms} = ' num2str(round(overallNoise,1)) ' dB A'];
text(15,0,str,'FontSize',24);
fancify(hFig2)

