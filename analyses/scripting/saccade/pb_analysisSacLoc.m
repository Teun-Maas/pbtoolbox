% PB_ANALYSISSACLOC
%
% This script semi-automates your saccade localization analyses.
 
% PBToolbox (2017): JJH: j.heckman@donders.ru.nl

%% Load data

% clear all hidden;
% close all;
cfn = 0;

cdir = '/Users/jjheckman/Documents/Data/PhD/';
[fpath] = pb_getfile('dir',cdir,'ext','*.mat');
if ~isempty(fpath); load(fpath); end

%% Convert MSI Stim

S = pb_stim2MSstim(Stim);                       % convert 'Stim' to contain multisensory stimuli 

%% Extract modality-specific supersac data

V = pa_supersac(Sac, S,1,0);                    % visual
A = pa_supersac(Sac, S,2,0);                    % auditory
B = pa_supersac(Sac,S,3,0);                     % bimodal
M = [V;A;B];                                    % all


%% Evaluate stimulus duration

ss = M(M(:,30)==1,:);                           % 1 ms
sm = M(M(:,30)==3,:);                           % 3 ms
lm = M(M(:,30)==10,:);                          % 10 ms
ll = M(M(:,30)==30,:);                          % 30 ms

cfn=cfn+1; figure(cfn);

% Azimuth
y = ss(:,8); x = ss(:,23);
subplot(2,4,1); pb_regplot(x,y);
title('Azimuth accuracy for 1ms');
ylabel('Saccade Offset (\alpha degrees)');
xlabel('Target (\alpha degrees)');
pb_dline; axis([-100 100 -100 100]);

y = sm(:,8); x = sm(:,23);
subplot(2,4,2); pb_regplot(x,y); 
title('Azimuth accuracy for  3ms');
xlabel('Target (\alpha degrees)');
pb_dline; axis([-100 100 -100 100]);

y = lm(:,8); x = lm(:,23);
subplot(2,4,3); pb_regplot(x,y);
title('Azimuth accuracy for 10ms');
xlabel('Target (\alpha degrees)');
pb_dline; axis([-100 100 -100 100]);

y = ll(:,8); x = ll(:,23);
subplot(2,4,4); [~,~,~] = pb_regplot(x,y);
title('Azimuth accuracy for 30ms');
xlabel('Target (\alpha degrees)');
pb_dline; axis([-100 100 -100 100]);

% Elevation
y = ss(:,9); x = ss(:,24);
subplot(2,4,5); pb_regplot(x,y); 
title('Elevation accuracy for 1ms');
ylabel('Saccade Offset (\epsilon degrees)');
xlabel('Target (\epsilon degrees)');
pb_dline; axis([-100 100 -100 100]);

y = sm(:,9); x = sm(:,24);
subplot(2,4,6); pb_regplot(x,y); 
title('Elevation accuracy for 3ms');
xlabel('Target (\epsilon degrees)');
pb_dline; axis([-100 100 -100 100]);

y = lm(:,9); x = lm(:,24);
subplot(2,4,7); pb_regplot(x,y); 
title('Elevation accuracy for 10ms');
xlabel('Target (\epsilon degrees)');
pb_dline; axis([-100 100 -100 100]);

y = ll(:,9); x = ll(:,24);
subplot(2,4,8); pb_regplot(x,y); 
title('Elevation accuracy for 30ms');
xlabel('Target (\epsilon degrees)');
pb_dline; axis([-100 100 -100 100]);

pb_nicegraph;



%% Plot saccades:

udur = unique(round(M(:,30)));
length(udur)
cfn=cfn+1; figure(cfn); clf;

for i = 1:length(udur)
   
    subplot(2,3,i)
    hold on;
    
    sel = M(:,30) == udur(i) & M(:,2) == 2;
    
    pb_regplot(M(sel,24),M(sel,9));
    axis([-60 60 -60 60]);
    pb_dline; 
end

pb_nicegraph;


%% Saccade kinematics: 'Main Sequence'


% Select data
sel = M(:,16) <= 900;
M = M(sel,:);
Dur = M(:,14); PkV = M(:,16); Amp = M(:,12);

cfn=cfn+1;figure(cfn); clf;

% Duration vs  amplitude 
subplot(1,2,1);
plot(Amp,Dur,'o');
xlabel('Amplitude'); ylabel('Duration');

% Pk velocity vs amplitude 
subplot(1,2,2);
plot(Amp,PkV,'o');
xlabel('Amplitude'); ylabel('Pk Velocity');

pb_nicegraph;


%% Probit plot

OnM = M(:,3)./6.1035-200; OffM = M(:,4)/6.1035-200;
OnA = A(:,3)./6.1035-200; OffA = A(:,4)/6.1035-200;
OnV = V(:,3)./6.1035-200; OffV = V(:,4)/6.1035-200;
OnB = B(:,3)./6.1035-200; OffB = B(:,4)/6.1035-200;

rtM = OnM+M(:,17);
rtA = OnA+A(:,17);
rtV = OnV+V(:,17);
rtB = OnB+B(:,17);

cfn=cfn+1; figure(cfn); clf;

subplot(221); hold on;
[~,stats] = pb_probit(rtV,'disp','true'); title('Visual ordinate');

subplot(222); hold on;
pb_probit(rtA); title('Auditory ordinate');

subplot(223); hold on;
pb_probit(rtB); title('Bimodal ordinate');

subplot(224); hold on;
pb_probit(rtM); title('Combined ordinate');


pb_nicegraph;

% Set different colors
col = pb_selectcolor(4,2);

for indA = 1:4
    subplot(2,2,indA);
    h = findobj(gca,'Type','Line');
    set(h,'Color', col(indA,:));
end


%% PROBIT SEL


cfn=cfn+1; figure(cfn); clf;
subplot(131); title('Auditory ordinate');
hold on;

gs = 45;
% auditory
A_uR  = unique(round(A(:,25)./gs).*gs)
num2str(A_uR)

for i=1:length(A_uR)
    sel = round(A(:,25)/gs)*gs == A_uR(i);
    OnA = A(:,3)./6.1035-200;
    rtA = OnA;%+A(:,17);
    rtA = rtA(sel);
    
    pb_probit(rtA); 
end

% visual
V_uR  = unique(round(V(:,25)/gs)*gs);
subplot(132); title('Visual Oridnate');
hold on;

for j=1:length(V_uR)
    sel = round(V(:,25)/gs)*gs == V_uR(j);
    OnV = V(:,3)./6.1035-200;
    rtV = OnV;%+V(:,17);
    rtV = rtV(sel);
    
    pb_probit(rtV);
end
legend(num2str(V_uR))

% bimodal


B_uR  = unique(round(B(:,25)/gs)*gs);
subplot(133); title('Bimodal Oridnate');
hold on;

for k=1:length(B_uR)
    sel = round(B(:,25)/gs)*gs == B_uR(k);
    OnB = B(:,3)./6.1035-200;
    rtB = OnB;%+B(:,17);
    rtB = rtB(sel);
    
    pb_probit(rtB);
end
legend(num2str(B_uR))


pb_nicegraph


%% 


cfn=cfn+1; figure(cfn); clf;
hold on;

for i=1:6
    subplot(6,3,i);
    load(['snd' num2str(i*100)])
    samples = length(snd);
    t = 0:1:samples-1;
    t = t./soundFs*1000;
    plot(t,snd)
    hold on;
    syms x
    pulse = heaviside(x)-heaviside(x-(samples-1)/soundFs*1000);
    fplot(5*pulse);
    h = findobj(gca,'Type','FunctionLine');
    col=pb_selectcolor(2,2);
    set(h,'Color',col(1,:),...
        'LineWidth',2);
    axis([-10 90 -10 10])
    
    
    
end



pb_nicegraph


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
