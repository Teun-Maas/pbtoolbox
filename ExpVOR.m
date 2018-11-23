%% INIT
pb_clean;
cfn = 0;

prompt = {'Name:','Date'};
title = 'Input';
dims = [1 35];
definput = {'',datestr(datetime('now'),'dd-mm-yyyy')};
answer = inputdlg(prompt,title,dims,definput);
fn = ['ExpVOR_' answer{2} '_' answer{1}];


%% DEFINE SIGNAL

dur   = [3 60 60 3];
SR 	= 10;
freq  = .1;
amp   = 15;

sig.v(1) = pb_vCreateSignal(1, dur(1), SR, freq, 'none');
sig.h(1) = pb_vCreateSignal(1, dur(1), SR, freq, 'turn');
sig.h(1).x = sig.h(1).x .* amp;

sig.v(2) = pb_vCreateSignal(1, dur(2), SR, freq, 'turn');
sig.h(2) = pb_vCreateSignal(1, dur(2), SR, freq, 'none');
sig.v(2).x = sig.v(2).x .* amp;
sig.h(2).x = sig.h(2).x + sig.h(1).x(end);

sig.v(3) = pb_vCreateSignal(1, dur(3), SR, freq, 'none');
sig.h(3) = pb_vCreateSignal(1, dur(3), SR, freq, 'none');
sig.v(3).x = sig.v(3).x + sig.v(2).x(end);
sig.h(3).x = sig.h(3).x + sig.h(2).x(end);

sig.v(4) = pb_vCreateSignal(1, dur(4), SR, freq, 'none');
sig.h(4) = pb_vCreateSignal(1, dur(4), SR, freq, 'turn');
sig.v(4).x = sig.v(4).x + sig.v(3).x(end);
sig.h(4).x = -1 .* sig.h(4).x .* amp  + sig.h(3).x(end);

ver = [sig.v(1).x sig.v(2).x sig.v(3).x sig.v(4).x];
hor = [sig.h(1).x sig.h(2).x sig.h(3).x sig.h(4).x];

t = (0:1:length(ver)-1)/10;

[cfn,h] = pb_newfig(cfn);
hold on;
plot(t,ver,t,hor);
legend('vertical','horizontal')
pb_vline(3);
pb_vline(sum(dur(1:end-1)));
pb_nicegraph


%% RUN EXP

% VESTIBULAR CHAIR
if ispc 
   %%  initialize recordings
   rc             = pb_runPupil; 
   [ses,streams]  = pb_runLSL('de',false);
   pb_vEndExp

   %%  start recording
   pb_startLSL(ses);
   pb_startPupil(rc);
   
   %% initialize and send servo
   vs   = vs_servo;
   vs.write_profile(ver,hor);
   
   %% start servo
   vs.enable;
   pause(1);
   vs.start;
   
   %% run exp
   pause(sum(dur)+4);
   
   %% stop servo
   vs.stop;
   vs.disable;
   
   %% read servo
   [sv.vertical,sv.horizontal] = vs.read_profile_sv;
   [pv.vertical,pv.horizontal] = vs.read_profile_pv;
   
   %% Store dat
   Dat.PL_Python    = streams(1).read;
   Dat.PL_Gaze      = streams(2).read;
   Dat.PL_Primitive = streams(3).read;
   Dat.OT_Rigid     = streams(4).read;
   
   %% empty exp
   
   delete(vs);
   delete(streams);
   delete(rc);
   delete(ses);
   pb_vEndExp
end

cd(userpath);
save(fn,'Dat','sv','pv');





