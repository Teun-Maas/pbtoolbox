% PB_ANALYSISSACDET
%
%  Goal:                                                                  
%  This script will guide you semi-automated through the process of       
%  selecting and loading the data.  
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

%% Select your Data folder

cd('/Users/jjheckman/Documents/Data/PhD'); % default data directory
cdir = uigetdir(); if cdir ~= 0; cd(cdir); end


%% Get variables

d = dir('*.sphere');
sname = d(1).name

experimenter    = pb_delreadstr(sname,'delimiter','-','n',1);
participant     = pb_delreadstr(sname,'delimiter','-','n',2);
year            = pb_delreadstr(sname,'delimiter','-','n',3);
month           = pb_delreadstr(sname,'delimiter','-','n',4);
day             = pb_delreadstr(sname,'delimiter','-','n',5);

bname = [experimenter '-' participant '-' year '-' month '-' day '-']

%% create data files

spheretrial2complete(); % creates 2 .sphere files: calibration "0000" block, and data "000n" block 

%% Prep Calibration data

[fname,~] = pb_getfile('ext',[bname '*.sphere'],'dir',cdir);

sphere2hoopdat(fname); % calibration 
sphere2hoopcsv(fname)

%% Calibrate experiment data

[fname,~] = pb_getfile('ext',[bname '*.sphere'],'dir',cdir);

sphere2hoopdat(fname); % data
sphere2hoopcsv(fname);

%%

pa_calibrate() % calibrates "0000.csv" data: SELECT FILES MANUALLY

% 1. run neural network
% 2. save
% 3. calibrate

% output: *.hv

%% Fine tune saccades

% CalibPupilDataDDS.m
% Pupil2hvDDS.m

pa_sacdet(fname); % input: *.hv output:*.hv


%% Load variables

pa_sac2mat(); % MANUALLY select! input: *.hv / output: *.mat
load(fname) % load 'XX-0001-YY-MM-DD-000n.mat --> create: Sac, Stim
clear fn fname s;
S = pb_stim2MSstim(Stim);
[M] = pa_supersac(Sac,S);

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

