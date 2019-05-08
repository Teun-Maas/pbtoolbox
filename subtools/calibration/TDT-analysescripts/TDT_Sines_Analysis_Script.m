% This script:
% Analyses the recording of various Sines generated by the speakers connected to RZ6 system of
% the patient lab
% This script:
% -loads each recording
% - groups them by speaker and attenuation level
% - calculates the fft's (using genfft helper function)
% - visualizes Gain the F-domain (using suptitle and fancify helper functions) and finally
% - save the resulting figure as a .png in the designated directory.
% Written by: JB van der Heijdt

clearvars;

% Different measurement dates (check that all fit!)
% 2019-03-21: complete measurement, without extra amplifiers [obsolete]
% 2019-04-25: complete measurement, with extra amplifiers [current]
% NOTE: for this script, check the dates for the Master file, fdir and the
% calibrator file

% Load master file & get important parameters

	fnameM = 'JH-2019-04-25-master.mat';
	Master = load(fnameM);
	% fBase = ... etc.
	fBase = Master.fBase;
	 
 % Prepare directory list
	fdir = '/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/sineTests/2019-04-25';
	filelist = dir(fdir); 
	dirFlags = [filelist.isdir]; 
	filelist(dirFlags) = []; % remove directories (including hidden directories)
% 	Select desired recording parameters
% 	spNo = 1; % speaker number
	atten = 0:10:80; % dB

% Calibration

% CAL = load('sineTestsJH-2019-03-12-calibrator.mat');
CAL = load('JH-2019-04-25-calibrator.mat');
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

% Alternative: % [Fdb,a] = getpower(Pcal,fs,'display',true,'nfft',nfftCal);

%% Data Extraction, FFT calculation, Visualization
% For each speaker and each attenuation level (29x9=261) graphs
% all frequencies at that level (7 subplots) in a 2x4 figure.

% Set subplot parameters 
	xLabName = 'Frequency (kHz)';
	yLabName = 'Magnitude (dB SPL)';
	titleExt	 = ' dB atten';
	xlimits = [.1 1.9e4]; % [Hz]
	GooderXTickLabel = [1 10 20];
	xVals = [1000 10000 20000];
% Set figure-specific parameters (name, supertitle)


% Run the figure: Calculate FFT and plot 
	load(filelist(1).name);
	Sines = nan(7,length(Sounds(1).recorded)); % pre-allocate
	nfft = 2^nextpow2(length(Sines(1,:)));

% for spNo = 1:29
for spNo = 1
	hFig = figure(1);
	%	Position parameters for suptitle (down below)
	azPos = num2str(round(Master.speakers(spNo,4))); 
	elPos = num2str(round(Master.speakers(spNo,5)));
	supTName = ['Frequency responses of speaker (' azPos ',' elPos ')'];
	figName = ['Sine-responses-Speaker-' num2str(spNo) '.png']; % For saving figure;
 	for iFig = 1:length(atten)	

		str = ['Atten' num2str(atten(iFig)) 'dB-Spk' num2str(spNo) '.mat']; % experimental file string
		for ii = 1:length(filelist)
			clear('Sounds'); % precaution
			% Select correct file
			dumExp = any(regexp(filelist(ii).name,str));
				if dumExp
					load(filelist(ii).name);
					% Save recordings
					disp(filelist(ii).name);
					Sines = nan(7,length(Sounds(1).recorded)); % pre-allocate
					for iSine = 1:length(fBase)				
						Sines(iSine,:)		 = Sounds(iSine).recorded;
					end
					% calibrate the values
					Sines = Sines*scaling;
				end
		end
		% Calculate FFTs,plot each sine and get relevant peaks
			hAx(iFig) = subplot(2,5,iFig);
			hold on
		for iSine = 1:length(fBase)
% 			[fArray,fPower] = genfft(Sines(iSine,:),nfft,fs);
% 			fPower = sqrt(2)/length(Sines(iSine,:)) * fPower; % Correction (Parseval theorem)
			nWin = 150; % number of windows (150 windows = 0.1 s for 15s recording).
			win = length(Sines(iSine,:))/nWin;
			[fPower,fArray] =  pwelch(Sines(iSine,:)',win,[],[],fs);
		
			fDB= 20*log10(fPower/P0); % dB conversion
			
			% Plot
			semilogx(fArray,fDB,'LineWidth',2);
			axis square
			grid on
			
			% Get peaks within narrow frequency range
			% - Getting max(fDB) without indexing is inaccurate for higher
			% attenuation due to low-frequency components.
% 			[mn,idx] = min(abs(fArray-fBase(iSine)));
% 			[mn,idHarm] = min(abs(fArray-2*fBase(iSine)));
% 			peaks(iFig,iSine) = fDB(idx);
% 			peaksHarm(iFig,iSine) = fDB(idHarm);
		end

		% Add clarifying labels to subplots
		xlabel(xLabName,'FontSize',24);
		ylabel(yLabName,'FontSize',24);
		title([num2str(atten(iFig)) titleExt],'FontSize',24);
		% Add some decent limits
		xlim(xlimits);
		xticks(xVals);
		xticklabels(GooderXTickLabel);
		hAx(iFig).FontSize=24;
		hold off
	end
	% Final subplot: Peaks
% 	hAx(10) = subplot(2,5,10);
% 	plot(atten,peaks,'.','MarkerSize',20); 
% 	hold on; 
% 	plot(atten,peaks);
% 	xlabel('Attenuation (dB)');
% 	ylabel('Output level (dB SPL)');
% 	title('Magnitude of peak per attenuation level');

	
% Last touches (text)
	hT = suptitle(supTName);
	hT.FontSize = 36; % Isn't caught by fancify, cannot be entered as argument
% 	fancify(hFig);
 
% Maximize figure (optimizes use of labels)
	set(hFig, 'Position', get(0, 'Screensize'));
% Add legend (must be after fancify)
leglabel = {'250 Hz', '500 Hz' '1000 Hz' '2000  Hz' '4000 Hz' '8000 Hz' '16000 Hz' };
	legend(leglabel);
% Now fix the Xlabels (has to be final step)
	% Sets Xlabels so that Marc can interpret them
	% - must be last step because of resizing limitations
% 	for iAx = 1:length(hAx)-1
% 		set(hAx(iAx),'XTickLabel',GooderXTickLabel);
% 	end
 % Save the figure
%  	saveas(hFig, figName);
% 	pause(); % inspect before going to next figure
end
% 	
	
	% %% OLD: dummy data for visualization.
% % Move below & comment out
% 	fBase = [250 500 1e3 2e3 4e3 8e3 16e3]';
% 	fs = 48000;
% 	t = 1/fs:1/fs:5;
% 	Sines = 6*sin(2*pi*fBase*t);
% 	Sines = Sines + 0.5*rand(size(Sines)); % some jitter
% % minimal preprocessing
% 
% % - detrend
% % Sines = Sines - mean(Sines,2); % Take mean per row (i.e. trial)
% 
% % HP filter @ 20 Hz
% 	ord = 4; % filter order
% 	fcut= 20; % [Hz]
% 	wn = fcut/fs;
% 	[b,a]	= butter(ord,wn,'high');
% 
% 	filter(b,a,Sines);
% 
% 

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


%% PLOT: Waveforms (1 speaker)


load('/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/sineTests/2019-03-21/JH-2019-03-21-Atten0dB-Spk1.mat');

fBase = [250 500 1e3 2e3 4e3 8e3 16e3]; % [Hz]
Tend = 12;
tArray = 1/fs:1/fs:Tend;
frag = (1:500) + 45e3;
hFig = figure(1);
clf
for iFig = 1:7
	ax = subplot(2,4,iFig)
	plot(tArray(1:length(frag)),Sounds(iFig,:).recorded(frag));
	xlabel('Time (s)','FontSize',24);
	ylabel('Amplitude (V)','FontSize',24);
	title([num2str(fBase(iFig)) ' Hz'],'FontSize',24);
	ax.FontSize = 24;
	xlim([0 0.01]);
end
hTxt = suptitle('Waveform responses of frontal speaker (fragment)');
hTxt.FontSize=36;
fancify(hFig);

 
% Maximize figure (optimizes visibility of labels)
	set(hFig, 'Position', get(0, 'Screensize'));
	% Save output
%  	saveas(hFig, 'speaker1-sine-waveforms.png');
%% PLOT: Subplots by attenuation; X-axis: Frequency; Y-axis max output of ground and first harmonic; Each line represents a speaker
% Set subplot parameters 
	xLabName = 'Base frequency (Hz)';
	yLabName = 'Magnitude (dB SPL)';
	titleExt	 = ' dB atten';
	supTName = 'Output levels at base frequency and first harmonic';
	ylimits = [-40 80];
% 	figName = ['Sine-responses-Speaker-' num2str(spNo) '.png']; % For saving figure;
% Run the figure: Calculate FFT and plot 
	load(filelist(1).name);
	Sines = nan(7,length(Sounds(1).recorded)); % pre-allocate
	nfft = 2^nextpow2(length(Sines(1,:)));
	fAxis = categorical(fBase); % convert for nicer figure
	
% str = ['Atten' num2str(atten(iPlot)) 'dB-Spk' num2str(spNo) '.mat'];


fileBase = '/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/sineTests/2019-03-21/JH-2019-03-21-Atten';
hFig = figure(1);
clf
  for iFig = 1:length(atten)	
% for iFig = 4

			for iSp = 1:29
				fileName = [fileBase num2str(atten(iFig)) 'dB-Spk' num2str(iSp) '.mat'];
% 				str = ['Atten' num2str(atten(iFig)) 'dB-Spk' num2str(iSp) '.mat']; % experimental file string
				load(fileName);
					for iSine = 1:length(fBase)				
						Sines		 = Sounds(iSine).recorded;
						Sines = Sines*scaling;
						[fArray,fPower] = genfft(Sines,nfft,fs);
						fPower = sqrt(2)/length(Sines) * fPower; % Correction (Parseval theorem)
						fDB = 20*log10(fPower/P0); % dB conversion
						
						[~,idx] = min(abs(fArray-fBase(iSine)));
						[mn,idHarm] = min(abs(fArray-2*fBase(iSine)));
						peaks(iSine,iSp) = fDB(idx);			
						peaksHarm(iSine,iSp) = fDB(idHarm);
					end
			end
		hAx = subplot(2,5,iFig)

		hold on;
		plot(fAxis,peaks,'.','MarkerSize',20,'color',[.7 .7 .7]);
		plot(fAxis,peaks,'LineWidth',1.5,'color',[.7 .7 .7]);
		plot(fAxis,mean(peaks,2),'r','LineWidth',2);
		
		plot(fAxis,peaksHarm,'.','MarkerSize',20,'color',[.7 .7 .7]);
		plot(fAxis,peaksHarm,'LineWidth',1.5,'color',[.7 .7 .7]);
		plot(fAxis,mean(peaksHarm,2),'b','LineWidth',2);
		% 		 plot(fBase,peaksHarm);
		% Add clarifying labels to subplots
		xlabel(xLabName,'FontSize',24);
		ylabel(yLabName,'FontSize',24);
		title([num2str(atten(iFig)) titleExt],'FontSize',24);
		hAx.FontSize = 24;
		ylim(ylimits);

		% Add some decent limits
	
 end
 
 hTxt = suptitle(supTName);
 hTxt.FontSize = 36;
 hold off

% 	plot(atten,peaks,'.','MarkerSize',20); 
% 	hold on; 
% 	plot(atten,peaks);
% 	xlabel('Attenuation (dB)');
% 	ylabel('Output level (dB SPL)');
% 	title('Magnitude of peak per attenuation level');

%% Subplots: per frequency level; X-axis: attenuation; Y-axis: Output; lines: speaker

% Set subplot parameters 
	xLabName = 'dB attenuation';
	yLabName = 'Magnitude (dB SPL)';
	titleExt	 = 'Hz';
	supTName = 'Output levels at base frequency and first harmonic';
	ylimits = [-40 80];
% 	figName = ['Sine-responses-Speaker-' num2str(spNo) '.png']; % For saving figure;
% Run the figure: Calculate FFT and plot 
	load(filelist(1).name);
	Sines = nan(7,length(Sounds(1).recorded)); % pre-allocate
	nfft = 2^nextpow2(length(Sines(1,:)));
	xAtten = categorical(atten);% convert for nicer figure


fileBase = '/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/sineTests/2019-03-21/JH-2019-03-21-Atten';

%   for iFig = 1:length(fBase)	

for iAt = 1:length(atten)

		for iSp=1:29
			fileName = [fileBase num2str(atten(iAt)) 'dB-Spk' num2str(iSp) '.mat'];
% 			str = ['Atten' num2str(atten(iFig)) 'dB-Spk' num2str(iSp) '.mat']; % experimental file string
			load(fileName);
			for iSine = 1:length(fBase)
				Sines	 = Sounds(iSine).recorded;
				Sines = Sines*scaling;
				[fArray,fPower] = genfft(Sines,nfft,fs);
				fPower = sqrt(2)/length(Sines) * fPower; % Correction (Parseval theorem)
				fDB = 20*log10(fPower/P0); % dB conversion

				[~,idx] = min(abs(fArray-fBase(iSine)));
				[mn,idHarm] = min(abs(fArray-2*fBase(iSine)));
				peaks(iSine,iAt,iSp) = fDB(idx);			
				peaksHarm(iSine,iAt,iSp) = fDB(idHarm);
			end

				
		end
end
	%
	hFig = figure(1);
	clf
	for iSine = 1:length(fBase)
		peaksDum = squeeze(peaks(iSine,:,:));
		peaksHarmDum = squeeze(peaksHarm(iSine,:,:));
		hAx = subplot(2,4,iSine);
		
		hold on;
		
		plot(xAtten,peaksDum,'.','MarkerSize',20,'color',[.7 .7 .7]);
		plot(xAtten,peaksDum,'LineWidth',1.5,'color',[.7 .7 .7]);
		plot(xAtten,mean(peaksDum,2),'r','LineWidth',2);
		
		plot(xAtten,peaksHarmDum,'.','MarkerSize',20,'color',[.7 .7 .7]);
		plot(xAtten,peaksHarmDum,'LineWidth',1.5,'color',[.7 .7 .7]);
		plot(xAtten,mean(peaksHarmDum,2),'b','LineWidth',2);

		% Add clarifying labels to subplots
		xlabel(xLabName,'FontSize',24);
		ylabel(yLabName,'FontSize',24);
		title([num2str(fBase(iSine)) titleExt],'FontSize',24);
		hAx.FontSize = 24;
		ylim(ylimits); 		% Add some decent limits


	end
	

 
 hTxt = suptitle(supTName);
 hTxt.FontSize = 36;
 hold off
 
 %% tmp: troubleshoot broken (?) speaker @ 1 kHz
 hFig = figure(2);
 clf
 	plot(xAtten,mean(peaksDum,2),'r','LineWidth',2); % comparison
	xlabel('Attenuation (dB)');
	ylabel('Output (dB SPL)');
	title(['Response @ 1000 Hz']);
	hold on
 for iSp = 26
	 hLine = plot(xAtten,squeeze(peaks(3,:,iSp)),'color',[.7 .7 .7]);


 end
 
fancify(hFig)
 legend('mean of all speakers', ' speaker at location (0,-10)');
%% PlOT. Subplots: base frequency; X-axis: FFT; Y-axis: Output

% Set subplot parameters 
	xLabName = 'Frequency (kHz)';
	yLabName = 'Magnitude (dB SPL)';
	titleExt	 = ' Hz';
	xlimits = [10 1.9e4]; % [Hz]
	xVals = [100 1000 10000];
	GooderXTickLabel = [100 1000 10000]/1e3; % [kHz]
	
% Run the figure: Calculate FFT and plot 
	load(filelist(1).name);
	Sines = nan(7,length(Sounds(1).recorded)); % pre-allocate
	nfft = 2^nextpow2(length(Sines(1,:)));

for spNo = 1
	hFig = figure(1);
	%	Position parameters for suptitle (down below)
	azPos = num2str(round(Master.speakers(spNo,4))); 
	elPos = num2str(round(Master.speakers(spNo,5)));
	supTName = ['Frequency responses of speaker (' azPos ',' elPos ')'];
	figName = ['Sine-responses-Speaker-' num2str(spNo) '.png']; % For saving figure;
 	
		str = ['Atten' num2str(atten(4)) 'dB-Spk' num2str(spNo) '.mat']; % experimental file string
		for ii = 1:length(filelist)
			clear('Sounds'); % precaution
			% Select correct file
			dumExp = any(regexp(filelist(ii).name,str));
				if dumExp
					load(filelist(ii).name);
					% Save recordings
					disp(filelist(ii).name);
					for iSine = 1:length(fBase)
						hAx(iSine)	= subplot(2,4,iSine);
						Sines		= Sounds(iSine).recorded;
						Sines		= Sines*scaling;
% 						[fArray,fPower] = genfft(Sines,nfft,fs);
						nWin = 150;
						win  = length(Sines)/nWin;
						[fPower,fArray] = pwelch(Sines,win,[],[],fs);
% 						fPower = sqrt(2)/length(Sines) * fPower; % Correction (Parseval theorem)
						fDB= 20*log10(fPower/P0); % dB conversion
						% Plot
						semilogx(fArray,fDB);
						title([num2str(fBase(iSine)) titleExt]);
						hold on
						% Add clarifying labels to subplots
						xlabel(xLabName,'FontSize',24);
						ylabel(yLabName,'FontSize',24);

						% Add some decent limits
						xlim(xlimits);
						xticks(xVals);
						xticklabels(GooderXTickLabel);
						hAx(iSine).FontSize = 24;
						hold off
					end
				end
				
		end
		% Calculate FFTs,plot each sine and get relevant peaks


	end
	% Final subplot: Peaks
% 	hAx(8) = subplot(2,5,10);
% 	plot(atten,peaks,'.','MarkerSize',20); 
% 	hold on; 
% 	plot(atten,peaks);
% 	xlabel('Attenuation (dB)');
% 	ylabel('Output level (dB SPL)');
% 	title('Magnitude of peak per attenuation level');

	
% Last touches (text)
	hT = suptitle(supTName);
	hT.FontSize = 36; % Isn't caught by fancify, cannot be entered as argument
 	fancify(hFig);
 
% Maximize figure (optimizes use of labels)
	set(hFig, 'Position', get(0, 'Screensize'));


 % Save the figure
%  	saveas(hFig, figName);
% 	pause(); % inspect before going to next figure


