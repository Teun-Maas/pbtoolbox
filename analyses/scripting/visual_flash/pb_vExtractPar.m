function pb_vExtractPar(varargin)
% PB_VPREPDATA
%
% PB_VEXTRACTPAR(varargin) will extract the different parameters for
% dynamic orientation analysis.
%
% See also PB_VSACDET, PB_VPREPDATA, PB_ZIPBLOCKS, PB_CONVERTDATA

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl


   % Keyval
   GV.cdir           = pb_keyval('cd',varargin,cd);
   GV.fs             = pb_keyval('fs',varargin,120);
   GV.acquisition    = pb_keyval('acquisition',varargin,3);  % in seconds
   GV.debug          = pb_keyval('debug',varargin,true);
   GV.colour         = pb_keyval('def',varargin,16);
   
    
   % load data
   cd(GV.cdir);
   l  = dir('preprocessed_data_*');
   if ~isempty(l)
      load(l(1).name,'Data');
   else
      error('No preprocessed_data could be found.');
   end
   
   % Get and store paremeters
   Data = parameterize_data(Data,GV);
   save(strrep(l(1).name,'preprocessed_','parameter_'),'Data');
end

function Data = parameterize_data(Data,GV)
   % This function will parameterize all data. It will read and sort trials
   % and blocks in world fixed and chair fixed stimuli conditions and store
   % stimulus predictor information accordingly.
   
   nsamples    = (GV.fs * GV.acquisition);
   tsEpoch     = (0:nsamples-1)/GV.fs;

   % Read stimuli
   uF    = unique(horzcat(Data.stimuli.frame));       % Chair fixed and World fixed frame
   uD    = unique(horzcat(Data.stimuli.duration));    % stimulus duration
   
   for iF = 1:length(uF)
      % Run over different stimuli frames 
      
      % preallocate parameters
      par = preallocate_par;

      for iB = 1:length(Data.epoch)
         % Run over each block

         % Preallocate
         clear StartAz StartEl ResultAz ResultEl Sac latency sac_dur  % empty block data
         p  = preallocate_par;
         
         % Load saccades
         l = dir('sacdet/sacdet_*_block_*.mat');
         load(['sacdet/' l(iB).name],'-mat','Sac');
              
         % Make the selection
         select_frame = strcmp(Data.stimuli(iB).frame,uF{iF});     % get all trials with the correct frame in the current block
         
         % Select trials with saccades
         sel_trial            = zeros(size(select_frame));        % get all trials with a saccade
         sel_trial(Sac(:,1))  = 1;
         sel_trial            = sel_trial & select_frame;         % merge selection: trials with a saccade and the correct stimulus frame
         trials               = find(sel_trial);                  % find their index number
         trialslen            = length(trials);
         
         % Get stimulus information
         TcA      = Data.stimuli(iB).azimuth(trials);
         TcE      = Data.stimuli(iB).elevation(trials);
         duration = Data.stimuli(iB).duration(trials);
         
         for iT = 1:trialslen
          	% Run over all saccades that are detected to get time indices and positions
            
            current_trial = trials(iT);
            
            trial_idx = find(Sac(:,1)==current_trial);
            
            % Get epoch samplenrs
            start_trial_idx      = (current_trial-1) * nsamples;
            stimOn_idx           = Sac(trial_idx,2) + start_trial_idx;
            SacOn_idx            = Sac(trial_idx,3) + start_trial_idx;
            SacOff_idx           = Sac(trial_idx,4) + start_trial_idx;
            sac_dur(iT)          = (SacOff_idx - SacOn_idx) / GV.fs * 1000; 
            latency(iT)          = Sac(trial_idx,3) / GV.fs * 1000;         % in seconds
            
            % Graph trial
            if GV.debug
               pb_newfig(231);
               clf; 
               title([uF{iF} ' - ' num2str(duration(iT)) ' ms (B' num2str(iB) '/T' num2str(current_trial) ')']);
               hold on;
               axis square;
               
               colour = pb_selectcolor(2,GV.colour);

               plot(tsEpoch, Data.epoch(iB).AzChairEpoched(stimOn_idx:stimOn_idx+359),'color',[0.8,0.8,0.8],'Linewidth',3,'Tag','Fixed');
               plot(tsEpoch, Data.epoch(iB).AzEyeEpoched(stimOn_idx:stimOn_idx+359),'color',colour(1,:),'Linewidth',2,'LineStyle',':','Tag','Fixed');
               plot(tsEpoch, Data.epoch(iB).ElEyeEpoched(stimOn_idx:stimOn_idx+359),'color',colour(2,:),'Linewidth',2,'LineStyle',':','Tag','Fixed');
               plot(tsEpoch, Data.epoch(iB).AzHeadEpoched(stimOn_idx:stimOn_idx+359),'color',colour(1,:),'Linewidth',2,'LineStyle','--','Tag','Fixed');
               plot(tsEpoch, Data.epoch(iB).ElHeadEpoched(stimOn_idx:stimOn_idx+359),'color',colour(2,:),'Linewidth',2,'LineStyle','--','Tag','Fixed');

               plot(tsEpoch, Data.epoch(iB).AzGazeEpoched(stimOn_idx:stimOn_idx+359),'color',colour(1,:),'Linewidth',3,'Tag','Fixed');
               plot(tsEpoch, Data.epoch(iB).ElGazeEpoched(stimOn_idx:stimOn_idx+359),'color',colour(2,:),'Linewidth',3,'Tag','Fixed');
               
               plot(tsEpoch(1), TcA(iT),'o','color',colour(1,:),'MarkerFaceColor',colour(1,:),'Linewidth',1,'MarkerSize',10,'Tag','Fixed');
               plot(tsEpoch(1), TcE(iT),'o','color',colour(2,:),'MarkerFaceColor',colour(2,:),'Linewidth',1,'MarkerSize',10,'Tag','Fixed');

               ylim([-80 80]);
               pb_vline([tsEpoch(Sac(trial_idx,3)), tsEpoch(Sac(trial_idx,4))])
               legend('Chair','Eye Az','Eye El','Head Az','Head El','Chair','Gaze Az','Gaze El','Target Az','Target El')
               pb_nicegraph;
               pause(1)
            end
            
            
            % Saccades on/offset positions
            StartAz(iT)       = Data.epoch(iB).AzGazeEpoched(SacOn_idx);
            StartEl(iT)       = Data.epoch(iB).ElGazeEpoched(SacOn_idx);
            ResultAz(iT)      = Data.epoch(iB).AzGazeEpoched(SacOff_idx);
            ResultEl(iT)      = Data.epoch(iB).ElGazeEpoched(SacOff_idx);

            % Eye
            p.EhStimAz(iT)    = Data.epoch(iB).AzEyeEpoched(stimOn_idx);
            p.EhOnAz(iT)      = Data.epoch(iB).AzEyeEpoched(SacOn_idx);
            p.EhOffAz(iT)     = Data.epoch(iB).AzEyeEpoched(SacOff_idx);  

            p.EhStimEl(iT)    = Data.epoch(iB).ElEyeEpoched(stimOn_idx);
            p.EhOnEl(iT)      = Data.epoch(iB).ElEyeEpoched(SacOn_idx);
            p.EhOffEl(iT)     = Data.epoch(iB).ElEyeEpoched(SacOff_idx);

            % Head
            p.HaStimAz(iT)    = Data.epoch(iB).AzHeadEpoched(stimOn_idx);
            p.HaOnAz(iT)      = Data.epoch(iB).AzHeadEpoched(SacOn_idx);
            p.HaOffAz(iT)     = Data.epoch(iB).AzHeadEpoched(SacOff_idx);

            p.HaStimEl(iT)    = Data.epoch(iB).ElHeadEpoched(stimOn_idx);
            p.HaOnEl(iT)      = Data.epoch(iB).ElHeadEpoched(SacOn_idx);
            p.HaOffEl(iT)     = Data.epoch(iB).ElHeadEpoched(SacOff_idx);

            % Chair
            p.HpStim(iT)      = Data.epoch(iB).AzChairEpoched(stimOn_idx);
            p.HpOn(iT)        = Data.epoch(iB).AzChairEpoched(SacOn_idx);
            p.HpOff(iT)       = Data.epoch(iB).AzChairEpoched(SacOff_idx);  


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
         dCs      = p.HpOn-p.HpStim;
         dCs(2,:) = zeros(size(dCs));

         p.dCs       = dCs;
         p.dHc       = [p.HaOnAz - p.HaStimAz; p.HaOnEl - p.HaStimEl];
         p.dEh       = [p.EhOnAz - p.EhStimAz; p.EhOnEl - p.EhStimEl];
         p.G         = [GazeShiftAz; GazeShiftEl];

         % Target various coordinates
         p.Tc        = [TcA; TcE];                                % Chair coordinates
         p.Tr        = [TcA - p.EhStimAz; TcE - p.EhStimEl];   	% Retinal coordinates
         p.Ts        = [TcA + p.HpStim; TcE];                     % World coordinates
         
         % Stimulus and saccade temporal information
         p.StimDur   = duration;          % stimulus duration
         p.SacLat    = latency;           % saccade latency
         p.SacDur    = sac_dur;           % saccade duration


         par         = append_parameters(par,p);
      end
      
      % Store data for each frame
      par
      Data.frame(iF).parameters  = par;
      Data.frame(iF).frame       = uF{iF};
   end
end

function par = append_parameters(par,p)

   c_fields = fields(p);
   
   for iF = 1:length(c_fields)
      par.(c_fields{iF}) = [par.(c_fields{iF}), p.(c_fields{iF})];
   end
end


function p = preallocate_par
   % this will create empty strict p for the different parameters

   % Chair
   p.HpOn         = [];
   p.HpOff        = [];

   % Head
   p.HaOnAz       = [];
   p.HaOffAz      = [];
   p.EhOnAz       = [];
   p.EhOffAz      = [];

   p.HaOnEl       = [];
   p.HaOffEl      = [];
   p.EhOnEl       = [];
   p.EhOffEl      = [];
   
   % Eye
   p.HpStim       = [];
   p.HaStimEl     = [];
   p.HaStimAz     = [];
   p.EhStimEl     = [];
   p.EhStimAz     = [];
   
   % Saccades
   p.SacLat       = [];    % the reaction time
   p.SacDur       = [];    % the duration of the saccade in ms
   P.Sac          = [];    % in azimuth / elevation
   
   % Stimuli & saccade positions
   p.Tc           = [];    % Chair
   p.Tr           = [];    % Retina
   p.Ts           = [];    % Space
   p.StimDur      = [];    % Stimulus duration
   p.G            = [];
   
   p.dCs          = [];
   p.dHc          = [];
   p.dEh          = [];

   
end
   
