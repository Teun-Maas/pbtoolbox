CAL = load('/Users/jasperhvanderheijdt/Documents/Werk/Meetdata/Sweeps/JH-9998-2019-03-27/JH-linsweep-8888-2019-03-27-0001-calibrator.mat');
CAL = load('load('JH-linsweep-2019-03-28-calibrator.mat');
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

%% Some sound recording 
load('JH-0000-19-03-27-0000-0003.sphere','-mat');

% Scaling, FFT's, corrections

nfft = 2^(nextpow2(length(soundRecording))-1);
soundRecording = scaling*soundRecording;

[fArray,fBurst] = genfft(soundRecording,nfft,cfg.RZ6Fs);
fBurst = sqrt(2)/length(soundRecording) * fBurst; % Correction (Parseval theorem)
fBurst= 20*log10(fBurst/P0); % dB conversion

figure(1);
clf;
semilogx(fArray,fBurst);