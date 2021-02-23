cfn   = pb_clean('cd','/Users/jjheckman/Desktop/PhD/Data/Chapter 3/subj/');
cd(pb_getdir('cdir',cd));
pause(.1); cdir = cd; pause(.1);

fseps =  strfind(cdir,filesep);

% Global
NDUR        = 5;
NMODEL      = 8;
FSAMPLE     = 120;

CONDITION   = pb_sentenceCase(cdir(max(fseps)+1:end));

MODELPAR    = [1 1 1; 
               1 1 0; 
               1 0 1; 
               1 0 0; 
               0 1 1;
               0 1 0;
               0 0 1;
               0 0 0];

% load data
l = dir('epoched*');
load(l(1).name);

durs     = [0.5000    1.0000    2.0000    4.0000  100.0000];
c        = {'I','II','III','IV','V','VI','VII','VIII'};
cnt      = 0;
cnt_c    = 0;

% Build figure
cfn   = pb_newfig(cfn);
sgtitle([CONDITION ' (s00' num2str(cdir(fseps(end-1)-1)) ')']);
for iM = 1:NMODEL

   for iSP = 1:NDUR
      cnt = cnt+1;
      h(iM,iSP) = subplot(NMODEL,NDUR,cnt);
      
      if cnt < 6; title([num2str(durs(iSP)) ' ms']); end
      if mod(cnt,5) == 1; cnt_c = cnt_c+1; ylabel(c{cnt_c}); end 
      
      hold on;
      axis square;
      xlim([-50 50]);
      ylim([-50 50]);
      pb_dline;

      %  Get parameters for analysis
      M(iM,iSP).dGy  = [];
      M(iM,iSP).dGx  = [];
      
      L(iSP).RT      = [];
      L(iSP).Cs      = [];
      L(iSP).Hc      = [];
      L(iSP).Eh      = [];
      L(iSP).Tr      = [];
      L(iSP).G       = [];
      L(iSP).Rx      = [];
      L(iSP).Ry      = [];
      L(iSP).sC      = [];
   end
end

%%

DEBUG       = true;
tsEpoch     = (0:359)/120;

for iB = 1:length(Data.timestamps)
   % Run over all blocks for participant
   
   % % Preallocate empty variables
   clear StartAz StartEl ResultAz ResultEl Sac
      
   p_HpOn         = [];
   p_HpOff        = [];

   p_HaOnAz       = [];
   p_HaOffAz      = [];
   p_EhOnAz       = [];
   p_EhOffAz      = [];

   p_HaOnEl       = [];
   p_HaOffEl      = [];
   p_EhOnEl       = [];
   p_EhOffEl      = [];
   
   p_HpStim       = [];
   p_HaStimEl     = [];
   p_HaStimAz     = [];
   p_EhStimEl     = [];
   p_EhStimAz     = [];

   % Load saccades
   l = dir(['JJH-*_block_' num2str(iB) '.AzElGazeAB']);
   load(l(1).name,'-mat');
   
   % Select trials with saccades
   trials      = Sac(:,1);
   trialslen   = length(trials);
   
   % Get stimulus information
   TcA      = Data.stimuli(iB).azimuth(trials);
   TcE      = Data.stimuli(iB).elevation(trials);
   duration = Data.stimuli(iB).duration(trials);
   
   
   for iT = 1:trialslen
      % Run over all saccades that are detected to get time indices and positions
      
      % Get epoch samplenrs
      start_trial_idx   = (trials(iT)-1)*360;
      stimOn_idx        = Sac(iT,2) + start_trial_idx;
      SacOn_idx         = Sac(iT,3) + start_trial_idx;
      SacOff_idx        = Sac(iT,4) + start_trial_idx;
      latency(iT)       = Sac(iT,3) / FSAMPLE * 1000;
      
      % graph
      if DEBUG
         pb_newfig(231);
         clf; 
         title([num2str(duration(iT)) ' ms'])
         hold on;
         axis square;
         
         plot(tsEpoch, Data.epoch(iB).AzGazeEpoched(stimOn_idx:stimOn_idx+359));
         plot(tsEpoch, Data.epoch(iB).ElGazeEpoched(stimOn_idx:stimOn_idx+359));
         plot(tsEpoch, Data.epoch(iB).AzEyeEpoched(stimOn_idx:stimOn_idx+359));
         plot(tsEpoch, Data.epoch(iB).ElEyeEpoched(stimOn_idx:stimOn_idx+359));
         plot(tsEpoch, Data.epoch(iB).AzHeadEpoched(stimOn_idx:stimOn_idx+359));
         plot(tsEpoch, Data.epoch(iB).ElHeadEpoched(stimOn_idx:stimOn_idx+359));
         plot(tsEpoch, Data.epoch(iB).AzChairEpoched(stimOn_idx:stimOn_idx+359));
         plot(tsEpoch(1), TcA(iT),'*');
         plot(tsEpoch(1), TcE(iT),'*');
         
         pb_vline([tsEpoch(Sac(iT,3)), tsEpoch(Sac(iT,4))])
         legend('Gaze Az','Gaze El','Eye Az','Eye El','Head Az','Head El','Chair','Target Az','Target El')
         pb_nicegraph('linewidth',2,'def',1);
      end
      
      
      % Saccades on/offset positions
      StartAz(iT)       = Data.epoch(iB).AzGazeEpoched(SacOn_idx);
      StartEl(iT)       = Data.epoch(iB).ElGazeEpoched(SacOn_idx);
      ResultAz(iT)      = Data.epoch(iB).AzGazeEpoched(SacOff_idx);
      ResultEl(iT)      = Data.epoch(iB).ElGazeEpoched(SacOff_idx);
      
      % Eye
      p_EhStimAz(iT)    = Data.epoch(iB).AzEyeEpoched(stimOn_idx);
      p_EhOnAz(iT)      = Data.epoch(iB).AzEyeEpoched(SacOn_idx);
      p_EhOffAz(iT)     = Data.epoch(iB).AzEyeEpoched(SacOff_idx);  
      
      p_EhStimEl(iT)    = Data.epoch(iB).ElEyeEpoched(stimOn_idx);
      p_EhOnEl(iT)      = Data.epoch(iB).ElEyeEpoched(SacOn_idx);
      p_EhOffEl(iT)     = Data.epoch(iB).ElEyeEpoched(SacOff_idx);

      % Head
      p_HaStimAz(iT)    = Data.epoch(iB).AzHeadEpoched(stimOn_idx);
      p_HaOnAz(iT)      = Data.epoch(iB).AzHeadEpoched(SacOn_idx);
      p_HaOffAz(iT)     = Data.epoch(iB).AzHeadEpoched(SacOff_idx);
      
      p_HaStimEl(iT)    = Data.epoch(iB).ElHeadEpoched(stimOn_idx);
      p_HaOnEl(iT)      = Data.epoch(iB).ElHeadEpoched(SacOn_idx);
      p_HaOffEl(iT)     = Data.epoch(iB).ElHeadEpoched(SacOff_idx);

      % Chair
      p_HpStim(iT)      = Data.epoch(iB).AzChairEpoched(stimOn_idx);
      p_HpOn(iT)        = Data.epoch(iB).AzChairEpoched(SacOn_idx);
      p_HpOff(iT)       = Data.epoch(iB).AzChairEpoched(SacOff_idx);  

      
      % compute instanious eye velocity
      clear eye_vel ts retinal_slip
      eye_vel(1,:)         = gradient(Data.epoch(iB).AzEyeEpoched(stimOn_idx:stimOn_idx+359),1/120);
      eye_vel(2,:)         = gradient(Data.epoch(iB).ElEyeEpoched(stimOn_idx:stimOn_idx+359),1/120);
      chair_vel            = gradient(Data.epoch(iB).AzChairEpoched(stimOn_idx:stimOn_idx+359),1/120);
      
      if duration(iT) == 100
         
         x = Data.epoch(iB).AzEyeEpoched(2:14);
         y = Data.epoch(iB).ElEyeEpoched(2:14);
         
         % centralise
         retinal_slip_x(iT) = {x-x(1)};
         retinal_slip_y(iT) = {y-y(1)};
      else
         x = [0; eye_vel(1,2) * duration(iT) / 1000];
         y = [0; eye_vel(2,2) * duration(iT) / 1000];
         
         retinal_slip_x(iT) = {x};
         retinal_slip_y(iT) = {y};
      end
      sign_chair(iT) = sign(chair_vel(2));
   end
   
   % Actual gaze shift
   GazeShiftAz = ResultAz - StartAz;
   GazeShiftEl = ResultEl - StartEl;

   % Head
   dCs      = p_HpOn-p_HpStim;
   dCs(2,:) = zeros(size(dCs));

   dHc      = [p_HaOnAz-p_HaStimAz;
               p_HaOnEl-p_HaStimEl];

   % Eye
   dEh      = [p_EhOnAz - p_EhStimAz;
               p_EhOnEl - p_EhStimEl];

   % Target in retinal coordinates
   TrA = TcA - p_EhStimAz;
   TrE = TcE - p_EhStimEl;
   
   for iM = 1:NMODEL
      pars = MODELPAR(iM,:);
      
      for iSP = 1:NDUR
         sel_sac              = duration == durs(iSP);
         
         new_targets          = [TrA(sel_sac)', TrE(sel_sac)'];
         new_responses        = [GazeShiftAz(sel_sac)',GazeShiftEl(sel_sac)'];
         corrected_targets 	= [];
         
        	X = dCs(:,sel_sac);
       	Y = dHc(:,sel_sac);
       	Z = dEh(:,sel_sac);
         
         for iN = 1:sum(sel_sac) 
            %  Run for the number of stimuli selected
            corrected_targets(iN) = new_targets(iN,1) - (pars(1)*X(iN) - (pars(2)*Y(iN)) - (pars(3)*Z(iN)));
         end
         
         M(iM,iSP).dGx     = [M(iM,iSP).dGx; corrected_targets'];
         M(iM,iSP).dGy     = [M(iM,iSP).dGy; new_responses];
         
         if iM == 1
            new_latency = latency(sel_sac)';
            L(iSP).RT   = [L(iSP).RT; new_latency];
            L(iSP).Tr   = [L(iSP).Tr; new_targets];
            L(iSP).Cs   = [L(iSP).Cs; X'];
            L(iSP).Hc   = [L(iSP).Hc; Y'];
            L(iSP).Eh   = [L(iSP).Eh; Z'];
            L(iSP).G    = [L(iSP).G; new_responses];
            L(iSP).Rx   = [L(iSP).Rx, retinal_slip_x(sel_sac)];
            L(iSP).Ry   = [L(iSP).Ry, retinal_slip_y(sel_sac)];
            L(iSP).sC   = [L(iSP).sC; sign_chair(sel_sac)'];
         end
      end
   end
end

%% Graph: Fill in data
% 
% Select colors
col   = pb_selectcolor(NDUR,1);
% 
min_latency = 120;      % ms
max_latency = 800;     % ms
% 
% R = [];
% % Plot
% for iM = 1:NMODEL
%    for iSP = 1:NDUR
%       axes(h(iM,iSP));
%       
%       % Select saccades
%       sel_sac_lat = L(iSP).RT > min_latency & L(iSP).RT < max_latency ;
%       dGx = M(iM,iSP).dGx(sel_sac_lat);
%       dGy = M(iM,iSP).dGy(sel_sac_lat);
%       
%       % Plot data
%       [h_lines,b,r] = pb_regplot(dGx, dGy);
%       R(end+1) = r;
%       
%       % Set colors
%       h_lines(1).Color = [0 0 0];
%       h_lines(1).MarkerFaceColor = col(iSP,:);
%       h_lines(1).Tag = 'Fixed';
%       
%    end
% end
% 
% pb_nicegraph;

%% probit

cfn = pb_newfig(cfn);
axis('square');
for iSP = 1:5
   pb_probit(L(iSP).RT(L(iSP).RT > min_latency & L(iSP).RT < max_latency),'gcolor',col(iSP,:));
end

h = pb_fobj(gca,'Tag','probit model');
h_dat = h(1:2:end);
h_sum = h(2:2:end);

for iH = 1:length(h_dat)
   h_dat(iH).Color               = col(iH,:);
   h_dat(iH).MarkerFaceColor     = col(iH,:);
   h_dat(iH).MarkerSize          = 10;
   
   h_sum(iH).MarkerSize          = 10;
   h_sum(iH).HandleVisibility    = 'off';
   
   h_dat(iH).Tag = 'Fixed';
   h_sum(iH).Tag = 'Fixed';
end

pb_nicegraph;


%%

cfn = pb_newfig(cfn);
col = pb_selectcolor(5,1);

for iD = 1:5
   
   h(iD)=subplot(1,5,iD);
   axis square;
   hold on;
   
   for iL = 1:length(L(iD).Rx)
      plot(L(iD).Rx{iL}, L(iD).Ry{iL},'Color',col(iD,:),'Tag','Fixed');
   end
end


%%

switch CONDITION
   case 'Head fixed'
      S.subj_id                                 = ['00' num2str(cdir(fseps(end-1)-1))];
      S.model_parameters                        = MODELPAR;
      S.condition.condition                     = lower(strrep(CONDITION,' ','_'));
      S.condition.preprocessed_data             = Data;
      S.condition.merged_saccade_data           = M;
      S.condition.model_data                    = L;
      
   case 'Head free'
      load([cdir(1:max(fseps)) 'meta_data1.mat']);
      
      S.condition(2).condition                     = lower(strrep(CONDITION,' ','_'));
      S.condition(2).preprocessed_data             = Data;
      S.condition(2).merged_saccade_data           = M;
      S.condition(2).model_data                    = L;
end
      
save([cdir(1:max(fseps)) 'meta_data1.mat'],'S');

