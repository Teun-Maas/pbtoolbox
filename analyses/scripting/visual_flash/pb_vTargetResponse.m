%% Initialize
%  Clean everythimg

cfn = pb_clean('cd','/Users/jjheckman/Desktop/Data/wouter/static/test'); % clean everything, and change directory

% load epoched data
l = dir('epoched_data_*.mat');
for iL = 1:length(l)
   load(l(iL).name);
end

% load saccades
l = dir(['sacdet' filesep 'sacdet*.mat']);
load(['sacdet' filesep l(1).name]);


%% Extract data

% get epoched gaze data traces
azimuth     = Data.epoch.AzGazeEpoched;
elevation   = Data.epoch.ElGazeEpoched;

%  Run over saccades
for iS = 1:length(Sac)
   trial_idx = Sac(iS,1);
   
   % Get timings
   start_trial_idx   = (trial_idx-1)*360+1;
   stimOn_idx        = start_trial_idx;
   sacOn_idx         = Sac(iS,3) + start_trial_idx-1;
   sacOff_idx        = Sac(iS,4) + start_trial_idx-1;
   
   % Super sac
   SS(iS,1:4)  = Sac(iS,1:4);                            % trial / saccade nr / sacc on sample / sac off sample
   SS(iS,5)    = 1/120 * 1000 *  Sac(iS,3);              % RT
   SS(iS,6)    = 1/120 * 1000 *  (Sac(iS,4)-Sac(iS,3));  % Duration
   SS(iS,7)    = azimuth(sacOn_idx);                     % Azimuth onset position
   SS(iS,8)    = elevation(sacOn_idx);                   % Elevation onset position
   SS(iS,9)    = azimuth(sacOff_idx);                    % Azimuth offset position 
   SS(iS,10)   = elevation(sacOff_idx);                  % Elevation offset position
   SS(iS,11)   = SS(iS,9) - SS(iS,7);                    % Azimuth Saccade amplitude
   SS(iS,12)   = SS(iS,10) - SS(iS,8);                   % Elevation Saccade amplitude
   SS(iS,13)   = Data.stimuli.azimuth(SS(iS,1));         % Target Azimuth
   SS(iS,14)   = Data.stimuli.elevation(SS(iS,1));       % Target Elevation
end


%%

% criteria
sel_first   = SS(:,2)==1;                                   % only first saccade                     
sel_timing  = SS(:,5)>80 & SS(:,5)<400;                    % between 80 - 400 ms

sel_SS      = sel_first & sel_timing;                           % combine all selections
nSS         = SS(sel_SS,:);
n_sacc      = sum(sel_SS);


c_title = {'Azimuth','Elevation'};

col =  pb_selectcolor(2,2);
cfn = pb_newfig(cfn);
for iS = 1:2
   % get data
   target   = nSS(:,12+iS);
   resp     = nSS(:,10+iS);
   
   % graph
   subplot(1,2,iS);
   hold on;
   axis square;
   title(c_title{iS});
   h(iS) = plot(target,resp,'o');
   hr(iS) = pb_regplot(target,resp,'data',false);
   xlabel('Target ($^{\circ}$)');
   ylabel('Response ($^{\circ}$)')
   xlim([-50 50]);
   ylim([-50 50]);
   pb_dline;
end
pb_nicegraph;

% color
for iH = 1:length(h)
   h(iH).Color    = col(iH,:);
   hr(iH).Color   = pb_brighten(col(iH,:));
end


   
   
   
   
