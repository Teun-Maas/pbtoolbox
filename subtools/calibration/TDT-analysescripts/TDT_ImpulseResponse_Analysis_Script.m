% Analysis of Impulse responses of spherelab
% TODO: 
% - Measure theoretical distance of initial response and first
% - Calibrate soundlevels (does this work in time-domain?)
% reflection (with ruler, verify technique)
% - Determine size and timing of initial response of 1st reflection in
% measurements. Manually or automated (peak detection algorithm?)
% Pictures: pulse provided. Typical response


% First things first: scaling factor (copye-pastable)
fdir = '/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/Click/2019-04-05';


CAL = load('JH-2019-04-05-calibrator.mat');
% CAL   = load('/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/Aco-pacific test/ACOpacific_calibration.mat');
cal   = CAL.Sounds.recorded; % [V]
% cal		= CAL.RZ6_mic(:,1);

% [B,A]	= butter(4,60/CAL.fsRZ6,'high'); % Filtering removes about 0.5% from
% overall rms. Makes sense based on 40 dB difference of LF components
% cal		= filtfilt(B,A,cal);

Ppulse  = rms(cal);
% P0 = 2e-5; % [dB] 20 uPa!
 P0 = 1;
DBref = 94 - 0.3; % dB SPL
Pref  = P0*10^((DBref)/20); % [Pa] -0.3 dB correction for free-field microphones

scaling  = Pref/Ppulse;
Pcal = scaling*cal;

nfftCal = 2^(nextpow2(length(cal)-1));

[Farray,Fcal]	=	genfft(Pcal,nfftCal,CAL.fsRZ6);
Fcal	=	sqrt(2)/length(cal) * Fcal;
Fdb		= 20*log10(Fcal/P0);

%% Get speakerdistances
spkDistance = importfile('speakerdistance.csv',2,30);
% Calculate expected delays
v=343; % [m/s]

for ii = 1:29
	x= spkDistance.distspkmic(ii); % [m]
	y = spkDistance.distspwall(ii); % [m]
	delayIR(ii) = 1e3*x/v; % [ms]
	delayReflection(ii) = 1e3*(x+2*y)/v; % [ms]
end

%% Plot example time domain
 % with inputs
fdir = '/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/Click/2019-04-05/';
fnameBase = 'JH-2019-04-05-click-Spk';
fExt	= '.mat';

% test: load 1 file
iSp = 6;
filename = [fdir fnameBase num2str(iSp) fExt];
load(filename);

% construct time Array
tArray = 1e3*(1:length(Sounds.recorded))/fs; % [ms]
tWin = (tArray > 100 & tArray < 120); % window of interest for peak detection


% remove all peaks less than 'x'% of max value
% highest = max(peaks);
% xFactor = .1;
% dum = peaks > xFactor*highest;
% peaks = peaks(dum);
% locs = locs(dum);

% some plotting parameters
xText = 'Time (ms)';
yText = 'Response';
xlimits = [90 110];
ylimits = [-2 2];
txtBase0 = 'Pulse start: ';
txtBase1 = 'recorded delay IR: ';
txtBase2 = 'recorded delay 1st reflection: ';
txtBase3 = 'theoretical delay IR: ';
txtBase4 = 'theoretical delay 1st reflection: ';
xstartTxt = 90;
prec = 2; % decimals - rounding precision
hFig = figure(1);
for iSp = 1:29
	filename = [fdir fnameBase num2str(iSp) fExt];
	load(filename);
	
	% peak detection
	rec = Sounds.recorded;
	[peaks,locs] = findpeaks(rec(tWin),tArray(tWin),'MinPeakProminence',0.4,'MinPeakHeight',1e-3);
	[peakPulse,locPulse] = findpeaks(Sounds.out(tWin),tArray(tWin),'MinPeakProminence',15,'MinPeakHeight',1e-3);
	subplot(3,1,1);
	plot(tArray,Sounds.in);
	xlim(xlimits);
	xlabel(xText);
	ylabel(yText);
	title('Input: 1 ms pulse');
	subplot(3,1,2);
	hold on
	plot(tArray,Sounds.out);
	plot(locPulse(1),peakPulse(1),'o');
	xlim(xlimits);
	title('Signal sent to speaker');
	xlabel(xText);
	ylabel(yText);
	text(xstartTxt,8,[txtBase0 num2str(round(locPulse(1),1)) ' ms'],'FontSize', 20);
	hold off
	subplot(3,1,3);
	plot(tArray,rec);
	hold on;
	plot(locs,peaks,'o');
	title('Recorded response');
	xlabel(xText);
	ylabel(yText);
	xlim(xlimits);
	ylim(ylimits);
	text(xstartTxt,1,   [txtBase1 num2str(round(locs(1)-locPulse(1),prec)) ' ms'],'FontSize', 20);
	text(xstartTxt,0.5, [txtBase2 num2str(round(locs(2)-locPulse(1),prec)) ' ms'],'FontSize',20);
	text(xstartTxt,-0.5,[txtBase3 num2str(round(delayIR(iSp),prec)) ' ms'],'FontSize', 20);
	text(xstartTxt,-1,  [txtBase4 num2str(round(delayReflection(iSp),prec)) ' ms'],'FontSize',20);
	hold off

	fancify(hFig)
	hTxt = suptitle(['Impulse Response of speaker #' num2str(iSp)]);
	hTxt.FontSize = 36;

	pause
end
