function ORIENT_JJH_04(varargin)
% PB_VGENEXP_VIS
%
% PB_VGENEXP_VIS  will generate an EXP-file for a default localization experiment. 
% EXP-files are used for the psychophysical experiments at the
% Biophysics Department of the Donders Institute for Brain, Cognition and
% Behavior of the Radboud University Nijmegen, the Netherlands.
%
% VESTIBULAR STIMULATION PARAMETERS:
%
% Vestibular signals:      1) none, 
%                          2) sine, 
%                          3) noise, 
%                          4) turn, 
%                          5) step,
%                          6) sum of sines.
%
% Azimuth rotation:        VER
% Elevation rotation:      HOR
%
% See also PB_VWRITEHEADER, PB_VWRITESIGNAL, PB_VWRITETRIAL, PB_VWRITESTIM, etc

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

   % Initiliaze
   pb_clean;
   disp('>> GENERATING VC EXPERIMENT <<');
   disp('   ...')

   % Varargins
   %     General
   GV.cdir                    = pb_keyval('cd',varargin,['/Users/jjheckman/Documents/Data/PhD/Experiment/ORIENT/' mfilename]);                           % Set userpath for exp file storage direcvtory
   GV.open_exp                = pb_keyval('open',varargin,true);                       % Open exp file after generation
   GV.show_targets            = pb_keyval('showtargets',varargin,true);                % Visualize experimental targets
   GV.ext                     = pb_keyval('extension',varargin,'.exp');                % Default .exp, for calibration set to .cal
   GV.expfile                 = pb_keyval('fname',varargin,[get_fn(dbstack) GV.ext]);  % This will read current filename (*.m) as default expfilename
   
   %     Experiment
   GV.exp_datdir              = pb_keyval('datdir',varargin,'');                       % Data dir for Experimenter PC
   GV.exp_ITI                 = pb_keyval('ITI',varargin,[0 0]);                       % ITI, keep at  [0 0]
   GV.exp_ntrials             = pb_keyval('ntrials',varargin,40);                      % Select the number of trails in each block (should be smaller than number of stimuli generated!)
   GV.exp_stimframe           = pb_keyval('stim',varargin,2);                          % Presently we are working with the 2nd frame configuration (only LEDs, see through)
   GV.exp_lab                 = pb_keyval('lab',varargin,1);                           % The VC lab is default lab choice (set 1)
   GV.exp_trialduration       = pb_keyval('trialdur',varargin,0);                      % Select max trial duration, if 0 is chosen there is no max trial duration (use with button presses).
   
   %     Stimuli
   GV.stim_repeats            = pb_keyval('repeats',varargin,2);                       % Keep at 1 or it wil repeat stimuli n times.
   GV.stim_duration           = pb_keyval('duration',varargin,[0.5 1 2 4 10 20]);      % Select the duration you want to present with. For multiple inset array (ex. [0.5 1 2 4 16]).
   GV.stim_intensity        	= pb_keyval('intensity',varargin,50);                    % Select the intensity (range). If you want to randomnise the the intensity set range limits (ex. [40 50]).
   GV.stim_onsetdelay        	= pb_keyval('onsetdelay',varargin,[150 350]);            % Select onset delay (range). Pick single number for fixed onset delay, for random range set limits (ex. [1000 1250])
   GV.stim_randomise          = pb_keyval('random',varargin,true);                     % If you want to randomise the order of the stimuli (and you typically should!) set to true.
   GV.stim_ratiochair2world 	= pb_keyval('chair2world',varargin,[1 1]);               % Amount of chair fixed vs world fixed targets
   GV.stim_excludecentre    	= pb_keyval('cutoff',varargin, 0);                       % Select the middle range (+- degrees) that you would like to exclude from target selection (if none, set to 0).
   GV.stim_trigger_on         = pb_keyval('trig_on',varargin,0);                       % Onset trigger, typically 0.
   GV.stim_trigger_off        = pb_keyval('trig_off',varargin,0);                      % Offset trigger, typically 0 (unless you want to use button presses or so..)
   GV.stim_fixlight        	= pb_keyval('fix_light',varargin,0);                     % If you want a fixation light
   GV.stim_fixdur             = pb_keyval('fix_dur',varargin,1000);                    % fixation light duration in ms
   
   %     Vestibular profile                                                            % typically only use vertical axis
   GV.vc_profile              = pb_keyval('vc_profile',varargin,[2 1]);                % Select the profile 1-6. [HOR/VERT]
   GV.vc_amplitude            = pb_keyval('vc_amplitude',varargin,[40 0]);              % Select the maximum amplitude. [HOR/VERT]
   GV.vc_duration             = pb_keyval('vc_duration',varargin,200);                   % Duration (max duration of profile is 200s)
   GV.vc_frequency            = pb_keyval('vc_frequency',varargin,0.11);               % Frequency (max) of the vestibular noise / sinewave

   
   % Build experiment
   T     = get_targets(GV);
   S     = get_stimuli(T,GV);
   EXP   = parse_exp(S,GV);
   
   % Write experiment
   c_expfiles = write_exp(EXP,GV);
   open_exp(c_expfiles,GV);
end


% Helper functions
function EXP = parse_exp(S,GV)
   % This function will parse stimuli over different blocks and add
   % vestibular signal to each block.

   nblocks = floor(length(S.X)/GV.exp_ntrials);    % compute number of blocks

   for iB = 1:nblocks
      % divbide stimuli over blocks
      
      idc = ((iB-1) * GV.exp_ntrials) +1 : (iB * GV.exp_ntrials);     % select current stimuli idc
      
      % split stimuli
      EXP.block(iB).Stim.X       = S.X(idc);
      EXP.block(iB).Stim.Y       = S.Y(idc);
      EXP.block(iB).Stim.dur     = S.dur(idc);
      
      % inset other parameters
      if length(GV.stim_intensity) == 1
         int    	= GV.stim_intensity * ones(size(idc')); 
      elseif length(GV.stim_intensity) == 2
         int   	= randi(GV.stim_intensity,size(idc'));
      end
      
      
      if length(GV.stim_onsetdelay) == 1
         onset  	= GV.stim_onsetdelay * ones(size(idc')); 
      elseif length(GV.stim_onsetdelay) == 2
         onset   	= randi(GV.stim_onsetdelay,size(idc'));
      end
      
      EXP.block(iB).Stim.int     = int;
      EXP.block(iB).Stim.onset   = onset;
      EXP.block(iB).Stim.offset  = EXP.block(iB).Stim.onset + EXP.block(iB).Stim.dur;
      
      EXP.block(iB).Horizontal   = struct('Amplitude', GV.vc_amplitude(1),  'Signal', GV.vc_profile(1), 'Duration', GV.vc_duration, 'Frequency', GV.vc_frequency);
      EXP.block(iB).Vertical     = struct('Amplitude', GV.vc_amplitude(2), 'Signal', GV.vc_profile(2), 'Duration', GV.vc_duration, 'Frequency', GV.vc_frequency);
   end
end


function S = get_stimuli(T,GV)
   % This function will prep all stimuli * durations

   % Make stim grid
   [X,Y]          = make_stims(T,GV);
   dur            = GV.stim_duration;
   [X,~,~]      	= ndgrid(X,0,dur);
   [Y,~,dur]     	= ndgrid(Y,0,dur);
   
   % Vectors
   X              = X(:);
   Y              = Y(:);
   dur            = dur(:);
   
   % Repeat
   S.X     = repmat(X,[GV.stim_repeats 1]);
   S.Y     = repmat(Y,[GV.stim_repeats 1]);
   S.dur   = repmat(dur,[GV.stim_repeats 1]);
   
   if GV.stim_randomise   % shuffle targets
      rperm    = randperm(length(S.X));   % random key
      
      % shuffle
      S.X      = S.X(rperm);
      S.Y      = S.Y(rperm);
      S.dur   	= S.dur(rperm);
   end
end

function [X,Y] = make_stims(T,GV)
   % this function will select the target positions and correct them for the
   % relative ratio of presenting them (world vs chair fixed targets)
    
   world_fixed    = T(:,1) == 90;   % azimuth check, 90 is world fixed
   X              = [repmat(T(~world_fixed,1), GV.stim_ratiochair2world(1),1); ...
                     repmat(T(world_fixed,1),  GV.stim_ratiochair2world(2),1)];      
                  
   Y              = [repmat(T(~world_fixed,2), GV.stim_ratiochair2world(1),1); ...
                     repmat(T(world_fixed,2),  GV.stim_ratiochair2world(2),1)];
end


function T = get_targets(GV)
   % This function  will obtain all targets from cfg, and remove targets
   % too close to elevation = 0.

   % Get targets
   cfg			= pb_vLookup;                  % lookup target positions
   L        	= cfg.lookup;
   cut_off     = GV.stim_excludecentre;
   ntargets    = sum((abs(L(:,5))>=cut_off));
   T           = zeros(ntargets,2);          % create empty list of targets

   if GV.show_targets
      % Graph the target positions
      
      % Read lookup table
      frame    = unique(L(:,2));
      framel   = length(frame);
         
      c_title = {'Frame I','Frame II'};   
      pb_newfig(999);
      
      for iF = 1:framel
         % Run for each stimulus frame
         
         % plot different frame in subplots
         subplot(1,framel,iF);
         title(c_title{iF});
         hold on;
         axis square;
         
         % Select frame
         selF  = frame(iF) == L(:,2); 
         x     = L(selF,4);
         y     = L(selF,5);
         
         % Select targets
         selS = abs(y) >= cut_off;
         dAz   = x(selS);
         dEl   = y(selS);

         % Plot
         plot(x,y,'o');
         plot(dAz,dEl,'x');
         
         % Make nice
         pb_hline([-cut_off,cut_off]);
         ylabel('Elevtion');
         ylim([-50 50]);
         if iF<framel
            xlabel('Azimuth');
            xlim([-50 50]);
         else
            f = gca;
            f.XTickLabel = {};
         end
         
         % Store targets
         if iF == 1
            idx1 = 1; 
            idx2 = length(dAz);
         else
            idx1 = idx2+1; 
            idx2 = ntargets;
         end

         T(idx1:idx2,1)    = dAz;
         T(idx1:idx2,2)    = dEl;
      end
      
      pb_nicegraph;
   end
end


function c_expfiles = write_exp(EXP, GV)
   % write the experimental data in expfile.
   
   cd(GV.cdir);
   
   % preallocate
   c_expfiles = {};

   % Make expfile for each block
   for iB = 1:length(EXP.block)
      
      % Make expfilenames
      [ext, prefix]    = pb_fext(GV.expfile);
      c_expfiles{iB}   = [prefix '_b' num2str(iB) ext];
      
      % Build expfile
      fid = fopen(c_expfiles{iB},'wt+');
      
      % Write header
      pb_vWriteHeader(fid,1,GV.exp_ntrials,GV);
      
      % Write vestibular signal
      pb_vWriteBlock(fid, 1)
      pb_vWriteSignal(fid,EXP.block(iB))
      
      % Write trials
      for iT = 1:GV.exp_ntrials
         


         % Make visual stimulus object
         VIS.LED        = 'LED';
         VIS.X          = EXP.block(iB).Stim.X(iT);
         VIS.Y          = EXP.block(iB).Stim.Y(iT);  
         VIS.Int        = EXP.block(iB).Stim.int(iT);
         VIS.EventOn    = GV.stim_trigger_on;
         VIS.EventOff   = GV.stim_trigger_off;
         VIS.Onset      = EXP.block(iB).Stim.onset(iT);
         VIS.Offset     = EXP.block(iB).Stim.offset(iT);
         
         % Write trial and stimuli
         pb_vWriteTrial(fid, iT);
         if GV.stim_fixlight
            
            pb_vWriteFixLight(fid,GV.stim_fixdur); 
            VIS.Onset      = VIS.Onset + GV.stim_fixdur;
            VIS.Offset     = VIS.Offset + GV.stim_fixdur;
         end
         pb_vWriteStim(fid, 2, [],VIS);
      end
      
      % Write 
      fclose(fid);
   end
end

function open_exp(c_expfiles,GV)
   % This function will open all created expfiles as a check
   
   if GV.open_exp    % default is true

      % Read all expfiles
      for iE = 1:length(c_expfiles)

         fn    = c_expfiles{iE};

         % Open expfile with editor
         if ismac
            system(['open -a BBEdit ' cd filesep fn]);
         elseif ispc
            dos(['"C:\Program Files\Windows NT\Accessories\wordpad.exe" ' fn ' &']);
         end
      end
   end
end

function fn = get_fn(st)
   % Get filename from stack
   
   % Read stack
   sname    = st.name;                 % get fn
   fn       = strrep(sname,'pb_','');  % remove 'pb_'
end

