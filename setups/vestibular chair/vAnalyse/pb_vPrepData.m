function Data = pb_vPrepData(varargin)
% PB_VPREPDATA
%
% PB_VPREPDATA(varargin) will preprocess the raw converted data extracted
%
% See also PB_ZIPBLOCKS, PB_CONVERTDATA

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl
   

   % Load data, read GV, and clean data
   GV             = parse_keyval(varargin{:});                             % Pass along the varargin and store keyvalues in a 'global' variable
   [D,GV]         = load_data(GV);                                         % Will load the data
   [D,GV]         = calibrate_data(D,GV);                                  % Calibrate data
   GV             = read_keyval(D,GV);                                     % Correct any keyval
   
   % Parse data
   S              = getstims(D, GV);                                    	% read the stimuli
   T              = gettimestamps(D, GV);                                 	% synchronize the LSL timestamps
   
   % <--- UP UNTILL HERE: RUNS SMOOTHLY / NO ERRORS
   % <--- UP UNTILL HERE: CLEANED & COMMENTED
   
   [P,GV]	= getdata(D, T, GV);                                           % obtain the response behaviour
   [T,P]    = getchair(D, T, P, GV);                                       % add chair rotation
   Data     = pb_struct({'stimuli','timestamps','position'},{S,T,P});
   
   % store data
   if GV.epoch_data; Data = epoch_data(Data, GV); end                      % epoch data
   if GV.gen_storedata; save_data(Data,GV); end                            % store data
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


% ---


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%           General loading and meta functions              %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


function GV = parse_keyval(varargin)
% This function will read and set all optional/default parameters that
% will be passed along the functions.
 
   V = varargin;           % Improve readability
   
   % General parse
   GV.gen_cdir             = pb_keyval('cd', V, cd);                       % Directory where block data can be found
   GV.gen_path             = pb_keyval('path', V, [cd filesep '..']);      % Provide full path of converted data
   GV.gen_fn               = pb_keyval('fn', V);                           % Enter filename of the converted data
   GV.gen_blockidx         = pb_keyval('block', V, 'all');                 % Number of blocks to analyse, can be any double (array) or 'all'
   GV.gen_debug            = pb_keyval('gen_debug', V, true);              % Select true when debugging, it will provide some more figures and stops along the way.
   GV.gen_storedata        = pb_keyval('store', V, true);                  % If you want to store (and overwrite) data; select true.
   GV.gen_cfn              = pb_keyval('cfn', V, 231);                     % Set initial count current figure number
   
   % Calibration parse
   GV.cal_debug            = pb_keyval('cal_debug',V,true);                
   GV.cal_storefig         = pb_keyval('cal_savefig',V,true);              % If you want to store (and overwrite (it will check and ask)) calibration data; select true.
   GV.cal_loadfromfig      = pb_keyval('cal_loadfig',V,true);            	% Run calibration from latest calibration figure
   GV.cal_editload         = pb_keyval('cal_editfig',V,true);            	% Will allow you to update ROI in loaded cal figure
   GV.cal_reptrain         = pb_keyval('cal_reptrain',V,10);               % Amount of repeated trainings
   GV.cal_retrain          = pb_keyval('retrain',V,false);                  % Retraint the neural network
   GV.cal_fn               = pb_keyval('cal_fn',V,['cal_figure_' GV.gen_fn(16:end-4) '.fig']); % This will give you the filename of calration figure.
   GV.cal_nethidden        = pb_keyval('cal_hidden',V,2);                  % Number of hidden units in network
   
   % Stimulus parse
   GV.stim_targetidx       = pb_keyval('stim', V, 1);                      % Select the stimulus of interest index.
   GV.stim_frames          = pb_keyval('frames', V, true);                 % This will correct stimulus azimuth for 
   
   % Filters parse
   GV.filter_heuristic   	= pb_keyval('heuristic_filter', V, true);       % Heuristic filter for spike removal
   GV.filter_butter       	= pb_keyval('butter_filter', V, true);          % No-phase shift 'Lowpass' butterworth filter, Fc = >74 Hz (see Bahill et al, 1982)
   GV.filter_sgolay      	= pb_keyval('sgolay_filter', V, false);         % this will take the savinski golay filter, very comon in eye research
   GV.filter_median      	= pb_keyval('median_filter', V, false);         % takes the median filter the cut out noise.
   
   % Gaze parse
   GV.gaze_method          = pb_keyval('gaze', V, 'old');                  % How to compute gaze (G=E+H)? check out functions for different methods
   GV.gaze_fs              = pb_keyval('fs', V, 200);                      % Refers to pl sampling rate, other data will be upsampled to be matched
   
   % Epoch parse
   GV.epoch_data           = pb_keyval('epoch', V, 1);                     % Store epoche data in chuncks for trial by trial analysis
   GV.epoch_acqduration    = pb_keyval('acquisition', V, 3);               % Trial acquisition duration
   
   % Update user
   disp(['>> Data Preprocessing has started...' newline]);
   disp(['   >> Global variables and defaults are read.' newline]);
end


function [D,GV] = load_data(GV)
% This function will load the converted data file, from file path. If no
% file can be found it wil prompt you to locate the file manually.

   cd(GV.gen_path);                                                        % Go to select directory
   if exist(GV.gen_fn,'file')==2
      load(GV.gen_fn);                                                     % Load data when filename is given
   else
      [path, prefix, fname, ext] = get_fname(GV);                         	% Otherwise, Get fileparts
      if ~path                                                             % Assert if path exists
         disp('>> pb_vPrepData aborted as no file was selected.');
         return
      else
         GV.gen_fn = [prefix fname ext];
         load([path GV.gen_fn],'D');                                       % Load data from prompt
      end
   end
   disp(['>> Data loaded...' newline]);
end


function [path, prefix, fname, ext] = get_fname(GV)
   % Function selects data filename
   
   % Select dir
   [fname, path]  = pb_getfile('cd',[GV.gen_cdir filesep '..'],'ext','converted_data_.mat');    % Open the converted data
   
   if ~isa(fname,'char')                                                   % If it doesn't exist; give an error
      prefix   = false; %#ok
      ext      = false; %#ok
      error('No file was found.');                       
   end
   
   % Store fileparts
   [ext, fname]   = pb_fext(fname);
   prefix         = fname(1:15);                                           % Select prefix: 'converted_data_'
   fname          = fname(16:end);                                         % Final filename (skips over prefix)
end


function GV = read_keyval(Data,GV)
   % Read and correct keyvals parameters that are dependent on 'Data' (i.e. conversion from string to some parameter of the data)
   
   % Fix block numbers
   if ~isnumeric(GV.gen_blockidx)
      switch GV.gen_blockidx                                               % When all is selected, determine length of blocks and make array of blocks
         case 'all'
            GV.gen_blockidx = 1:length(Data);                              % Select all data block idc
         otherwise                                                         % If other non numeric, set block to 1 and only analyse first block
            GV.gen_blockidx = 1;                                           % Default idx
      end
   end
end


function save_data(Data, GV)
   % The function will store the preprocessed data with the according fn

   fn       = strrep(GV.gen_fn,'converted_data_','');                      % Get filename
   fpath    = fullfile(cd);                                                % Go to directory
   
   save([fpath filesep 'preprocessed_data_' fn],'Data')                    % Store data
end


% ---


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%                    Calibration functions                  %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


function [Data,GV] = calibrate_data(Data,GV)
% This function will load the calibration figure, map input and output data
% and train the network. Actuall transformtion/mapping to model will be
% done later in map_eyes2azel (e.g. azel = map_eyes2azel(block_data)).

   % Assert calibration field in data
   if ~isfield(Data,'Calibration'); error('No Calibration data was found.');  end
   
   % Load or map
   if any(exist([cd filesep GV.cal_fn],'file')) && GV.cal_loadfromfig      % Only load figure if figure exists and loadfromfig is true.
      [Data,GV]      = load_calibration_figure(Data,GV);                  	% Load calibration, optionally you can adjust mapping
   else
      [Data,GV]   	= map_calibration_data(Data,GV);                   	% Build new figure, select X,T mappings for NN (Y = M(mean(X_T),unique(T))
   end
   
   % Train the data
   [Data,GV]         = train_calibration(Data, GV);                      	% Train calibration network based on the mapping
end


function [Data,GV]  = load_calibration_figure(Data,GV)  
% This function  will load the calobration figure and allow you to change
% mappings if necessary.
   
   % Load and assert
   h  = openfig([cd filesep GV.cal_fn]);                                   % Load figure
   if isempty(h); error('No Calibration figure was found'); end            % Assert
   disp('>> Calibration_Figure opened.');                                     % Update User
   
   % Get data
   UD    = h.UserData;                                                     % Load UserData
   col   = pb_selectcolor(2,2);                                            % Select colors
   
   % Update figure to first trial
   xlim(UD.trial_times(1,:));                                              % Set window trial 1
   title('Trial 1');                                                       % Set trial 1
   
   % Set targets
   h.UserData.current_target(1) = pb_hline(UD.T(1,1),'color',col(1,:));    % Set azimuth target
   h.UserData.current_target(2) = pb_hline(UD.T(1,2),'color',col(2,:));    % Set elevation target

   % Prompt user to include ROI
   answer = questdlg('Would you to adjust calibration figure?', ...
                     'Adjust calibration', ...
                     'Yes','No, thank you','No, thank you');
                  
   % Check answer 
   switch answer
      
      % If user selects: "Yes"
      case 'Yes'
         
         % Display
         disp('Edit Calibration_Figure with keyPressFcn. Close figure handle to proceed.');
         
         % Hold code
         h.UserData.figure_changed  = true;                                % allow figure to be saved if closed
         while size(findobj(h(1)))>0                                       % Is handle still available? When figure is closed loop will break.      
            pause(.1)                                                      % Wait
         end
              
      % If user selects: "No, thank you"
      case 'No, thank you'
         % Do nothing.
   end
end

function [Data,GV] = map_calibration_data(Data,GV)
% This function will build new figure and map the data

   % Globals
   Cal      = Data(1).Calibration.Data;
   if isempty(Cal); error('No calibtration data was found.'); end          % Check if data exists

   % Build figure for detection of ROI
   [UD,h,ax]         = build_calfigure(Cal,GV);                            % Make calibration figure
   ntargets          = length(Cal.block_info.trial);                       % Trial count
   col               = pb_selectcolor(2,2);                                % Color format
   
   % Get pupil
   ts_pup            = UD.pupil_ts;                                        % get synched timestamps
   PL                = get_pupil_data(Cal.pupil_labs.Data);                % Get pupil data from calibration
   
   % Fill in data (X) and target mapping (T)
   for iT = 1:ntargets
      % For each trial find target / response values for mapping
      
      % Get trial info
      trial_info  = Cal.block_info.trial(iT).stim(2);                      % Second stimulus is the target during calibration
      target      = [trial_info.azimuth, -trial_info.elevation];           % Select target positions
      
      % Update figure
      xlim(UD.trial_times(iT,:));                                          % Update trial window
      title(['Trial ' num2str(iT)]);                                       % Update trial
      
      for iD = 1:2
         pb_hline(target(iD),'visibility','on','color',col(iD,:));         % Show targets with 
      end
      
      % Prompt user to include ROI
      answer = questdlg('Would you to select like a stationary ROI?', ...
                        ['Trial ' num2str(iT)], ...
                        'Yes','No thank you','No thank you');
      % Handle response
      switch answer
         case 'Yes'
            
            % Select on- and offset for ROI
            [x,~] = ginput(2);                                             % Get patched ROI info
            pb_delete;                                                     % Remove azimuth target line
            pb_delete;                                                     % Remove elevtion target line
             
            % Patch region of interest
            t1                = x(1);
            t2                = x(2);
            range             = find(ts_pup>=t1,1):find(ts_pup>=t2,1);
            x                 = [t1 t2 t2 t1];
            y                 = [min(ax.YLim) min(ax.YLim) max(ax.YLim) max(ax.YLim)];
            UD.patch_h(iT)    = patch(x,y,'g','FaceAlpha',0.3);
             
            % Get pupil unit vectors
            lxyz     = [median(PL.gaze_normal1_x(range)), median(PL.gaze_normal1_y(range)), median(PL.gaze_normal1_z(range))];
            rxyz     = [median(PL.gaze_normal0_x(range)), median(PL.gaze_normal0_y(range)), median(PL.gaze_normal0_z(range))];
            
            % Compute both eye spherical coordinates
            laz      = atand(lxyz(1)/lxyz(3));                             % Left Azimuth
            lel      = atand(lxyz(2)/sqrt(lxyz(1)^2+lxyz(3)^2));           % Left Elevation
            raz      = atand(rxyz(1)/rxyz(3));                             % Right Azimuth
            rel      = atand(rxyz(2)/sqrt(rxyz(1)^2+rxyz(3)^2));           % Right elevation

            % Write target / response mapping
            UD.T(iT,:)  = target;                                          % Target (Az,El)
            UD.X(iT,:)  = [raz,rel,laz,lel];                               % Input to the network (Raz,Rel,Laz,Lel)

          case 'No thank you'
             UD.discard(iT) = true;                                        % Trial is not used
             % Do nothing
      end
   end
   
   % Save UserData in figure
   h.UserData = UD;                                                        % Store UserData
   save_cal_fig(h,GV);                                                     % Store figure
end


function [Data,GV] = train_calibration(Data, GV)
% This will train neural network to map pupillabs norm position to real
% world azimuth/elevation values.

   % Get initial Data
   Cal         = Data(1).Calibration.Data;
   train_fn    = strrep(GV.cal_fn,'cal_','training_');
   
   % Assert
   if isempty(Cal); error('No calibtration data was found.'); end          % Check if data exists
   if ~exist(train_fn,'file') || GV.cal_retrain
      
      % Get Calibration_Figure
      g = groot;                                                         	% Get all graphic objects                                                       
      h = pb_fobj(g,'Name','Calibration_Figure');                         	% Find calibration figure
      if isempty(h); h = openfig([cd filesep GV.cal_fn]); end              % If it doesn't exist open it

      % Get UserData
      UD = h.UserData;

      % Collect data
      pl          = Cal.pupil_labs.Data;                                  	% PL data
      [Raz,Rel]   = pupil_xyz2azel(pl(13,:),pl(14,:),pl(15,:));           	% Right eye (x/y/z_0)
      [Laz,Lel]   = pupil_xyz2azel(pl(16,:),pl(17,:),pl(18,:));          	% Left eye (x/y/z_1)

      ts_pl       = lsl_correct_lsl_timestamps(Cal.pupil_labs);          	% PL timestamps
      ts_eo       = lsl_correct_lsl_timestamps(Cal.event_out);           	% EO timestamps
      ts_pl       = ts_pl-ts_eo(1);                                      	% Synch data
      ts_eo       = ts_eo-ts_eo(1);                                       	% Synch data
      ts_target   = ts_eo(3:4:end);                                       	% Pick every 3rd trigger as target onset times

      % Compute Unique/Mean mappings
      uniqueT           = unique(UD.T(~isnan(UD.T(:,1)),:),'rows');     	% Find all unique 2D target location (out of 3x15 = 45 stimuli)
      meanX             = nan(size(uniqueT,1),4);

      % Select data
      for iU = 1:size(meanX,1)

         same_T_idx  	= find(UD.T==uniqueT(iU,:));
         same_T_idx     = same_T_idx(same_T_idx<=45);
         ncopies        = length(same_T_idx);
         azel           = nan(ncopies,4);

         % If you want to only train each target once                         
         for iC = 1:ncopies
            azel(iC,:) = UD.X(same_T_idx(iC),:);                          	% Looks like training is better with more data
         end

         azel           = UD.X(same_T_idx,:);
         meanX(iU,:)    = nanmean(azel,1);
      end

      % Normalize and transpose (ALL)
      norm_X            = transpose(UD.X ./ UD.scaler);                 	% Use this one
      norm_T            = transpose(UD.T ./ UD.scaler);                    % Use this one

      % Train network
      NN             = struct('net',[]);
      mse_test       = nan(1,GV.cal_reptrain+1);
      r_test         = nan(1,GV.cal_reptrain+1);
      std_test       = nan(1,GV.cal_reptrain+1);

      % Update training paramaters
      UD.net.trainFcn = 'trainbr';
      UD.net.trainParam.showWindow        = false;
      UD.net.trainParam.showCommandLine   = false;
      UD.net.layers{1}.dimensions        = GV.cal_nethidden;
      
      start_time     = tic;                                                % Start counting training time

      % Repeat training
      for iR  = 1:GV.cal_reptrain+1
         
         % Trian network
         NN(iR).net     = train(UD.net,norm_X,norm_T);                     % Note the orientation for neural network inputs/outputs (i.e. 4xN) 

         % Azel
         nazel    	= [Raz; Rel; Laz; Lel] ./ UD.scaler;                	% Normalized data
         nazel_    	= sim(NN(iR).net, nazel);                            	% Normalized transformed data
         azel_     	= nazel_ .* UD.scaler;                                % Unnormalize data
         az       	= pb_naninterp(azel_(1,:));                           % Fill in NaNs
         el       	= pb_naninterp(azel_(2,:));                           % Fill in NaNs
         
         % Compute noise level
         azF       	= highpass(az,'Fc',40,'Fs',200);                      % Filter most of the normal frequency content of eye data away
         elF        	= highpass(el,'Fc',40,'Fs',200);                      % Filter most of the normal frequency content of eye data away
         std_test(iR)   = mean([std(azF) std(elF)]);                     	% Get noise

         % Preallocate
         az_resp    	= nan(1,length(Cal.block_info.trial));                % Empty variable
         el_resp     = az_resp;                                            % Empty variable
         az_target   = az_resp;                                            % Empty variable
         el_target   = az_resp;                                            % Empty variable

         % Run over trials
         for iT = 1:length(Cal.block_info.trial)
            pup_start_idx  = find(ts_pl>ts_target(iT),1);                	% Find target onset
            range          = pup_start_idx+150 : pup_start_idx+190;      	% 750-960ms after stimulus presentation

            az_resp(iT)    = nanmedian(az(range));                         % Find the eye position in azimuth
            el_resp(iT)  	= nanmedian(el(range));                         % Find the eye position in elevation

            az_target(iT)  = Cal.block_info.trial(iT).stim(2).azimuth;     % Read target azimuth
            el_target(iT)  = -Cal.block_info.trial(iT).stim(2).elevation;  % Read target elevation
         end

         % Compute test performance
         T              = [az_target; el_target];                          % Targets
         Y              = [az_resp; el_resp];                              % Predicted locations
         mse_test(iR)   = perform(NN(iR).net,Y./50,T./50);                 % Compute performance over normalized predicted and target data

         % Regression
         b           = regstats(Y(:)',T(:)','linear','beta');              % Compute R correlation
         b           = b.beta;                                             % Rergression stats
         r_test(iR)	= b(2);                                               % The r or gain

         if b(2)>1; r_test(iR) = inv(b(2)); end                            % Flip R to a max gain of 1
      end
      
      % Finish training
      toc(start_time);                                                     % Stop training clock
      disp('Network training complete.');                                  % Update User

      % Score networks
      MF             = pb_rank(mse_test, 'ascend');                        % MSE
      RF             = pb_rank(r_test, 'descend');                         % R
      NF             = pb_rank(std_test, 'ascend');                        % Standard deviation
      rank           = [RF;NF;MF];                                         % Combine ranks
      score          = sum(rank);                                          % Compute final score
      
      % Select best network
      [~,best_idx]   = min(score);                                         % Find best index (smallest combined score)
      UD.net         = NN(best_idx).net;                                   % Identify and store best trained network

      % Create user data and store in figure
      show_calibration_training(Data,norm_X,norm_T,UD,GV);                 % Build calibration training figure
      set(gcf,'UserData',UD.net);                                          % Store network in figure
      
      
   elseif exist(train_fn,'file') 
      % Incase you already have trained network in Network_Figure 
      
      % Load all the figures
      map_handle     = pb_fobj(groot,'Name','Calibration_Figure');
      train_handle   = openfig([cd filesep train_fn]);
      
      % Overwrite network in UserData
      UD             = map_handle.UserData;                                % Get UserData
      UD.net         = train_handle.UserData;                              % Overwrite network
   end
   
   
   for iB = 1:size(Data)
   %  Run over all blocks
   
      % Store Calibration in Data
      Data(iB).Calibration.figure_data   	= UD;                            % Write UserData
      Data(iB).Calibration.net          	= UD.net;                        % Store trained neural network
      Data(iB).Calibration.scaler         = UD.scaler;                     % Store scaler, note this should always be 50
   end
end

function show_calibration_training(Data,X,T,UD,GV)
% This functioin will built calibration figure

   % Get data
   net         = UD.net;                                                   % Network
   Cal         = Data(1).Calibration.Data;
   pl          = Cal.pupil_labs.Data;                                      % PL data
   ts_pl       = lsl_correct_lsl_timestamps(Cal.pupil_labs);               % PL timestamps
   ts_eo       = lsl_correct_lsl_timestamps(Cal.event_out);                % EO timestamps
   ts_pl       = ts_pl-ts_eo(1);                                           % Synch data
   ts_eo       = ts_eo-ts_eo(1);                                           % Synch data
   ts_target   = ts_eo(3:4:end);                                           % Pick every 3rd trigger as target onset times
  
   col_def     = 16;
   col         = pb_selectcolor(2,col_def);
   
   [Raz,Rel]   = pupil_xyz2azel(pl(13,:),pl(14,:),pl(15,:));               % Right eye (x/y/z_0)
   [Laz,Lel]   = pupil_xyz2azel(pl(16,:),pl(17,:),pl(18,:));               % Left eye (x/y/z_1)

   % Azel plot
   nazel       = [Raz; Rel; Laz; Lel] ./ UD.scaler;                        % Normalized data
   nazel_      = sim(net, nazel);                                          % Normalized transformed data
   azel_       = nazel_ .* UD.scaler;                                      % Unnormalized transformed data (Azimuth & Elevation)
   
   % Get unique targets
   for iS = 1:length(Data(1).Calibration.Data.block_info.trial)
      target(iS,1)      = Data(1).Calibration.Data.block_info.trial(iS).stim(2).azimuth;        %#ok
      target(iS,2)      = -Data(1).Calibration.Data.block_info.trial(iS).stim(2).elevation;     %#ok
   end
   target               = unique(target,'rows');
      
   % Error bin plot
   Y                    = UD.net(X);
   diff_YT              = (Y-T)*UD.scaler;
   dAz                  = diff_YT(1,:);
   dEl                  = diff_YT(2,:);
   number_bins          = 4;
   step                 = 1/number_bins;
   
   % Azimuth
   [az_height, edges]   = histcounts(dAz, number_bins);
   az_loc               = movmean(edges, 2, 'Endpoints', 'discard');
   az_nheight           = az_height/sum(az_height)*100;
   az_loc               = [-3, az_loc(1)-step, az_loc, az_loc(end)+step, 3];
   az_nheight           = [0 0 az_nheight 0 0];
   
   % Elevation
   [el_height, edges]   = histcounts(dEl, number_bins);
   el_loc               = movmean(edges, 2, 'Endpoints', 'discard');
   el_nheight           = el_height/sum(el_height)*100;
   el_loc               = [-3, el_loc(1)-step, el_loc, el_loc(end)+step, 3];
   el_nheight           = [0 0 el_nheight 0 0];

   % MSE
   perf  = mse(net,T,Y);
   perf  = perf*UD.scaler; 
   
   % Collect data
   pl          = Cal.pupil_labs.Data;                                   	% PL data
   [Raz,Rel]   = pupil_xyz2azel(pl(13,:),pl(14,:),pl(15,:));               % Right eye (x/y/z_0)
   [Laz,Lel]   = pupil_xyz2azel(pl(16,:),pl(17,:),pl(18,:));         
   
   % Azel
   nazel    	= [Raz; Rel; Laz; Lel] ./ UD.scaler;                        % Normalized data
   nazel_    	= sim(net, nazel);                                          % Normalized transformed data
   azel_     	= nazel_ .* UD.scaler;                                      % Unnormalize data
   az       	= pb_naninterp(azel_(1,:));                                 % Fill in NaNs
   el       	= pb_naninterp(azel_(2,:));                                 % Fill in NaNs
         
   
   stepsz      = 1;
   window      = 1;
   nazel       = [nanmean(nazel([1 3],:)); nanmean(nazel([2 4],:))];
   nazel       = [movmedian(nazel(1,:),window); movmedian(nazel(2,:),window)];
   nazel       = nazel*UD.scaler;
   nazel       = nazel(:,1:stepsz:end);
   azel        = [movmedian(azel_(1,:),window); movmedian(azel_(2,:),window)];
   azel        = azel(:,1:stepsz:end);
   
   y           = transpose(azel(:));
   x           = transpose(nazel(:));
   
   % 1. Plot the XY data
   [GV.gen_cfn,fig_handle]    = pb_newfig(GV.gen_cfn);
   fig_handle.Name            = 'Network_Figure';
   fig_handle.UserData        = net;
   subject                    = GV.gen_fn(20:23);
   
   sgtitle(['Network training summary (S' subject ')'],'FontSize',20);
   
   subplot(231); 
   title('World calibrated traces');
   hold on; 
   axis square;
   plot(azel_(1,:),azel_(2,:),'.','Linewidth',0.5,'MarkerSize',0.5);
   scatter(UD.T(:,1),UD.T(:,2),350,'MarkerFaceColor',col(1,:),'MarkerFaceAlpha',0.1,'Tag','Fixed');
   
   % Determine noise
   az_F           = lowpass(pb_naninterp(azel_(1,:)),'Fc',30,'Fs',200);
   el_F         	= lowpass(pb_naninterp(azel_(2,:)),'Fc',30,'Fs',200);
   
   for iT = 1:length(ts_target)
      pup_start_idx  = find(ts_pl>ts_target(iT),1);                        % Find target onset
      range          = pup_start_idx+150 : pup_start_idx+190;              % 750-950ms after stimulus presentation
   
      % Get median
      az          = nanmedian(az_F(range));
      el          = nanmedian(el_F(range));
      
      % Plot endpoints
      plot(az,el,'xk','MarkerSize',20,'Tag','Fixed')
   end

   
   for iT = 1:length(target)
      scatter(target(iT,1),target(iT,2),350,'ok','Tag','Fixed');
   end
      
   ylim([-50 50]);
   xlim([-50 50]);   
   xlabel('Azimuth ($^{\circ}$)');   
   ylabel('Elevation ($^{\circ}$)');

   

   % 2. Plot regression
   subplot(232); 
   hold on; 
   axis square;
   alpha = 0.01;
   %scatter(x,y,10*ones(size(x)),'MarkerFaceColor','c','MarkerEdgeColor','c','Tag','Fixed','MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',alpha);
   [h,b,r] = pb_regplot(T*UD.scaler,Y*UD.scaler,'color',[0    0.7    1]);
   xlim([-50 50]);
   ylim([-50 50]);
   title(['Regression (R=' num2str(round(r,5)) ')']);
   ylabel(['Output = ' num2str(round(r,2)) '*Target+' num2str(round(b,5)) ' ($^{\circ}$)']);
   xlabel('Target ($^{\circ}$)');

   % Adjust regression line handles
   for iH = 1:length(h)
      h(iH).Color    = col(iH,:);                                        	% Change color to format
      h(iH).Tag      = 'Fixed';                                            % Set fixed
   end
   
  
   % 3. Plot error
   subplot(233); 
   title(['Error (MSE=' num2str(round(perf,5)) ')']);
   hold on; 
   axis square;
   plot(az_loc, az_nheight, 'LineWidth', 3);
   plot(el_loc, el_nheight, 'LineWidth', 3);
   ylim([0 100]);
   xlim([-2 2]);
   xlabel('Prediction error ($^{\circ}$)');
   ylabel('Amount of data ($\%$)');
   legend('Azimuth','Elevation')
   pb_vline(0);
   
   % Model fit 
   h_iso(1) = subplot(2,12,13:18);
   hold on;
   
   h_iso(2) = subplot(2,12,19:24);
   hold on;
   
   c           = -90:3:90;
   ctheta      = -90:10:90;
   cphi        = -90:15:90;
   c_title     = {'Right eye','Left eye'};
   
   for iA = 1:2
      
      axes(h_iso(iA))
      
      % Select angle
      if iA == 1
         X        = Raz;
         Y        = Rel;
      else
         X        = Laz;
         Y        = Lel;
      end
      
      V        = azel_(1,:);

      sel      = isnan(X) | isnan(Y) | isnan(V);
      X        = X(:,~sel);

      Y        = Y(:,~sel);
      V        = V(:,~sel);

      Xa       = linspace(min(X),max(X),200);
      Ya       = linspace(min(Y),max(Y),200);
      [Xa,Ya]  = meshgrid(Xa,Ya);
      Va       = griddata(X,Y,V,Xa,Ya,'natural');

      V        = azel_(2,~sel);
      Ve       = griddata(X,Y,V,Xa,Ya,'natural');

      contour(Xa,Ya,Va,c);
      contour(Xa,Ya,Ve,c);

      [c2,h2]     = contour(Xa,Ya,Ve,cphi,'color',col(1,:)); set(h2,'LineWidth',2); %#ok<*ASGLU>
      [c2,h2]     = contour(Xa,Ya,Va,ctheta,'color',col(1,:)); set(h2,'LineWidth',2);
      [c2,h2]     = contour(Xa,Ya,Ve,[-90 -90],'color',col(1,:)); set(h2,'LineWidth',4);
      [c2,h2]     = contour(Xa,Ya,Ve,[90 90],'color',col(1,:)); set(h2,'LineWidth',4);
      [c2,h2]     = contour(Xa,Ya,Va,[-90 -90],'color',col(1,:)); set(h2,'LineWidth',4);
      [c2,h2]     = contour(Xa,Ya,Va,[90 90],'color',col(1,:)); set(h2,'LineWidth',4);
      [c3,h3]     = contour(Xa,Ya,Va,[0 0],'color',col(2,:)); set(h3,'LineWidth',2);
      [c4,h4]     = contour(Xa,Ya,Ve,[0 0],'color',col(2,:)); set(h4,'LineWidth',2);
      xlim([-50 50]);
      ylim([-30 30]);
      xlabel('input azimuth');
      ylabel('input elevation');
      title(c_title{iA});
      set(gca,'XTick',ctheta,'YTick',cphi);
   end

   pb_nicegraph('def',col_def,'lineWidth',2);
   
   savefig(fig_handle,[GV.gen_path filesep 'Training_Figure_' GV.gen_fn(16:end-4) '.fig']);
end



function save_cal_fig(h,GV)
% This function will check if calibration figure requires saving and then does so if necessary    

   % Assert
   if ~GV.cal_storefig || ~h.UserData.figure_changed;  return; end      	% Don't save figure if you do not want to store it, or if it did not change
   
   h.UserData.figure_changed = false;                                      % Set change back to false
   
   fn = [GV.cal_fn];                        % Create filename
   if exist([cd filesep fn],'file')                                        % If name already exists, ask to overwrite data
      
      % Prompt user to include ROI
      answer = questdlg(' Would you like to overwrite the calibration data', ...
                        'Calibration figure already found inf currrent folder.', ...
                        'Yes','No thank you','No thank you');
      % Handle response
      switch answer
          case 'Yes'
            % Do nothing
          case 'No thank you'
         return
      end
   end
   savefig(h,fn);                                                          % Save figure
   disp(['Calibration_Figure stored in: ' cd]);
end


function [UD,fig_handle,ax_handle]	= build_calfigure(Cal,GV)
% This function will build a figure for  the analysis of XT mapping ROI for
% calibration

   % Build Figure
   [GV.gen_cfn,fig_handle]       = pb_newfig(GV.gen_cfn);
   ax_handle                  	= axes;
   ax_handle.Toolbar.Visible   	= 'off';
   
   axis square;
   hold on;
   ylim([-50 50]);
   xlabel('Time (s)');
   ylabel('Position ($^{\circ}$)');
   pb_nicegraph;
   
   % Train network
   net      = fitnet(GV.cal_nethidden);                                    % Train network with 3 hidden units
   %net.trainParam.showWindow          = 0;
   net.divideParam.trainRatio          = 1;
   net.divideParam.testRatio           = 0;
   net.divideParam.valRatio            = 0;   
   
   % Get timestamps
   ts_pup            = lsl_correct_lsl_timestamps(Cal.pupil_labs);         % Calibration files are not yet lsl corrected 
   ts_eo             = lsl_correct_lsl_timestamps(Cal.event_out);
   ts_pup            = ts_pup(1:2:end) - ts_eo(1);                         % Half the data due to double sampling (and synch with onset first (fixation) LED)
   ts_eo             = ts_eo - ts_eo(1);                                   % Synch with itself
   target_on         = transpose(ts_eo(3:4:end));                        	% Target onset
   target_off        = transpose(ts_eo(4:4:end));                          % Target offset
   ntargets          = length(target_on);
   
   % Convert and merge samples
   PL                = get_pupil_data(Cal.pupil_labs.Data);                % Get pupil data from calibration
   x                 = PL.gaze_point_3d_x;
   y                 = PL.gaze_point_3d_y;
   z                 = PL.gaze_point_3d_z;
   [az,el]           = pupil_xyz2azel(x,y,z);                              % Compute azel from 3D x/y/z
   [~,smv, ~]        = pb_pupilvel(az,el,GV.gaze_fs);                      % Get smoothed velocity for rough saccade detection

   % Detect saccades
   [on_idx,off_idx]  = pb_detect_saccades(smv,PL.confidence);              % Detect saccades
   on_time           = ts_pup(on_idx);
   off_time          = ts_pup(off_idx);
   nsaccades         = length(on_time);
   col               = pb_selectcolor(2,2);   
   
   % Plot   
   plot(ts_pup,az,'color',col(1,:));                                       % Azimuth
   plot(ts_pup,el,'color',col(2,:));                                       % Elevation
   plot(ts_pup,PL.confidence*50,'--k','tag','Fixed');                      % Some weird confidence value
   
   % Visual aids
   pb_vline(target_on,'color','k');
   pb_vline(target_off,'color','k');
   
   % Patch saccades
   for iS = 1:nsaccades
      % Iterate over saccades
      
      % Get timestamps saccades
      t1    = on_time(iS);                                                 % Onset
      t2    = off_time(iS);                                                % Offset

      % Convert to xy values
      x     = [t1 t2 t2 t1];                                               % Compute x's
      y     = [min(ax_handle.YLim) min(ax_handle.YLim) max(ax_handle.YLim) max(ax_handle.YLim)];       % Compute y's
      
      patch(x,y,[0.5,0.5,0.5],'FaceAlpha',0.3);                            % Create saccadic patch
   end
   legend('Azimuth','Elevation');
   
   % Write UserData
   UD.trial_times    = [target_on-0.5, target_off+0.5];
   UD.discard        = false(ntargets,1);                                  % 45x1, is trial discarded?
   UD.X              = nan(ntargets,4);                                    % 45x4, [az0; el0; az1; el1] (i.e. first right then left)
   UD.T              = nan(ntargets,2);                                    % 45x2, [az; el]
   UD.net            = net;                                                 % Leave empty for now
   UD.scaler         = 50;                                                 % Scaler should always be 50 (i.e. more than max. targets and response)
   UD.pupil_ts       = ts_pup;                                             % Pupil data
   UD.pupil_D        = PL;
   UD.patch_h        = gobjects(ntargets,1);                               % Give patch handle
   UD.figure_changed = true;
   UD.current_target = gobjects(2,1);
   UD.GV             = GV;                                                 
   
   % Store handles in Calibration_Figure
   set(fig_handle,'defaultLegendAutoUpdate','off');                        % Turn of auto update legend
   set(fig_handle,'WindowKeyPressFcn',@keyPressCal);                       % Add keypress function
   set(fig_handle,'closeRequestFcn',@closeReqCal);                         % Add closereq function
   set(fig_handle,'Name','Calibration_Figure');                            % Add Calibration_Figure tag
   set(fig_handle,'UserData',UD);                                          % Store UserData
end


function keyPressCal(fig_handle, eventdata)
% This function will coordinate different keystrokes with functionality

   keystroke      = eventdata.Key;
   UD             = fig_handle.UserData;
   col            = pb_selectcolor(2,2);

   % Read trial data
   h              = pb_fobj(fig_handle,'Type','Axes');
   trial_num      = str2double(strrep(h.Title.String, 'Trial ',''));
   current_time   = UD.trial_times(trial_num,:);
   xlim(current_time);
   
   % Match functionality with keystroke
   switch lower(keystroke)

      % Next Trial
      case {'n','rightarrow'}
         
         % Assert
         if trial_num >= size(UD.trial_times,1); return; end               % Check if index is not last
         
         % Remove current targets
         for iC = 1:size(col,1)
            delete(fig_handle.UserData.current_target(iC));
         end
         
         % Change trial
         trial_num   = trial_num+1;                                        % Add counter to trial index
         xlim(UD.trial_times(trial_num,:));                                % Update trial time display
         
         % Change current targets
         for iC = 1:size(col,1)
            fig_handle.UserData.current_target(iC) = pb_vline(UD.T(1,iC),'color',col(iC,:));    % Set azimuth/elevation target
         end

         
      % Previous Trial
      case {'p','leftarrow'}
         
         % Assert
         if trial_num <2; return; end                                      % Check if index is not first
         
         % Remove current targets
         for iC = 1:size(col,1)
            delete(fig_handle.UserData.current_target(iC));
         end

         % Change trial
         trial_num   = trial_num-1;                                        % Remove counter from trial index
         xlim(UD.trial_times(trial_num,:));                                % Update trial time display
            
         % Change current targets
         for iC = 1:size(col,1)
            fig_handle.UserData.current_target(iC) = pb_vline(UD.T(1,iC),'color',col(iC,:));    % Set azimuth/elevation target
         end
         
         
      % Correct (i.e. delete patch insert new)
      case {'c'} 
         
         fig_handle.UserData.figure_changed     = true;                  	% Set change to true
         
         % Delete
         delete(fig_handle.UserData.patch_h(trial_num));                   % Delete selection
         
         % Patch region of interest
         [t,~] = ginput(2);                                                % Get patched ROI info
         x   	= [t(1) t(2) t(2) t(1)];                                    % Get x
         y    	= [min(h.YLim) min(h.YLim) max(h.YLim) max(h.YLim)];        % Get y
         
         
         fig_handle.UserData.patch_h(trial_num) 	= patch(x,y,'g','FaceAlpha',0.3); % Update patch
         
         az       = pb_fobj(gca,'DisplayName','Azimuth');
         el       = pb_fobj(gca,'DisplayName','Elevation');
         
         ts_pup   = az.XData;
         az_pup   = az.YData;
         el_pup   = el.YData;
         
         range    = ts_pup >= t(1) && ts_pup <= t(2);
         
         % Compute X (azel right vs left)
         fig_handle.UserData.X(tria_num)           = [raz,rel,laz,lel];    % NN input:
         
      
         
      % Delete patch 
      case {'d','backspace','delete'}
         
         fig_handle.UserData.figure_changed = true;                     	% Set change to true
                  
         % Delete
         delete(h.UserData.patch_h(trial_num));                           	% Delete selection
         
         
      % Insert new patch
      case {'i'}
         
         fig_handle.UserData.figure_changed = true;                     	% Set change to true
         
         % Patch region of interest
         [x,~] = ginput(2);                                                % Get patched ROI info
         x   	= [x(1) x(2) x(2) x(1)];                                    % Get x
         y    	= [min(h.YLim) min(h.YLim) max(h.YLim) max(h.YLim)];        % Get y
         fig_handle.UserData.patch_h(trial_num) 	= patch(x,y,'g','FaceAlpha',0.3); % Update patch
         
   end
      
   title(['Trial ' num2str(trial_num)]);
   if fig_handle.UserData.discard(trial_num)
      disp(['Trial ' num2str(trial_num) ' was discarded for data mapping.']);
   else
      disp(['Trial ' num2str(trial_num) ' was included for data mapping.']);
   end
end

function closeReqCal(fig_handle,~)
% When you close the figure you need to decived if you want to save it.

   % Get UserData from fig_handle
   save_cal_fig(fig_handle,fig_handle.UserData.GV);                                                   % Save figure if changed
   delete(fig_handle);
   disp('>> Calibration_Figure opened.');
end


% ---


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%                    Pupil functions                        %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 



function PL = get_pupil_data(Data)
% this function  will read out the 

   c_pl  = pb_pupillabels;                                                 % Get the PL labels
   idc   = [1, 4, 5, 6, 13, 14, 15, 16, 17, 18];                           % These are the idc of significance for eye track with PL 
   
   % make pnan
   if ~iseven(length(Data(1,:))); pnan = nan; else; pnan = []; end
   
   
   
   for iP = 1:length(idc)
      % insert fields for the relevant pupil data
      pldata               = [Data(idc(iP),:), pnan];                      % Add nan for making an evensplit
      PL.(c_pl{idc(iP)})   = nanmean([pldata(1:2:end); pldata(2:2:end)]);  % Half the number of samples
   end
end



function [az,el] 	= pupil_xyz2azel(x,y,z)
   % This function will convert xyz into az, el (see VC Manual 2022)
   
   % Left handed, y-down coordinate system 2 azel
   % Up is negative, Down is positvie; Left is negative, and Right is
   % positive
   
   % Compute r 
   r        = sqrt(x.^2 + y.^2 + z.^2);
   if r(1) > 1; [x,y,z] = normalize_coordinates(x,y,z); end
   
   % Convert 2 spherical 
   az       = atand(x./z);
   el       = atand(y./(sqrt(x.^2 + z.^2)));
   
   % make unit vector
   function [x,y,z] = normalize_coordinates(x,y,z)
      for iL = 1:length(x)
         vector   = [x(iL) y(iL) z(iL)];
         vector   = vector./norm(vector);

         x(iL)        = vector(1);
         y(iL)        = vector(2);
         z(iL)        = vector(3);
      end
   end
end

% Parsing functions
function [P,GV] = getdata(Data, T, GV)
   % Function will get timestamps for the different streams
   disp('>> Obtaining data streams...');
   
   for iB = 1:length(GV.gen_blockidx)
      % Iterate over blocks
      
      block = GV.gen_blockidx(iB);
      
      % Determine fixation point
      [pup_idx,opt_idx]          = get_fixation_idx(Data(iB),T(iB));

      % Store timestamps
      P(iB).pupillabs            = getpupil(Data(iB), T(iB), pup_idx, GV); %#ok
      P(iB).pupilometry          = getdilation(Data(iB), GV); %#ok
      P(iB).optitrack            = getopti(Data(iB), opt_idx,GV); %#ok
      P(iB).gaze                 = computegaze(P,Data(iB), T(iB), opt_idx, pup_idx, GV); %#ok
      P(iB).chair                = []; %#ok
      P(iB).block_idx            = block; %#ok
      
      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.gen_blockidx)) ')']);
   end
   disp(newline)
end

function [pup_idx, opt_idx] = get_fixation_idx(block_data,block_time)
   % Function will read, filter, and interpolate eye traces
   
   % optitrack
   qw          = block_data.Opt.Data.qw; 
   qx          = block_data.Opt.Data.qx; 
   qy          = block_data.Opt.Data.qy; 
   qz          = block_data.Opt.Data.qz;
   q           = quaternion(qw,qx,qy,qz);
   azel_head   = convert_quat2azel(q);
   
   % pupillabs
   if isfield(block_data,'Calibration')
      if ~isempty(block_data.Calibration.net)
         azel_eye    = map_eyes2azel(block_data);
      end
   else
      x           = block_data.Pup.Data.gaze_normal_3d(:,1);
      y           = block_data.Pup.Data.gaze_normal_3d(:,2);
      z           = block_data.Pup.Data.gaze_normal_3d(:,3);
      
      azel_eye    = convert_xyz2azel(x,y,z);
   end
   
   % graph
   cfn = pb_newfig(231);
   hold on;

   plot(block_time.optitrack - block_time.optitrack(1), azel_head - azel_head(1,1));
   plot(block_time.pupillabs - block_time.optitrack(1), azel_eye - azel_eye(1,:));
   
   legend('Head azimuth','Head elevation','Eye azimuth','Eye elevation')
   xlim([0 25]);
   ylim([-50 50])
   pb_nicegraph;
   
   [input_x,~]    = ginput(1);

   [~, pup_idx]   = min(abs(block_time.pupillabs - block_time.optitrack(1) - input_x));
   [~, opt_idx]   = min(abs(block_time.optitrack - block_time.optitrack(1) - input_x));
   
   close(cfn);
end

function azel = map_eyes2azel(block_data)
   % This function takes the input norm data and converts it to azel using
   % neural network and scaler.

      % Input
      Rx                = block_data.Pup.Data(13,:);                       % Extract all unit vectors to compute both left and right azel
      Ry                = block_data.Pup.Data(14,:);
      Rz                = block_data.Pup.Data(15,:);
      Lx                = block_data.Pup.Data(16,:);
      Ly                = block_data.Pup.Data(17,:);
      Lz                = block_data.Pup.Data(18,:);
      
      [Raz,Rel]         = pupil_xyz2azel(Rx,Ry,Rz);                        % Compute right spherical estimation
      [Laz,Lel]         = pupil_xyz2azel(Lx,Ly,Lz);                        % Compute left spherical estimation
      X                 = [Raz; Rel; Laz; Lel];                            % Set in network input format 4xN (Left then Right)
      Xn                = X ./ block_data.Calibration.scaler;              % Normalize with scaler

      % Simulate network
      net               = block_data.Calibration.net;                      % Load network
      nazel             = sim(net,(Xn));                                   % Simulate network 
      azel              = nazel .* block_data.Calibration.scaler;          % Scale back to undo normalization
      
      % compare difference
      x                 = block_data.Pup.Data(4,:);
      y                 = block_data.Pup.Data(5,:);
      z                 = block_data.Pup.Data(6,:);
      [az,el]           = pupil_xyz2azel(x,y,z);
      
      t                 = block_data.Pup.Timestamps - block_data.Pup.Timestamps(1);
      
      % compare
      pb_newfig(321);
      
      subplot(121);
      axis square;
      hold on;
      
      plot(t,azel(1,:));
      plot(t,az)
      legend('network','pl')
      
      subplot(122)
      axis square
      hold on
      
      plot(t,azel(2,:));
      plot(t,el)
      legend('network','pl')
      h = pb_fobj(gcf,'type','axes');
      linkaxes(h,'x');
      
      ylim([-50 50]);
      pb_nicegraph;
end

function azel   = convert_xyz2azel(x,y,z)
   % Convert xyz 2 azel

   RTD = 180/pi;
   azel = zeros(length(x),2);

   %p           = sqrt(x.^2 + z.^2);
   azel(:,1)   = RTD * atan2(x, sqrt (y.^2 + z.^2));
   azel(:,2)   = RTD * atan2(y,z);
end

function azel = convert_quat2azel(q)
   % convert quaternions 2 xyz 2 azel

   vp    = RotateVector(q,[0 0 1]',1);

   y     = vp(2,:);
   z     = vp(3,:);
   x     = vp(1,:);

   azel  = convert_xyz2azel(x,y,z);
end

function trace = getpupil(block_data,block_time,idx,GV)
   % Function will read, filter, and interpolate eye traces

   % Check if calibration data is added to field
   if ~isempty(block_data.Calibration)    
      trace    = map_eyes2azel(block_data);
   else % If there is no calibration data
      trace    = compute_pupil_position(block_data,block_time,idx); % old method
   end
   
   trace       = filter_trace(trace,GV);
end

function trace = compute_pupil_position(block_data,block_time,idx)

      % compute offset
      normv    = block_data.Pup.Data.gaze_normal_3d(idx:idx+20,:);
      normv    = median(normv);

      % estimate rotation matrix
      GG       = @(A,B) [dot(A,B) -norm(cross(A,B)) 0;
                        norm(cross(A,B)) dot(A,B)  0;
                  0              0           1];

      FFi   = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];
      UU    = @(Fi,G) Fi * G / Fi;
      b     = normv'; 
      a     = [0 0 1]';
      Rot   = UU(FFi(a,b), GG(a,b));

      % Rotate
      gaze_normalsrot            = block_data.Pup.Data.gaze_normal_3d * Rot;
      gaze_normalsrotOpt(:,1)    = -interp1(block_time.pupillabs, gaze_normalsrot(:,1), block_time.optitrack,'pchip');
      gaze_normalsrotOpt(:,2)    = interp1(block_time.pupillabs, gaze_normalsrot(:,2), block_time.optitrack,'pchip');
      gaze_normalsrotOpt(:,3)    = interp1(block_time.pupillabs, gaze_normalsrot(:,3), block_time.optitrack,'pchip');

      qEye        = quaternion.rotateutov([0 0 1]',gaze_normalsrotOpt',1,1);
      trace       = -convert_quat2azel(qEye);
end

function trace = getdilation(block_data,GV)
   % Function will read, filter, and interpolate eye traces
   
   % PREPROCESSING  Collects pupil traces from the raw data set and
   %                creates a list that codes for valid and invalid traces
   %                based on the percentage of blinks.
   % LINEAR INT     Fills in gaps created by blinks.
   %                Note that blinks will also create gaps in eye-movement
   %                data. This is not covered in this workshop.
   % MOVING AVE     Moving average filter for smoothing data.
   % AVERAGING      Average over all traces is calculated.
   
   if isfield(block_data,'Calibration'); trace = []; return; end
   
   % 1. Preprocessing
   raw_diameter     = block_data.Pup.Data.base_data.diameter_3d;
   time              = (1:length(raw_diameter))/GV.gaze_fs; 
   diameter_filt  = raw_diameter;
   
   % find blinks
   blinks_zero             = raw_diameter==0;
   diametersz              = size(raw_diameter);
   diameterl               = length(raw_diameter);
   blink_bool              = false(diametersz);
   blink_bool(blinks_zero) = true;

   window = 5;
   
   % front cut
   for iS = window+1:diameterl-(window+1)
      if blink_bool(iS); blink_bool(iS-window:iS) = true; end
   end
   
   % back cut
   rev_blink_bool = flipud(blink_bool);
   for iS = window+1:diameterl-(window+1)
      if rev_blink_bool(iS); rev_blink_bool(iS-window:iS) = true; end
   end
   
   blink_bool = flipud(rev_blink_bool);
   
   diameter_filt(blink_bool) = nan;

   % 2. Linear interpolation
	trace             = diameter_filt;
	sel					= double(isnan(trace));
	sel					= double(movavg(sel,8)>0);
	trace             = interp1(time(~sel),trace(~sel),time,'linear','extrap');
   
   % 3. Bandpass smooth
   trace    = movavg(trace,5);
   trace    = highpass(trace,'Fc',0.1,'Fs',GV.gaze_fs)';
	trace    = lowpass(trace,'Fc',2,'Fs',GV.gaze_fs)';
end

function trace = getopti(block_data,idx,GV)
   % Function will read, filter, and interpolate head traces
   
   % get quaternions
   q           = quaternion(block_data.Opt.Data.qw, block_data.Opt.Data.qx, block_data.Opt.Data.qy, block_data.Opt.Data.qz);
   qRot        = q(idx);                        % compute offset
   
   % convert to azel
   trace       = -convert_quat2azel(q*qRot');   
   trace       = filter_trace(trace,GV);
end

function trace = computegaze(P,block_data, block_time)%, opt_idx, pup_idx, GV)
   % Function will compute gaze 
   
   % if data already exists                                               
   if isfield(block_data,'Calibration')
      
      if ~isequal(size(P.pupillabs),size(P.optitrack))
         P.optitrack(:,1) = interp1(block_time.optitrack, P.optitrack(:,1), block_time.pupillabs,'pchip');
         P.optitrack(:,2) = interp1(block_time.optitrack, P.optitrack(:,2), block_time.pupillabs,'pchip');
      end
      
      trace = P.pupillabs + P.optitrack;
      return
   end
%    
%    % Head
%    q           = quaternion(block_data.Opt.Data.qw, block_data.Opt.Data.qx, block_data.Opt.Data.qy, block_data.Opt.Data.qz);
%    qRot        = q(opt_idx);                        % compute offset
%    qHead       = q * qRot';
%    Rs          = RotationMatrix(qHead);
%    
%    % Eye
%    normv    = block_data.Pup.Data.gaze_normal_3d(pup_idx:pup_idx+20,:);
%    normv    = median(normv);
% 
%    GG       = @(A,B) [dot(A,B) -norm(cross(A,B)) 0;    % estimate rotation matrix
%                      norm(cross(A,B)) dot(A,B)  0;
%                      0              0           1];
% 
%    FFi   = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];
%    UU    = @(Fi,G) Fi * G * inv(Fi); %#ok
%    b     = normv'; 
%    a     = [0 0 1]';
%    Rot   = UU(FFi(a,b), GG(a,b));
% 
%    % Rotate
%    gaze_normalsrot            = block_data.Pup.Data.gaze_normal_3d * Rot;
%    gaze_normalsrotOpt(:,1)    = -interp1(block_time.pupillabs, gaze_normalsrot(:,1), block_time.optitrack,'pchip');
%    gaze_normalsrotOpt(:,2)    = interp1(block_time.pupillabs, gaze_normalsrot(:,2), block_time.optitrack,'pchip');
%    gaze_normalsrotOpt(:,3)    = interp1(block_time.pupillabs, gaze_normalsrot(:,3), block_time.optitrack,'pchip');
% 
%    qEye     = quaternion.rotateutov([0 0 1]', gaze_normalsrotOpt',1,1);
%    RsEye    = RotationMatrix(qEye);
% 
%    % Compute gaze
%    R     = 0.91; a = 1; b = 1; c = 1;
%    zcal  = 0;
%    xcal  = 0;
%    ycal  = 0;
% 
%    locspeakxyz = [-0.1257, 0.0195, -0.8426];
%    Opt         = block_data.Opt.Data;
% 
%    for n = 1:length(qHead)
%        locz(n) = locspeakxyz(3) + R + Opt.z(n) - Opt.z(1);
%        locx(n) = locspeakxyz(1) + Opt.x(n) - Opt.x(1);
%        locy(n) = locspeakxyz(2) + Opt.y(n) - Opt.y(1);
% 
%        P(:,n)                 = RsEye(:,:,1,n) * [0;0;1];
%        Pcal(:,n)              = P(:,n) + [xcal; ycal; zcal];
%        PG(:,n)                = Rs(:,:,1,n) * Pcal(:,n);
%        PGs(:,n)               = PG(:,n) * R + -[Opt.x(n)-Opt.x(1); Opt.y(n)-Opt.y(1); Opt.z(n)-Opt.z(1)];
%        PGnorms(:,n)           = PGs(:,n) / norm(PGs(:,n));
%        MatrixGaze(:,:,1,n)    = Rs(:,:,1,n) * RsEye(:,:,1,n);
%        MatrixGazenorms(:,n)   = MatrixGaze(:,3,1,n) / norm(MatrixGaze(:,3,1,n));
%    end
%    
%    switch GV.gaze_method
%       case 'new'
%          trace       = -convert_quat2azel(qHead.*qEye);                       % Simpele manier om gaze te bepalen, quaternion multiplicatie dus puur beide rotaties combineren
%       otherwise
%          trace       = -convert_xyz2azel(PGnorms(1,:),PGnorms(2,:),PGnorms(3,:));   % Oude manier om gaze te bepalen, incl translaties
%    end
%    
%    
end

function trace = filter_trace(trace,GV)
   % Function will apply all relevant filters
   
   % Heuristics
   if GV.filter_heuristic
      trace = stampe_filtering(trace,GV);
   end
   
   % Smoothen (Savinsky-Golay)
   if GV.filter_sgolay 
      trace = sgolay_filtering(trace,GV);
   end
   
   % Butterworth low-pass
   if GV.filter_butter                %(cut-off: 20-25, order: 5, see table 2 Mack et al 2017)
      trace = bw_filtering(trace,GV);
   end
   
   % remove spikes with median filter
   if GV.filter_median
      trace = median_filtering(trace,GV);
   end
end


function trace = stampe_filtering(trace,GV)
   % Function will implement a set of 2 heuristic filters (Stampe, 1993) 
   
   ot = trace;
   
   for iO = 1:size(trace,2)
      trace(iO,:) = filter1(trace(iO,:));
      trace(iO,:) = filter2(trace(iO,:));
   end
   
   function x = filter1(x)
      % 1 sample delay filter
      for iP = 3:length(x)
         if(x(iP-2)>x(iP-1) && x(iP-1)<x(iP))
            if abs(x(iP-1)-x(iP))< abs(x(iP-1)-x(iP-2))
               x(iP-1)  = x(iP);
            else
               x(iP-1)  = x(iP-2);
            end
         elseif (x(iP-2) < x(iP-1) && x(iP-1) > x(iP))
            if abs(x(iP-1)-x(iP)) < abs(x(iP-1)-x(iP-2))
               x(iP-1)=x(iP);
            else
               x(iP-1)=x(iP-2);
            end
         end
      end
   end
   
   function x = filter2(x)
      % 3 sample delay filter
      for j = 4:length(x)
          if x(j-2) == x(j-1)
              if x(j) ~= x(j-1)
                  if x(j-2) ~= x(j-3)
                      % replace x1 en x2 with closest of x3 or x
                      if abs(x(j-1)-x(j)) < abs(x(j-1)-x(j-3))
                          x(j-1)    = x(j);
                      else
                          x(j-1)    = x(j-3);
                      end
                      if abs(x(j-2)-x(j)) < abs(x(j-2)-x(j-3))
                          x(j-2)    = x(j);
                      else
                          x(j-2)    = x(j-3);
                      end
                  end
              end
          end
      end
   end

   if GV.gen_debug; visualize_filter(ot,trace,GV); end
end

function trace = sgolay_filtering(trace,GV)
   % Function will implement a set of 2 heuristic filters (Stampe, 1993) 
   
   ot = trace;
   
   %  settings
   order    = 3; 
   framelen = 7;
   
   for iO = 1:size(trace,2)
      trace(iO,:) = sgolayfilt(trace(:,iO),order,framelen);
   end
   
   if GV.gen_debug; visualize_filter(ot, trace, GV); end
end

function trace = bw_filtering(trace,GV)
   % See Mack et al 2017 for best filter settings: 200Hz + high noise -->
   % 20-25 fc, 5th order.
   
   ot       = trace;
   
   order    = 5;
   fc       = 75;
   
   [b,a]    = butter(order,fc/(GV.gaze_fs/2));
   
   for iO = 1:size(trace,2)
      trace(iO,:) = filtfilt(b,a,trace(:,iO));
   end
   
   if GV.gen_debug; visualize_filter(ot,trace,GV); end
end

function trace = median_filtering(trace,GV)
   % This function will perform a median filter
   
   ot = trace;
   
   %  settings
   window    = 7; 
   
   for iO = 1:size(trace,2)
      trace(iO,:) = medfilt1(trace(:,iO),window);
   end
   
   if GV.gen_debug; visualize_filter(ot, trace, GV); end
end

function visualize_filter(old, new, GV, conf)

   iT  = 1;          % Azimiuth = 1 / Elevation  = 2;
   
   dur      = length(new);
   t        = (1:dur)/GV.gaze_fs;
   
   if nargin < 4; conf = nan(size(new)); end
   
   % Graph data
   GV.gen_cfn = pb_newfig(GV.gen_cfn);
   sgtitle(pb_sentenceCase(strrep(pb_getfunname('depth',3),'_',' ')));
   
   subplot(2,1,1);
   title('Traces')
   hold on;
   plot(t,old(iT,:));
   plot(t,new(iT,:));  
   plot(t,conf);
   legend('Original','Filtered');
   
   subplot(2,1,2);
   title('Removed');
   hold on;
   plot(t,old(iT,:)-new(iT,:));
   plot(t,conf);
   legend('difference');
   pb_nicegraph
   
   linkaxes(pb_fobj(gcf,'type','axes'),'xy');
   ylim([0 1]); xlim([90 92]);
end

function T = gettimestamps(Data,GV)
   % Function will get timestamps for the different streams
   disp('>> Obtaining LSL timestamps...');
   
   for iB = 1:length(GV.gen_blockidx)
      % iterate over blocks
      
      block = GV.gen_blockidx(iB);
         
      % correct pupil labs
      lsl_tsPupRaw         = Data(block).Timestamp.Pup;
      
      if iscell(Data(block).Pup.Data)
         lsl_tsPup            = Data(block).Pup.Data.timestamp' - Data(block).Pup.Data.timestamp(6) + lsl_tsPupRaw(6);
      else
         lsl_tsPup            = Data(block).Pup.Timestamps - Data(block).Pup.Timestamps(6) + lsl_tsPupRaw(6);
      end
      
      diffs                = abs(lsl_tsPup-lsl_tsPupRaw);
      lsl_tsPup(diffs>10)  = lsl_tsPupRaw(diffs>10);

      % store timestamps
      T(iB).pupillabs            = lsl_tsPup;                              %#ok
      if ~isempty(Data(block).Opt)
         T(iB).optitrack            = Data(block).Timestamp.Opt;           %#ok
      else
         T(iB).optitrack         = lsl_tsPup;                              %#ok
      end
      T(iB).stimuli              = Data(block).Timestamp.Stim;             %#ok
      T(iB).chair                = [];                                     %#ok
      T(iB).block_idx            = block;                                  %#ok
      
      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.gen_blockidx)) ')']);
   end
   disp(newline)
end

function S = getstims(Data,GV)
   % Function will sort stimulus times/targets
   disp('>> Obtaining stimuli...');

   for iB = 1:length(GV.gen_blockidx)
      % Iterate over blocks
      
      block = GV.gen_blockidx(iB);
      
      for iT = 1:length(Data(block).Block_Info.trial)
         % Iterate over trials
         
         trial    = Data(block).Block_Info.trial(iT);
         idx      = GV.stim_targetidx;
                  
         % Store stimuli in right spherical coordinate system
         S(iB).azimuth(iT)       = trial.stim(:,idx).azimuth; %#ok         % Left is negative / Right is positive
         S(iB).elevation(iT)     = trial.stim(:,idx).elevation * -1; %#ok  % Down is positive / Up is negative, so flip elevation from measuring file
         S(iB).duration(iT)      = trial.stim(:,idx).offdelay - trial.stim(:,1).ondelay; %#ok   
         S(iB).frame(iT)         = {'Chair fixed'}; %#ok
         
         if GV.stim_frames && S(iB).azimuth(iT) == 90                      % select world fixed frames // transform azimuth position can only be done after epoching
            S(iB).frame(iT)      = {'World fixed'}; %#ok
         end
      end
      S(iB).block_idx = block; 
      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.gen_blockidx)) ')']);
   end
   disp(newline)                                                           % Update User
end

function [T,P] = getchair(Data, T, P, GV)
   % Function will sort chair times & targets
   disp('>> Inserting chair data...');
      
   % globals
   fs    = 9.95;
   
   for iB = 1:length(GV.gen_blockidx)
      % iterate over blocks
      
      block = GV.gen_blockidx(iB);
      
      % position signals
      sensehat_posD     = rad2deg(cumsum(Data(block).Sensehat.gyro_y - Data(block).Sensehat.gyro_y(1)))/-100;        % integrate velocity signal
      sensehat_posD     = sensehat_posD - sensehat_posD(1);                                                          % force sine start at 0
      vestibular_posD  	= pb_cleanSP(Data(block).VC.pv.vertical);                                                    % Strip tail from VC signal
      
      % timestamps
      lsl_tsSense       = Data(block).Timestamp.Sense;
      correctie         = Data(block).Timestamp.Opt(1);
      tsSense           = lsl_tsSense - correctie;                       	% Set ts(1) = 0
      tsVestibular    	= (0:length(vestibular_posD)-1)/fs;                % Create VC timestamps (0:0.1:Nx)
      
      if strcmp(Data.Block_Info.signal.ver.type,'none')
         
         T(iB).chair = tsSense;
         P(iB).chair = zeros(size(tsSense))';
         
      else
         
         % interpolate data
         if isempty(vestibular_posD)
            vestibular_posD   = Data(block).VC.pv.vertical;
            tsVestibular      = (0:length(vestibular_posD)-1)/fs;
            vestibular_posDI  = interp1(tsVestibular, vestibular_posD, tsSense, 'pchip');
            tsVestibularI     = tsSense;
         else
            vestibular_posDI  = interp1(tsVestibular, vestibular_posD, tsSense, 'pchip');
            tsVestibularI     = tsSense;
         end

         % clip extrapolation
         inds                    = find(tsVestibularI >= max(tsVestibular));        % find index extrapolated values
         vestibular_posDI(inds)  = [];
         tsVestibularI(inds)     = [];

         % XCorr synchronization
         fsPup          = length(tsVestibularI)/tsVestibularI(end);
         [r,lag]        = xcorr(vestibular_posDI, sensehat_posD);
         [~,I]          = max(abs(r));
         lagDiff        = lag(I) / fsPup;
         tsVestibularI  = tsVestibularI - lagDiff;  
         
         % store data
         P(iB).chair                = vestibular_posDI;
         T(iB).chair                = tsVestibularI;
      end

      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.gen_blockidx)) ')']);
   end
   disp(newline)
end

% Read functions


function Data = epoch_data(Data,GV)
   % function will automatically epoch your data into chuncks as suggested
   % by the acquisition information
   
   samples     = GV.gaze_fs*GV.epoch_acqduration - 1;

   for iB = 1:length(Data.timestamps)

      % Empty traces
      E.AzChairEpoched     = [];
      E.ElChairEpoched     = [];
      E.AzGazeEpoched      = [];
      E.ElGazeEpoched      = [];
      E.AzEyeEpoched       = [];
      E.ElEyeEpoched       = [];
      E.AzHeadEpoched      = [];
      E.ElHeadEpoched      = [];

      % Interpolate Gaze
      lsl_opti  	= Data.timestamps(iB).optitrack;
      Data.timestamps(iB).epoch_interp       = 0:1/120:lsl_opti(end)-lsl_opti(1);
      Data.position(iB).gaze_interp(:,1)     = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).gaze(:,1), Data.timestamps(iB).epoch_interp,'pchip')';
      Data.position(iB).gaze_interp(:,2)  	= interp1(lsl_opti-lsl_opti(iB), Data.position(iB).gaze(:,2), Data.timestamps(iB).epoch_interp,'pchip')';

      % Interpolate Chair
      CUT_OFF     = 203;
      Data.position(iB).chair_interp(:,1)    = interp1(Data.timestamps(iB).chair, Data.position(iB).chair, Data.timestamps(iB).epoch_interp,'pchip')';
      Data.position(iB).chair_interp(Data.timestamps(iB).epoch_interp>CUT_OFF,1)  = zeros(1,sum(Data.timestamps(iB).epoch_interp>CUT_OFF));              % Correct for extrapolation == 0;
      Data.position(iB).chair_interp(:,2)    = zeros(size(Data.position(iB).chair_interp(:,1)));

      % Interpolate Eye
      Data.position(iB).eye_interp(:,1)      = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).pupillabs(:,1), Data.timestamps(iB).epoch_interp,'pchip')';
      Data.position(iB).eye_interp(:,2)      = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).pupillabs(:,2), Data.timestamps(iB).epoch_interp,'pchip')';

      % Interpolate Head
      Data.position(iB).head_interp(:,1)      = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).optitrack(:,1), Data.timestamps(iB).epoch_interp,'pchip')';
      Data.position(iB).head_interp(:,2)      = interp1(lsl_opti-lsl_opti(iB), Data.position(iB).optitrack(:,2), Data.timestamps(iB).epoch_interp,'pchip')';


      % Select stimuli indices
      nstim       = length(Data.stimuli(iB).azimuth);
      ntriggers   = length(Data.timestamps(iB).stimuli);
      
      ind         = GV.stim_targetidx;
      ext         = round(ntriggers/nstim);

      for iS = 1:nstim
         % epoch for stimuli
         start             = Data.timestamps(iB).stimuli(ind) - lsl_opti(1);
         [~,idx]           = min(abs(Data.timestamps(iB).epoch_interp-start));

         % Gaze
         E.AzGazeEpoched  	= [E.AzGazeEpoched, Data.position(iB).gaze_interp(idx:idx+samples,1)'];
         E.ElGazeEpoched  	= [E.ElGazeEpoched, Data.position(iB).gaze_interp(idx:idx+samples,2)'];

         % Chair
         E.AzChairEpoched  = [E.AzChairEpoched, Data.position(iB).chair_interp(idx:idx+samples,1)'];
         E.ElChairEpoched 	= [E.ElChairEpoched, Data.position(iB).chair_interp(idx:idx+samples,2)'];

         % Eye
         E.AzEyeEpoched   	= [E.AzEyeEpoched, Data.position(iB).eye_interp(idx:idx+samples,1)'];
         E.ElEyeEpoched   	= [E.ElEyeEpoched, Data.position(iB).eye_interp(idx:idx+samples,2)'];

         % Head
         E.AzHeadEpoched   = [E.AzHeadEpoched, Data.position(iB).head_interp(idx:idx+samples,1)'];
         E.ElHeadEpoched   = [E.ElHeadEpoched, Data.position(iB).head_interp(idx:idx+samples,2)'];

         ind = ind + ext;
      end
      Data.epoch(iB) = E;
   end
   
   
   if GV.stim_frames
      % This part will correct all 90 azimuth angles to stimulus onset
      % chair fixed reference frames
      
      Data = correct_world_fixed_azimuth(Data );
   end
end

function Data = correct_world_fixed_azimuth(Data)
   % this function will magically transform the azimuth position of world
   % fixed stimuli into a chair based reference frame at stimulus onset.

   for iB = 1:length(Data.stimuli)
      % For each block

      %world_fixed_stims    = ismember(Data.stimuli(iB).frame,'World fixed'); % get world fixed targets

      for iS = 1:length(Data.stimuli(iB).azimuth)
         % For each stimuli

         % Check if the stimulus' azimuth is '90' and correct it
         if Data.stimuli(iB).azimuth(iS) == 90

            % select
            stim_onset_idx                = (iS-1)*360+1;                                    % stimulus onset idx in epoch data
            chair_at_stim_onset           = Data.epoch(iB).AzChairEpoched(stim_onset_idx);   % get chair position
            Data.stimuli(iB).azimuth(iS)  = -(chair_at_stim_onset);                         	% flip the script, brothaaa (- is + en + is -)
         end
      end
   end
end



% 
% function check_calibration_performance(Data,UD,GV)
% % This function will check pupil labs-calibrated data vs world-calibrated data
% 
%    net = UD.net;
%    
%    pl          = Data(1).Calibration.Data.pupil_labs.Data;
%    [Raz,Rel]   =  pupil_xyz2azel(pl(13,:),pl(14,:),pl(15,:));
%    [Laz,Lel]   =  pupil_xyz2azel(pl(16,:),pl(17,:),pl(18,:));
% 
%    nazel       = [Raz; Rel; Laz; Lel] ./ UD.scaler;
%    
%    nazel_      = sim(net, nazel);
%    azel_       = nazel_ .* UD.scaler;
% 
%    [az,el]     =  pupil_xyz2azel(pl(4,:),pl(5,:),pl(6,:));
%    
%    for iS = 1:length(Data(1).Calibration.Data.block_info.trial)
%       target(iS,1)      = Data(1).Calibration.Data.block_info.trial(iS).stim(2).azimuth;
%       target(iS,2)      = -Data(1).Calibration.Data.block_info.trial(iS).stim(2).elevation;
%    end
%    target               = unique(target,'rows');
%    
%    
%    % 1. Plot the XY data
%    GV.gen_cfn = pb_newfig(GV.gen_cfn);
%    subplot(131); 
%    title('World calibrated (NN)');
%    hold on; 
%    axis square;
%    plot(azel_(1,:),azel_(2,:),'.');
%    
%    for iT = 1:45
%       scatter(UD.T(:,1),UD.T(:,2),350,'MarkerFaceColor',[1 0 1],'MarkerFaceAlpha',0.005,'Tag','Fixed')
%    end
%    
%    for iT = 1:length(target)
%       scatter(target(iT,1),target(iT,2),350,'ok','Tag','Fixed');
%    end
%       
%    ylim([-50 50]);
%    xlim([-50 50]);   
%    xlabel('Azimuth ($^{\circ}$)');   
%    ylabel('Elevation ($^{\circ}$)');
%    
%    subplot(132); 
%    title('Pupillabs calibrated'); 
%    hold on; 
%    axis square;
%    plot(az,el,'.');
%    plot(az(~isnan(azel_(1,:))),el(~isnan(azel_(1,:))),'.');
%    
%    for iT = 1:45
%       scatter(UD.T(:,1),UD.T(:,2),350,'MarkerFaceColor',[1 0 1],'MarkerFaceAlpha',0.001,'Tag','Fixed')
%    end
%    
%    for iT = 1:length(target)
%       scatter(target(iT,1),target(iT,2),350,'ok','Tag','Fixed');
%    end
%    
%    ylim([-50 50]);
%    xlim([-50 50]);
%    xlabel('Azimuth ($^{\circ}$)');   
%    ylabel('Elevation ($^{\circ}$)');
%    
%    subplot(133); 
%    title('Pupillabs calibrated - median'); 
%    hold on; 
%    axis square;
%    plot(az-median(az),el-median(el),'.');
%    plot(az(~isnan(azel_(1,:)))-median(az),el(~isnan(azel_(1,:)))-median(el),'.');
%    
%    for iT = 1:45
%       scatter(UD.T(:,1),UD.T(:,2),350,'MarkerFaceColor',[1 0 1],'MarkerFaceAlpha',0.001,'Tag','Fixed')
%    end
%    
%    for iT = 1:length(target)
%       scatter(target(iT,1),target(iT,2),350,'ok','Tag','Fixed');
%    end
%    
%    ylim([-50 50]);
%    xlim([-50 50]);
%    xlabel('Azimuth ($^{\circ}$)');   
%    ylabel('Elevation ($^{\circ}$)');
%    
%    pb_nicegraph;
%    
%    % Target Respons plot
%    %trplot(Data,GV,'block',1:length(Data));
% end
% 
% function fig_handle = trplot(Data,GV,varargin)
% 
%    V           = varargin;
%    blocks      =  pb_keyval('block',V,1);
%    
%    [~,fig_handle]  = pb_newfig(GV.gen_cfn);
% 
%    for iD = 1:length(blocks)
%          
%       iB = blocks(iD);
% 
%       
%       ts_pup      = Data(iB).Timestamp.Pup;
%       ts_eo       = Data(iB).Timestamp.Stim;
%       
%       ts_pup      = ts_pup - ts_eo(1);
%       ts_eo       = ts_eo - ts_eo(1);
%    end
% end