% Script for analyzing the data obtained on 2019-April- 17th
% Goal: troubleshooting.
% Note: this is an ugly file with lots of dead ends and dummy parameters. Fix before presenting

% Step 1: Calibrator pulse
% Step 2: Load data files and separate per speaker and per frequency band
% Step 3: Calculate scaled RMS values in dB SPL for each speaker and
% frequency band
% Plot the findings
 % first set: example of all 3 Noise Bursts in T- and F-domain (any
 % speaker), at each step of analysis
 % 2nd set: X-axis: dB attenuation; Y-axis: RMS value (dB) for
 % Sounds.recording - to check for any irregularities.
 % 3rd set: if irregularities occur: plot Time- and F-domain 
 
 %%%%%%%%%%%%%%%%%%%%%%%Let's get to work%%%%%%%%%%%%%%%%%%%
 
% Calibrator pulse
calFileName = 'JH-2019-04-17-calibrator.mat';
CAL = load(calFileName);
cal = CAL.Sounds.recorded;
Ppulse  = rms(cal);

DBref = 94 - 0.3; % dB SPL
Pref  = 10^((DBref)/20); % [Pa] -0.3 dB correction for free-field microphones

scaling  = Pref/Ppulse;
Pcal = scaling*cal;

nfftCal = 2^(nextpow2(length(cal)-1));

[Farray,Fcal]	=	genfft(Pcal,nfftCal,CAL.fsRZ6);
Fcal	=	sqrt(2)/length(cal) * Fcal;
Fcal		= 20*log10(Fcal);

%% Load files and separate as desired

	fdir = '/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/test Sndburst/JH-3630-19-04-17/trial/';
	filelist = dir(fdir); 
	dirFlags = [filelist.isdir]; 
	filelist(dirFlags) = []; % remove directories (including hidden directories)
% 	Select desired recording parameters
	atten	= 0:1:80; % dB
	spk		= 1:3;
	
 a=0; b=0; c=0; d=0; e=0; f=0; g=0; h=0; k=0;
 dump = a;
% 	for iTrial = 1
	for iTrial = 1:length(filelist)
		TRIAL = load(filelist(iTrial).name,'-mat');
		
		% Extract parameters
			% All sounds. Speaker info. Parameters info (noise type)
		noiseType			= 	TRIAL.trialsingle.stim.parameters;
		speakerPos			=	TRIAL.trialsingle.stim.X; % azimuth position
		% Data into 9 subgroups 
		switch speakerPos
			case 10
				if noiseType == 1
					a=a+1;
					sndFilt1(a,:) = TRIAL.Sounds.sndFilt1;
					sndFilt2(a,:) = TRIAL.Sounds.sndFilt2;
					soundIn(a,:)  = TRIAL.Sounds.played;
					soundRec(a,:) = TRIAL.Sounds.recording;
				elseif noiseType ==2
					b=b+1;
					sndFilt12(b,:) = TRIAL.Sounds.sndFilt1;
					sndFilt22(b,:) = TRIAL.Sounds.sndFilt2;
					soundIn2(b,:)  = TRIAL.Sounds.played;
					soundRec2(b,:) = TRIAL.Sounds.recording;
				elseif noiseType == 3
					c=c+1;
					sndFilt13(c,:) = TRIAL.Sounds.sndFilt1;
					sndFilt23(c,:) = TRIAL.Sounds.sndFilt2;
					soundIn3(c,:)  = TRIAL.Sounds.played;
					soundRec3(c,:) = TRIAL.Sounds.recording;
% 				else
% 					error('Invalid speakerPos/noiseType combination');
				end
			otherwise
% 				dump = dump+1;
% 			case -10
% 			case 10
		end
% 		clear('TRIAL'); % cleanup
	end
		soundRec = soundRec*scaling;
		soundRec2 = soundRec2*scaling;
		soundRec3 = soundRec3*scaling;
	%% Now let's plot RMS first 
	
	% Strong highpass filter
	ord = 4; % filter order
	W = 100/48848;
	[b,a] = butter (ord, W, 'high'); 
	soundDum = filter(b,a,soundRec);
% 	soundDum=soundRec;
	% Welch' method (windowing reduces noise)
	nWin = 50; % number of windows (50 windows = 0.1 s for 5s recording).
	win = length(soundDum)/nWin;
	nfft=[];
	for iTrial = 1:length(atten)
% 		[pRec(iTrial,:),freqArray] = pwelch(soundDum(iTrial,:),win,[],nfft,CAL.fsRZ6);
		[fArray,pRec(iTrial,:)] = genfft(soundDum(iTrial,:),512,CAL.fsRZ6/2);
	end
	% pRaw   = pRaw(15:end);

	SlevelF = 20*log10(rms(pRec(:,1.:end)'));
	SlevelT = 20*log10(rms(soundDum'));
% 	pRecdB = 20*log10(pRec);
figure(1);
clf
	plot(atten,SlevelT,'*'); hold on
	plot(atten,SlevelF,'r*');
	xlabel('dB attenuation','FontSize',24);
	ylabel('RMS level (dB SPL)','FontSize',24);
	title('BB noise RMS levels','FontSize',24);
	legend('T-domain RMS','F-domain RMS');
%% troubleshoot visualizations
pRecdB = 20*log10(pRec);
figure(1);
for ii = 1:81
	clf;
	xlim([-80 80]);
	semilogx(freqArray(10:end),pRecdB(ii,10:end));
	hold on
	line([250 250], ylim);
	line([750 750],ylim);
	line([2e3 2e3], ylim);
	line([6e3 6e3], ylim);
	title(atten(ii));
	text(100,20,num2str(Slevel(ii))); 
	pause;
end
	

