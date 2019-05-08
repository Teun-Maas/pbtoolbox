% 5-second sine waves for each speaker & recordings
% For analysis (speaker linearity)

% Goal
% - Octaves 250-16000 Hz. Done? 
% - Steps: record each octave separately, change manually
% - 0:5:80 dB (how do I do this?). Done?
% - 29 speakers. 
% - Todo: build loop that runs past all speakers 

clearvars;
close all;

RZ6_1circuit   = which('RZ6_WAVplay.rcx');
zBus           = ZBUS(1);                                                  % zBus, number of racks
RZ6_1          = RZ6(1,RZ6_1circuit);                                      % Real-time acquisition

% Create the input sine wave

% parameters
fs       = RZ6_1.GetSFreq;                                                 % [Hz] - convenient!
Tend     = 1;                                                              % [s]
nsamples = fs * Tend;                                                        % [-]
t        = linspace(0,Tend,nsamples);
A        = 1;                                                              % [dB?] - amplitude
fBase    = [250 500 1e3 2e3 4e3 8e3 16e3]';                                % [Hz]

% Signal generation
omega    = 2 * pi * fBase;
signal   = A * sin(omega*t);

% Add 5 ms ON/OFF ramps
tRamp    = 5e-3;                                                           % [s]
xRamp    = linspace(0,1,floor(fs*tRamp));
xWin     = [xRamp ones(1,length(signal) - 2*length(xRamp)) fliplr(xRamp)];

% Finalize the signal
signal 	= xWin .* signal;

% Speaker selection
dum         = spherelookupMinor;
nSpeakers   = dum.nspeakers;
speakers    = dum.lookup;
speakers    = speakers(~isnan(speakers(:,5)),:);                           % remove NaN entries (i.e. unused MUX channels

% Other parameters
delay    = 0; % [ms]
atten    = 0:10:80; % dB

% Prepare saving parameters
fdir  = ['C:\DATA\JJH\sineTests\' datestr(now,'yyyy-mm-dd') '\'];
if ~exist(fdir,'dir'); mkdir(fdir); end

%% THINK: HOW DO I WANT TO ANALYZE DATA? BUILD THIS LOOP/PARAMETER SAVING METHOD TO REFLECT  THAT
% I  data for each speaker separately (so we know if 1 needs
% replacement). I think levels can be combined (later). 
% Loop over all speakers, attenuation levels and frequencies.

% Reset speakers
for iM = 1:4 
   MUX(RZ6_1,iM,0)                                                         % reset muxes
end

for ii = 1:length(speakers)
	dev = speakers(ii,2);
	chan = speakers(ii,3);
	for jj = 1:length(atten)
		for kk = 1:length(fBase)	
			[Sounds(kk,:),~] = runWavPlay(RZ6_1,zBus,signal(kk,:),atten(jj),delay,dev,chan);	
			% Save the Sound inputs and outputs
			Para.device = dev;
			Para.channel = chan;
			Para.freq = fBase(kk);
			Para.Attenuation = atten(jj);			
		end
		fname = ['JJH-' datestr(now,'yyyy-mm-dd') '-Atten' num2str(atten((jj))) 'dB-Spk' num2str(ii)];
		save([fdir fname],'Sounds','fs','Para');
	end
	% Reset speakers
   for iM = 1:4 
      MUX(RZ6_1,iM,0)                                                      % reset muxes
   end
end
clear('dev','chan');
% Save all parameters relevant for reconstruction (that are the same for
% each trial
save([fdir 'JJH-' datestr(now,'yyyy-mm-dd') '-master'],'signal','fBase','Tend','speakers');

%% What did we actually do? (Analysis)
% TODO: Calculate FFT's (function!)
% TODO: Process Calibrator pulse
% TODO: Convert to dB (write function for this?)
% TODO: Plot the results for each speaker, per F-band (subplot(4,1,1:7)
% TODO: Save graphs

