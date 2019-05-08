% In this script:
% A method for playing scripts from an RZ6 circuit and recording the
% corresponding outputs.

% Written by: JB van der Heijdt

home;
clearvars;
close all;

% Where to save data?
%	-	naming convention: 'ExpInitials-subjID-Year-Mo-Dy-blockNo
fdir           =	['C:\DATA\JJH\Sweep\' datestr(now,'yyyy-mm-dd') '\'];
fSavename      =	['JJH-linsweep-' datestr(now,'yyyy-mm-dd')]; 
fSoundname     = 'sweep-lin.wav';                                          % fSoundname	=	'sweep-exp.wav';

if ~exist(fdir,'dir'); mkdir(fdir); end

% Load circuit
RZ6_1circuit	=	which('RZ6_WAVplay.rcx');
zBus           =	ZBUS(1); % zBus, number of racks
RZ6_1          =	RZ6(1,RZ6_1circuit); % Real-time acquisition
fsRZ6          =	RZ6_1.GetSFreq;

% Load & process sound file
%	-	resamples and converts to row vector as necessary.
%	-	resample only works on column vectors; WriteTagV only accepts row
%		vectors
[data,fsWav]  =	audioread(fSoundname);

if size(data,2) < 3                                                        % in other words: oriented in column format
	data	=	resample(data,floor(fsRZ6),floor(fsWav));
else                                                                       % data oriented in row format
	data	=	data';                                                         % transpose for resample
	data	=	resample(data,floor(fsRZ6),floor(fsWav));
end
data		=	data';                                                         % transpose for WriteTagV
data		=	10*data; 

% Define Circuit parameters
nsamples	=	length(data);
delay		=	0;                                                             % [ms]
atten		=	0;                                                             % [dB] attenuation

% Speaker selection
dum         = spherelookupMinor;
nSpeakers   = dum.nspeakers;
speakers    = dum.lookup;
speakers    = speakers(~isnan(speakers(:,5)),:);                           % remove NaN entries (i.e. unused MUX channels
dev			= speakers(:,2);			
chan        = speakers(:,3);

% Set parameters to RZ6
RZ6_1.SetTagVal('delaySND',delay);                                         % [ms] (probs not important here)
RZ6_1.SetTagVal('eventSND',1); 
RZ6_1.SetTagVal('bufferSize',nsamples);                                    % [ms]
RZ6_1.WriteTagV('soundIn',0,data);
RZ6_1.SetTagVal('attenuationA',atten); 
RZ6_1.SetTagVal('attenuationB',atten);


%% Loop
%
pause(10)
for ii = 1:length(speakers)
	% Set MUXes
	zBus.zBusTrigA(0, 0, 2);                                                % reset
   for iM = 1:4 
      MUX(RZ6_1,iM,0)                                                      % reset muxes
   end
   
	% Set MUX
	MUX(RZ6_1,dev(ii),chan(ii));

	% Run sweep 
	%	-	software trigger is appropriate for this experiment
	zBus.zBusTrigB(0, 0, 2);                                                % start event 1/trial onset; 
	pause(nsamples/fsRZ6);                                                  % Wait in case 'Active' doesn't work properly)
	while RZ6_1.GetTagVal('Active') 
      pause(.05);                                                          % wait...
	end
	pause(.3);
   
	% Get RZ6 parameters
	%	-	Sounds
	Sounds.in         = RZ6_1.ReadTagV('soundIn',0,nsamples);
	Sounds.out        = RZ6_1.ReadTagV('input2',0,nsamples);
	Sounds.recorded   = RZ6_1.ReadTagV('Recording',0,nsamples);
   
	%	-	Debugging parameters (less important)
	position          = RZ6_1.GetTagVal('bufferPos');
	posEndIn          = RZ6_1.GetTagVal('posIn');
	posEndOut         = RZ6_1.GetTagVal('posOut');

	% Save sounds for offline analysis
	if ~exist(fdir,'dir'); mkdir(fdir); end
   
	speaker           = speakers(ii,:);
	save([fdir fSavename '-' num2str(ii)],'Sounds','fsRZ6','speaker');
end

%% Calibrator (Only activate when needed)
% - i.e. when hooked up to calibrator. OR to get a recording of 'quiet'
Tend           = 30;
nsamples       = Tend*fsRZ6; 

RZ6_1.SetTagVal('bufferSize',nsamples); % [ms]
RZ6_1.WriteTagV('soundIn',0,zeros(size(data)));

zBus.zBusTrigA(0, 0, 2); % reset
zBus.zBusTrigB(0, 0, 2); % start event 1/trial onset; 

pause(Tend);
while RZ6_1.GetTagVal('Active')
   pause(0.05)                                                            % Wait
end

Sounds.in         = RZ6_1.ReadTagV('soundIn',0,nsamples);
Sounds.out        = RZ6_1.ReadTagV('input2',0,nsamples);
Sounds.recorded   = RZ6_1.ReadTagV('Recording',0,nsamples);

save([fdir fSavename '-calibrator'],'Sounds','fsRZ6');

% % filtering and visualization
% [B,A]		=	butter(4,20/fsRZ6,'high');
% 	
% cal			=	Sounds.recorded; % [V]
% cal			=	cal - mean(cal);
% % cal			=	filtfilt(B,A,cal);
% % Ppulse		=	rms(cal);
% 
% % CHECK fft magnitude @ 1000 Hz to calibrate.
% % Pcalibrated =	scaling*cal;
% Fcalibrated =	abs(fft(Pcalibrated));
% Fcalibrated =	Fcalibrated(1:length(Fcalibrated)/2);
% Fdbcalibrated=	10*log10(Fcalibrated);
% Farray		=	linspace(0,fsRZ6/2,length(Fdbcalibrated));
% 
% Pref		=	10^((94-0.3)/20); % [V] -0.3 dB correction for free-field microphones
% scaling		=	Pref/Ppulse;
% 
% figure(1);
%  clf;
%  subplot(131);
%  plot(Sounds.recorded)
%  subplot(132);
%  plot(cal);
%  subplot(133);
%  semilogx(Farray,Fdbcalibrated)

%% Plot results (first check)

tArray = (1:length(Sounds.in)) / fsRZ6;

% Time domain
figure(1); 
subplot(411);
plot(tArray,Sounds.in);
title('sent to TDT');

subplot(412);
plot(tArray,Sounds.out);
title('Played by TDT');

subplot(413);
plot(tArray,Sounds.recorded);
title('Recorded');
xlabel('# of samples');

freqs = linspace(1,fsRZ6,nsamples);

% F-domain
figure(2); 
subplot(4,1,1);
getpower(Sounds.in,length(Sounds.in),'display',2);
title('sent to TDT');

subplot(4,1,2);
getpower(Sounds.out, length(Sounds.in),'display',2);
title('Played by TDT');

subplot(4,1,3);
getpower(Sounds.recorded,length(Sounds.in),'display',2);
title('Recorded');
xlabel('Frequencies');


