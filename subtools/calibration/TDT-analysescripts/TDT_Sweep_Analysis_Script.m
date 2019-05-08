%TDT_Sweep_Analysis_Script

%% First things first: Calibration scaling factor

% Calibration

CAL = load('JH-linsweep-2019-04-26-calibrator.mat');
cal   = CAL.Sounds.recorded; % [V]

Ppulse  = rms(cal);
P0 = 1;
DBref = 94 - 0.3; % dB SPL
Pref  = P0*10^((DBref)/20); % [Pa] -0.3 dB correction for free-field microphones

scaling  = Pref/Ppulse;
Pcal = scaling*cal;

nfftCal = 2^(nextpow2(length(cal)-1));

[Farray,Fcal]	=	genfft(Pcal,nfftCal,CAL.fsRZ6);
Fcal	=	sqrt(2)/length(cal) * Fcal;
Fdb			= 20*log10(Fcal/P0);

%% Second things second: FFT calculations of scaled outputs

% Dates of different measurements:
% - w/o extra amplifiers (so obsolete): 2019-03-28
% - With amplifiers (current): 2019-04-26
fdir = '/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/Sweeps/2019-04-26/';
fNameBase = 'JH-linsweep-2019-04-26-';
fNameExt  = '.mat';
 
Nsweep = 20;


for iSp = 1:29
	fnameTemp = [fNameBase num2str(iSp) fNameExt];
	load(fnameTemp);
	Nsamples = length(Sounds.in)/Nsweep;
	recordings(iSp,:) = scaling*Sounds.recorded; % dB
	recOut(iSp,:) = Sounds.out;
	[MagRec(:,iSp),Freq] = compSweepMag(recordings(iSp,:),Nsamples,Nsweep,round(fsRZ6));

end		
% convert to dB
MagRec	=	sqrt(2)/length(MagRec) * MagRec;
MagRec		= 20*log10(MagRec/P0);
MagMeans =  mean(MagRec,2);

sweepIn = Sounds.in; % All the same, anyways
[MagIn,Freq] = compSweepMag(sweepIn,Nsamples,Nsweep,round(fsRZ6));



%% Plot 1: Sweeps in and out, in T- and F-domain, for each speaker
xVals = [1e2 1e3 1e4];
xNames = [0.1 1 10]; % kHz
xlimits = [50 fsRZ6/2];
tArray = (1:length(recordings))/fsRZ6;
hFig = figure(1); 
clf
subplot(2,2,1)
plot(tArray,sweepIn);
xlabel('Time (s)','FontSize',24);
ylabel('Unscaled amplitude (A.U.)','FontSize',24);
title('Input','FontSize',24);
ax = gca;
ax.FontSize = 24; 
subplot(2,2,2);
plot(tArray,recordings(1,:)/scaling);
ax = gca;
ax.FontSize = 24; 

xlabel('Time (s)','FontSize',24);
ylabel('Unscaled amplitude (V)','FontSize',24);
title('Recorded sweep (example)','FontSize',24);
ax = gca;
ax.FontSize = 24; 
hold off 
subplot(2,2,3);
semilogx(Freq,round(MagIn));
xlabel('Frequency (kHz)','FontSize',24);
ylabel('Unscaled amplitude (V)','FontSize',24);
xticks(xVals);
xticklabels(xNames);
xlim(xlimits);
ylim([0 120]);
ax = gca;
ax.FontSize = 24; 
subplot(2,2,4)
semilogx(Freq,MagRec(:,1));
hold on
% semilogx(Freq,MagMeans,'r','LineWidth',2);
xlabel('Frequency (kHz)','FontSize',24);
ylabel('Magnitude (dB SPL)','FontSize',24);
ax = gca;
ax.FontSize = 24; 
xlim(xlimits);
xticks(xVals);
xticklabels(xNames);
hold off

hTxt = suptitle('Sweep example');
hTxt.FontSize = 36;
fancify(hFig)


%% Plots: FFT's and time domains of different sweeps (troubleshoots)
hFig = figure(7);
hax(1) = subplot(311);
plot(tArray,Sounds.in);
hax(2) = subplot(312);
plot(tArray,Sounds.out);
hax(3) = subplot(313);
plot(tArray,Sounds.recorded);

linkaxes(hax,'x');
