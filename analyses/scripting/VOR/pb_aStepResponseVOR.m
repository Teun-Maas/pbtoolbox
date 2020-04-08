%% Introduction
%  Simulation of Vestibulo-Ocular Refles (VOR) to a step response
%  
%  

%% Initialize
%  Empty, Clear, Clean, Set globals.

cfn      = pb_clean;

Fs       = 120;
Hz       = 10;
dur      = 200;
times    = (0:dur*Fs)/Fs;
timesl   = length(times);
step     = ones(timesl,1); 
step(1:Fs*5.75) = 0;
step     = lowpass(step,'Fc',0.2,'Fs',Fs);

cfn = pb_newfig(cfn);
plot(times,step,'.')
pb_nicegraph('def',1,'LineWidth',2);
xlim([0 10]);