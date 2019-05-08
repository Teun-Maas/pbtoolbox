% Script for checking room reverberations
% TODO: 
% - Check soundlevel
% - Check sound w/ Snandan (offset 'plop')
% - Test run & analyze
% - Run and analyze all speakers
clearvars;
close all;

RZ6_1circuit   = which('RZ6_WAVplay.rcx');
zBus           = ZBUS(1);                                                  % zBus, number of racks
RZ6_1          = RZ6(1,RZ6_1circuit);                                      % Real-time acquisition

% Create the input sine wave
% parameters
fs       = RZ6_1.GetSFreq;                                                 % [Hz] - convenient!
Tend     = 1;                                                              % [s] 
nsamples = fs*Tend;                                                        % [-]
t        = linspace(0,Tend,nsamples);

signal   = zeros(1,round(fs));
win      = 1e-3;                                                           % [s] = 0.1 ms
offset   = round(0.1*fs);                                                  % [s] = 100 ms

% signal(offset:offset+round(win*fs)) = 9; % Click pulse	
% signal(offset:offset+round(win*fs)) = 2*randn(1,round(win*fs)+1);
signal(offset)       = 1;                                                  % for 1 sample pulse
signal(offset+1)     = -1;
% [signal,fs0] = audioread('chirpnoise.wav');
% signal = signal';
% signal = [signal zeros(1,length(t)-length(signal))];

% Speaker selection
dum         = spherelookupMinor;
nSpeakers   = dum.nspeakers;
speakers    = dum.lookup;
speakers    = speakers(~isnan(speakers(:,5)),:);                           % remove NaN entries (i.e. unused MUX channels)

% Other parameters (for clarity)
delay = 0; % [ms]
atten = 0; % [dB]

% Prepare saving parameters
fdir =['C:\DATA\JJH\Click\' datestr(now,'yyyy-mm-dd') '\'];
if ~exist(fdir,'dir')
   mkdir(fdir);
end
	
%% Loop over all speakers (once)
   
for ii =	1:length(speakers)
   dev         = speakers(ii,2);
   chan        = speakers(ii,3);
   [Sounds,~]  = runWavPlay(RZ6_1,zBus,signal,atten,delay,dev,chan);	
   
   % Save the Sound inputs and outputs
   Para.device    = dev;
   Para.channel   = chan;		

   fname    = ['JJH-' datestr(now,'yyyy-mm-dd') '-click-Spk' num2str(ii)];
   save([fdir fname],'Sounds','fs','Para');
   
   % Reset speakers
   for iM = 1:4 
      MUX(RZ6_1,iM,0)                                                      % reset muxes
   end
end
clear('dev','chan');

%% Plot

T = t*1000;
figure(1);
clf;
ax(1)       = subplot(3,1,1); 
hold on;
plot(T,Sounds.in); 
plot(T,Sounds.store); 

ax(2)       = subplot(3,1,2); 
plot(T,Sounds.out); 

ax(3)       = subplot(3,1,3);
plot(T,Sounds.recorded)

linkaxes(ax,'x');

