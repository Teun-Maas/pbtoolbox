% PB_ANALYSISSACDET
%
%  Goal:                                                                  
%  This script will guide you semi-automated through the process of       
%  selecting and loading the data.  
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

%% Select your Data folder

cd('/Users/jjheckman/Documents/Data/PhD'); % default data directory
cdir = uigetdir(); if cdir ~= 0; cd(cdir); end


%%

path = pb_getdir('dir','/Users/jjheckman/Documents/Data/PhD/ms_dds');
cd(path);

%% Set variables

prompt = {
    'Enter experimenter initials (XX): ', ...
    'Enter year (YY): ', ...
    'Enter month (MM): ', ...
    'Enter day (DD): ', ...  
    'Particpant (000n): '};

formatOut = 'yy'; YYd = datestr(now,formatOut);
formatOut = 'mm'; MMd = datestr(now,formatOut);
formatOut = 'dd'; DDd = datestr(now,formatOut);

defAns = {'JJH',YYd,MMd,DDd,'000'};

title = 'Experiment selection';
numlines = 1;

answ = inputdlg(prompt,title,numlines,defAns);

s.XX = answ{1};
s.YY = answ{2};
s.MM = answ{3};
s.DD = answ{4};
s.PN = answ{5};

clear answ DDd defAns formatOut MMd numlines prompt title YYd;

fname = strcat(s.XX,'-',s.PN,'-',s.YY,'-',s.MM,'-',s.DD);

fn.s2hd = { 
    strcat(fname,'-0000.sphere'), ...
    strcat(fname,'-0001.sphere')};

fn.cal = strcat(fname,'-0000.csv');


%% create data files

spheretrial2complete(); % creates 2 .sphere files: calibration "0000" block, and data "000n" block 

% 1. Set trial directory as the 'Current Folder'
% 2. run spheretrial2complete();

sphere2hoopdat(fn.s2hd{1}); % calibration (*-0000-*.sphere) and data (*-000n-*.sphere) -> .dat
sphere2hoopdat(fn.s2hd{2});

sphere2hoopcsv(fn.s2hd{1}); % 2 calibration and data -> .csv
sphere2hoopcsv(fn.s2hd{2});

pa_calibrate() % calibrates "0000.csv" data: SELECT FILES MANUALLY

% 1. run neural network
% 2. save
% 3. calibrate

% output: *.hv

%% Fine tune saccades

pa_sacdet(strcat(fname,'-0001.hv')); % input: *.hv output:*.hv


%% Load variables

pa_sac2mat(); % MANUALLY select! input: *.hv / output: *.mat
load(strcat(fname,'-0001.mat')) % load 'XX-0001-YY-MM-DD-000n.mat --> create: Sac, Stim
clear fn fname s;
S = pb_stim2MSstim(Stim);
[M] = pa_supersac(Sac,S);

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

