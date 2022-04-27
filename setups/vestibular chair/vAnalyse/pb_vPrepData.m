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
   % <--- UP UNTILL HERE: CLEANED & COMMENTED
   [D,GV]         = calibrate_data(D,GV);                                  % filters, and removes any inconsentensies from raw data
   GV             = read_keyval(D,GV);                                     % Correct any keyval
   
   % Parse data
   S        = getstims(D, GV);                                             % read the stimuli
   T        = gettimestamps(D, GV);                                        % synchronize the LSL timestamps
   
   % <--- UP UNTILL HERE: RUNS SMOOTHLY / NO ERRORS
   
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
   GV.gen_debug            = pb_keyval('debug', V, true);                  % Select true when debugging, it will provide some more figures and stops along the way.
   GV.gen_storedata        = pb_keyval('store', V, true);                  % If you want to store (and overwrite) data; select true.
   GV.gen_cfn              = pb_keyval('cfn', V, 231);                     % Set initial count current figure number
   
   % Calibration parse
   GV.cal_storefig         = pb_keyval('save_cal',V,true);                 % If you want to store (and overwrite) calibration data; select true.
   GV.cal_loadfromfig      = pb_keyval('load_cal',V,true);                 % Run calibration from latest calibration figure
   
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
   
   % select dir
   [fname, path]  = pb_getfile('cd',[GV.gen_cdir filesep '..'],'ext','converted_data_.mat');    % Open the converted data
   
   if ~isa(fname,'char')                                                   % If it doesn't exist; give an error
      prefix   = false; 
      ext      = false;
      error('No file was found.');
      return                                                               
   end
   
   % store fileparts
   [ext, fname]   = pb_fext(fname);
   prefix         = fname(1:15);       % 'converted_data_'
   fname          = fname(16:end);                                         % Final filename (skips over prefix)
end

function GV = read_keyval(Data,GV)
   % Read and correct keyvals parameters that are dependent on 'Data' (i.e. conversion from string to some parameter of the data)
   
   % Fix block numbers
   if ~isnumeric(GV.gen_blockidx)
      switch GV.gen_blockidx                                               % When all is selected, determine length of blocks and make array of blocks
         case 'all'
            GV.gen_blockidx = 1:length(Data);
         otherwise                                                         % If other non numeric, set block to 1 and only analyse first block
            GV.gen_blockidx = 1;
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

function [D,GV] = calibrate_data(Data,GV)
% This function will load any calibration figures, train network for
% calibration, and store calibration figure.

   % Calibrate
   if ~isfield(Data,'Calibration'); disp('No Calibration data was found.'); return; end % Assert
   
   % Load calibration figure
   idc   = load_calibration_figure(Data,GV);                               % Load calibration figure to select X,T mappings for NN (Y = M(X,T)
   D     = train_calibration(Data, idc, GV);                               % Train calibration network
end


function  idc  = load_calibration_figure(Data,GV)  
% This function  will determine if it needs to load any data figure
% timestamps
   idc = [];
end


function Data = train_calibration(Data, idc, GV)
% This will train neural network to map pupillabs norm position to real
% world azimuth/elevation values.

   % Globals
   Cal      = Data(1).Calibration.Data;
   if isempty(Cal); error('No calibtration data was found.'); end          % Check if data exists
   
   % Get timestamps
   ts_pup            = lsl_correct_lsl_timestamps(Cal.pupil_labs);         % Calibration files are not yet lsl corrected 
   ts_eo             = lsl_correct_lsl_timestamps(Cal.event_out);
   ts_pup            = ts_pup(1:2:end) - ts_eo(1);                         % Half the data due to double sampling (and synch with onset first (fixation) LED)
   ts_eo             = ts_eo - ts_eo(1);                                   % Synch with itself
   target_on         = ts_eo(3:4:end);                                     % Target onset
   target_off        = ts_eo(4:4:end);                                     % Target offset
   
   % Convert and merge samples
   PL                = get_pupil_data(Cal.pupil_labs.Data);                % Get pupil data from calibration
   [az,el]           = pupil_xyz2azel(PL.gaze_point_3d_x,PL.gaze_point_3d_y,PL.gaze_point_3d_z);  % compute azel from 3D x/y/z
   [~,smv, ~]        = pb_pupilvel(az,el,GV.gaze_fs);                      % Get smoothed velocity for rough saccade detection

   % Detect saccades
   [on_idx,off_idx]  = pb_detect_saccades(smv,PL.confidence);              % Detect saccades
   on_time           = ts_pup(on_idx);
   off_time          = ts_pup(off_idx);
   nsaccades         = length(on_time);
   
      
   % Build figure for detection of ROI
   col         = pb_selectcolor(2,2);   
   GV          = build_calfigure(GV);
   
   plot(ts_pup,az,'color',col(1,:));
   plot(ts_pup,el,'color',col(2,:));
   plot(ts_pup,PL.confidence*50,'--k','tag','Fixed');
   pb_vline(target_on,'color','k');
   pb_vline(target_off,'color','k');
   
   ax          = gca;
   
   % Patch saccades
   for iS = 1:length(on_time)
      % Iterate over saccades
      
      % Get timestamps saccades
      t1    = on_time(iS);                                                 % Onset
      t2    = off_time(iS);                                                % Offset

      % Convert to xy values
      x     = [t1 t2 t2 t1];                                               % Compute x's
      y     = [min(ax.YLim) min(ax.YLim) max(ax.YLim) max(ax.YLim)];       % Compute y's
      
      patch(x,y,[0.5,0.5,0.5],'FaceAlpha',0.3);                            % Create saccadic patch
   end
   legend('Azimuth','Elevation');
   
   % Map target response / preallocate variables
   discard           = false(size(target_on));                                
   X                 = nan([length(target_on) 4]);   
   T                 = nan([length(target_on) 2]);
   
   % Fill in data (X) and target mapping (T)
   for iT = 1:length(target_on)
      % For each trial find target / response values for mapping
      
      % Get trial info
      trial_info  = Cal.block_info.trial(iT).stim(2);                      % Second stimulus is the target during calibration
      target      = [trial_info.azimuth, -trial_info.elevation];
      stim_on     = target_on(iT);
      stim_off    = target_off(iT);
      
      sac_idx     = find(on_time>= stim_on+0.1,1);                         % find first saccade after a 100 ms delay after stimulus onset
      sac_on      = on_time(sac_idx);
      sac_off     = off_time(sac_idx);
      
      xlim([stim_on-0.5 stim_off+0.5]);
      t.String = ['Trial ' num2str(iT)];
      t.Color = 'k';
      
      for iD = 1:2
         pb_hline(target(iD),'visibility','on','color',col(iD,:));
      end
      
      % Prompt user to include ROI
      answer = questdlg('Would you to select like a stationary ROI?', ...
                        ['Trial ' num2str(iT)], ...
                        'Yes','No thank you','No thank you');
      % Handle response
      switch answer
          case 'Yes'
             discard(iT) = false;
             [x,~] = ginput(2);                                            % Select on- and offset for ROI

          case 'No thank you'
             discard(iT) = true;
             pb_delete;
             pb_delete;
      end
      
      % write mapping
      if ~discard(iT) % if you don't discard get 
         
         t.Color = 'g';
         % patch region of interest
         t1    = x(1);
         t2    = x(2);
         x     = [t1 t2 t2 t1];
         y     = [min(ax.YLim) min(ax.YLim) max(ax.YLim) max(ax.YLim)];
         patch(x,y,'g','FaceAlpha',0.3);
      

         T(iT,:)  = target;
         lxyz     = [median(PL.gaze_normal1_x(range)), median(PL.gaze_normal1_y(range)), median(PL.gaze_normal1_z(range))];
         rxyz     = [median(PL.gaze_normal0_x(range)), median(PL.gaze_normal0_y(range)), median(PL.gaze_normal0_z(range))];
         laz      = atand(lxyz(1)/lxyz(3));
         lel      = atand(lxyz(2)/sqrt(lxyz(1)^2+lxyz(3)^2));         
         raz      = atand(rxyz(1)/rxyz(3));
         rel      = atand(rxyz(2)/sqrt(rxyz(1)^2+rxyz(3)^2));
         
         X(iT,:)  = [laz,lel,raz,rel];  
         
      end
   end
   
   % Create user data
   UserData.stim_on  = target_on;
   UserData.keep     = ~discard;
   UserData.error    = c_error;
   UserData.uloc     = unique(T(~isnan(T(:,1)),:),'rows');
   
   set(fig_handle,'UserData',UserData)     % Store data
   
   % Train network
   scaler         = 50; %max(max(abs(T)));
   nT             = T ./ scaler;
   nX             = X ./ scaler;
      
   % Train network
   net = fitnet(3);                  % Train network with 3 hidden units
   net.divideParam.trainRatio          = 1;
   net.divideParam.testRatio           = 0;
   net.divideParam.valRatio            = 0;

   whos X T
   net = train(net,nX',nT');       % Note the orientation for neural network inputs/outputs
   
   % Store nn
   for iB = 1:size(Data)
      Data(iB).Calibration.net      = net;
      Data(iB).Calibration.scaler   = scaler;
   end
end

function GV	= build_calfigure(GV)
% This function will build a figure for  the analysis of XT mapping ROI for
% calibration
   [GV.gen_cfn,fig_handle] = pb_newfig(GV.gen_cfn);
   set(fig_handle,'defaultLegendAutoUpdate','off');
   set(fig_handle,'WindowKeyPressFcn',@keyPressCal);
   axis square;
   hold on;
   ylim([-50 50]);
   pb_nicegraph;
end

function PL = get_pupil_data(Data)
% this function  will read out the 
   c_pl  = pb_pupillabels;
   
   idc  = [1, 4, 5, 6, 13, 14, 15, 16, 17, 18];
   
   % make pnan
   if ~iseven(length(Data(1,:))); pnan = nan; else; pnan = []; end
   
   for iP = 1:length(idc)
      % insert fields for the relevant pupil data
      pldata               = [Data(idc(iP),:), pnan];                      % add nan for making an evensplit
      PL.(c_pl{idc(iP)})   = nanmean([pldata(1:2:end); pldata(2:2:end)]);  % half the number of samples
   end
end

function keyPressCal(h, eventdata)
% This function will coordinate different keystrokes with functionality

   keystroke   = eventdata.Key;
   D           = h.UserData;
   limits      = xlim;
   current0    = limits(1)+0.5;
   
   switch lower(keystroke)

      % Next Trial
      case {'n','rightarrow'}
         if current0 >= D.stim_on(end); return; end

         clc;
         idx   = find(D.stim_on>current0,1);
         new0  = D.stim_on(idx) - 0.5;
         xlim([new0 new0+2]);

      % Previous Trial
      case {'p','leftarrow'}
         if current0 <= D.stim_on(1); return; end

         clc;
         idx   = find(D.stim_on>=current0,1)-1;
         new0  = D.stim_on(idx) - 0.5;
         xlim([new0 new0+2]);
         
      case {'c'} % correct
         % delete selection
         % dialog
         % insert
         
            
      case {'s'}  % check summary
         
         clc;
         disp('Calibration summary')
         disp(['- total number of trials kept: ' num2str(sum(D.keep)) '/' num2str(length(D.keep))]);
         disp(['- unique locations kept: ' num2str(length(D.uloc)) '/15']);
         disp(D.uloc);
         return;
   end
      
   t = title(['Trial ' num2str(idx)],'color','g');
   if ~D.keep(idx)
      t.Color  = 'r'; 
      
      disp(['Trial ' num2str(idx) ' was discarded for data mapping.']);
      error_msg(D.error(idx));
   else
      disp(['Trial ' num2str(idx) ' was included for data mapping.']);
   end
   
   function error_msg(idc)
      idc     = idc{1};
      c_error =  {'   (EM#1) No saccade was found!'; ... 
                  '   (EM#2) RT too slow!'; ...
                  '   (EM#3) Localization to slow!'; ...
                  '   (EM#4) ROI has to high velocities'; ...
                  '   (EM#5) Confidence is too low!'};
      for iE = 1:length(idc)
         disp(c_error{idc(iE)})
      end
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
      % iterate over blocks
      
      block = GV.gen_blockidx(iB);
      
      % determine fixation point
      [pup_idx,opt_idx]          = get_fixation_idx(Data(iB),T(iB));

      % store timestamps
      P(iB).pupillabs            = getpupil(Data(iB), T(iB), pup_idx, GV);
      P(iB).pupilometry          = getdilation(Data(iB), GV);
      P(iB).optitrack            = getopti(Data(iB), opt_idx,GV);
      P(iB).gaze                 = computegaze(P,Data(iB), T(iB), opt_idx, pup_idx, GV);
      P(iB).chair                = [];
      P(iB).block_idx            = block;
      
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
         azel_eye    = mapeye_norm2azel(block_data);
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

function azel = mapeye_norm2azel(block_data)
   % This function takes the input norm data and converts it to azel using
   % neural network and scaler.

      % Input
      Rx                = block_data.Pup.Data(13,:);
      Ry                = block_data.Pup.Data(14,:);
      Rz                = block_data.Pup.Data(15,:);
      Lx                = block_data.Pup.Data(16,:);
      Ly                = block_data.Pup.Data(17,:);
      Lz                = block_data.Pup.Data(18,:);

      % Simulate network
      net               = block_data.Calibration.net;
      azel              = sim(net,[Lx;Ly;Lz;Rx;Ry;Rz])';                   % NOTE, FLIP BACK ORIENTATION
      azel              = azel .* block_data.Calibration.scaler;           % Scale back for normalization
      
      % compare difference
      x                 = block_data.Pup.Data(4,:);
      y                 = block_data.Pup.Data(5,:);
      z                 = block_data.Pup.Data(6,:);
      [az,el]           = pupil_xyz2azel(x,y,z);
      
      az = az-median(az);
      el = el-median(el);
      
      
      t = block_data.Pup.Timestamps - block_data.Pup.Timestamps(1);
      
      % compare
      cfn = pb_newfig(232);
      
      subplot(121);
      axis square;
      hold on;
      
      plot(t,azel(:,1));
      plot(t,az)
      legend('network','pl')
      
      subplot(122)
      axis square
      hold on
      
      plot(t,azel(:,2));
      plot(t,el)
      legend('network','pl')
      h= pb_fobj(gcf,'type','axes');
      linkaxes(h,'x');
      
      ylim([-50 50]);
      
      
      pb_nicegraph;
end

function azel   = convert_xyz2azel(x,y,z)
   % Convert xyz 2 azel

   RTD = 180/pi;
   azel = zeros(length(x),2);

   p   = sqrt(x.*x + z.*z);
   azel(:,1) = RTD * atan2 (x, sqrt (y.^2 + z.^2));
   azel(:,2) = RTD * atan2(y,z);
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
   
   if isfield(block_data,'Calibration') % check if data is old or new format and contains a calibration field
      
      % check if calibration data is added to field
      if ~isempty(block_data.Calibration)    
         trace = mapeye_norm2azel(block_data);
      else
         trace = compute_pupil_position(block_data,block_time,idx);
      end
         
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

function trace = computegaze(P,block_data, block_time, opt_idx, pup_idx, GV)
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
   
   % Head
   q           = quaternion(block_data.Opt.Data.qw, block_data.Opt.Data.qx, block_data.Opt.Data.qy, block_data.Opt.Data.qz);
   qRot        = q(opt_idx);                        % compute offset
   qHead       = q * qRot';
   Rs          = RotationMatrix(qHead);
   
   % Eye
   normv    = block_data.Pup.Data.gaze_normal_3d(pup_idx:pup_idx+20,:);
   normv    = median(normv);

   GG       = @(A,B) [dot(A,B) -norm(cross(A,B)) 0;    % estimate rotation matrix
                     norm(cross(A,B)) dot(A,B)  0;
                     0              0           1];

   FFi   = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];
   UU    = @(Fi,G) Fi * G * inv(Fi);
   b     = normv'; 
   a     = [0 0 1]';
   Rot   = UU(FFi(a,b), GG(a,b));

   % Rotate
   gaze_normalsrot            = block_data.Pup.Data.gaze_normal_3d * Rot;
   gaze_normalsrotOpt(:,1)    = -interp1(block_time.pupillabs, gaze_normalsrot(:,1), block_time.optitrack,'pchip');
   gaze_normalsrotOpt(:,2)    = interp1(block_time.pupillabs, gaze_normalsrot(:,2), block_time.optitrack,'pchip');
   gaze_normalsrotOpt(:,3)    = interp1(block_time.pupillabs, gaze_normalsrot(:,3), block_time.optitrack,'pchip');

   qEye     = quaternion.rotateutov([0 0 1]', gaze_normalsrotOpt',1,1);
   RsEye    = RotationMatrix(qEye);

   % Compute gaze
   R     = 0.91; a = 1; b = 1; c = 1;
   zcal  = 0;
   xcal  = 0;
   ycal  = 0;

   locspeakxyz = [-0.1257, 0.0195, -0.8426];
   Opt         = block_data.Opt.Data;

   for n = 1:length(qHead)
       locz(n) = locspeakxyz(3) + R + Opt.z(n) - Opt.z(1);
       locx(n) = locspeakxyz(1) + Opt.x(n) - Opt.x(1);
       locy(n) = locspeakxyz(2) + Opt.y(n) - Opt.y(1);

       P(:,n)                 = RsEye(:,:,1,n) * [0;0;1];
       Pcal(:,n)              = P(:,n) + [xcal; ycal; zcal];
       PG(:,n)                = Rs(:,:,1,n) * Pcal(:,n);
       PGs(:,n)               = PG(:,n) * R + -[Opt.x(n)-Opt.x(1); Opt.y(n)-Opt.y(1); Opt.z(n)-Opt.z(1)];
       PGnorms(:,n)           = PGs(:,n) / norm(PGs(:,n));
       MatrixGaze(:,:,1,n)    = Rs(:,:,1,n) * RsEye(:,:,1,n);
       MatrixGazenorms(:,n)   = MatrixGaze(:,3,1,n) / norm(MatrixGaze(:,3,1,n));
   end
   
   switch GV.gaze_method
      case 'new'
         trace       = -convert_quat2azel(qHead.*qEye);                       % Simpele manier om gaze te bepalen, quaternion multiplicatie dus puur beide rotaties combineren
      otherwise
         trace       = -convert_xyz2azel(PGnorms(1,:),PGnorms(2,:),PGnorms(3,:));   % Oude manier om gaze te bepalen, incl translaties
   end
   
   
end

function trace = filter_trace(trace,GV)
   % Function will apply all relevant filters
   
   % Heuristics
   if GV.heuristic_f
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
      trace(:,iO) = filter1(trace(:,iO));
      trace(:,iO) = filter2(trace(:,iO));
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

function trace = heckman_filtering(trace,conf,GV)
   % This function will remove all S sample low confidence data
   % and interpolate them if neighbouring values have high confidence.

   ot = trace;
   
   min_thresh = 0.5;
   max_thresh = 0.8;
   
   conf_bool   = conf < min_thresh;
   
   for iO = 1:size(trace,2)

      for iS = 1:5
         % S sample confidence drops
         
         pattern     = [0, ones(1,iS), 0];
         [a,b]       = xcorr(double(conf_bool),pattern);
         
         peaks       = a == iS;
         idc         = find(peaks==1)-length(conf_bool);

         for iC = 1:length(idc)
            
            prev = trace(idc(iC)-1,iO);
            next = trace(idc(iC)+iS,iO);
            
            % interpolate mean
            if conf_bool(idc(iC)-1)> max_thresh &&  conf_bool(idc(iC)+iS)> max_thresh
               trace(idc(iC):idc(iC)+iS-1,iO) = mean([prev next]);
            end
         end
      end
   end
   
   if GV.gen_debug; visualize_filter(ot,trace,GV,conf); end
end

function trace = sgolay_filtering(trace,GV)
   % Function will implement a set of 2 heuristic filters (Stampe, 1993) 
   
   ot = trace;
   
   %  settings
   order    = 3; 
   framelen = 7;
   
   for iO = 1:size(trace,2)
      trace(:,iO) = sgolayfilt(trace(:,iO),order,framelen);
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
      trace(:,iO) = filtfilt(b,a,trace(:,iO));
   end
   
   if GV.gen_debug; visualize_filter(ot,trace,GV); end
end

function trace = median_filtering(trace,GV)
   % This function will perform a median filter
   
   ot = trace;
   
   %  settings
   window    = 7; 
   
   for iO = 1:size(trace,2)
      trace(:,iO) = medfilt1(trace(:,iO),window);
   end
   
   if GV.gen_debug; visualize_filter(ot, trace, GV); end
end

function visualize_filter(old, new, GV, conf)

   iT  = 1;          % Azimiuth = 1 / Elevation  = 2;
   
   dur      = length(new);
   t        = (1:dur)/GV.gaze_fs;
   
   if nargin < 4; conf = nan(size(new)); end
   
   % Graph data
   cfn = pb_newfig(231);
   sgtitle(pb_sentenceCase(strrep(pb_getfunname('depth',3),'_',' ')));
   
   subplot(2,1,1);
   title('Traces')
   hold on;
   plot(t,old(:,iT));
   plot(t,new(:,iT));  
   plot(t,conf);
   legend('Original','Filtered');
   
   subplot(2,1,2);
   title('Removed');
   hold on;
   plot(t,old(:,iT)-new(:,iT));
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
      T(iB).pupillabs            = lsl_tsPup;
      if ~isempty(Data(block).Opt)
         T(iB).optitrack            = Data(block).Timestamp.Opt;
      else
         T(iB).optitrack         = lsl_tsPup;
      end
      T(iB).stimuli              = Data(block).Timestamp.Stim;
      T(iB).chair                = [];
      T(iB).block_idx            = block;
      
      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.gen_blockidx)) ')']);
   end
   disp(newline)
end

function S = getstims(Data,GV)
   % Function will sort stimulus times/targets
   disp('>> Obtaining stimuli...');

   for iB = 1:length(GV.gen_blockidx)
      % iterate over blocks
      
      block = GV.gen_blockidx(iB);
      
      for iT = 1:length(Data(block).Block_Info.trial)
         % Iterate over trials
                  
         % Store stimuli in right spherical coordinate system
         S(iB).azimuth(iT)       = Data(block).Block_Info.trial(iT).stim(:,GV.stim_targetidx).azimuth;                        % Left is negative / Right is positive
         S(iB).elevation(iT)     = Data(block).Block_Info.trial(iT).stim(:,GV.stim_targetidx).elevation * -1; 
         S(iB).duration(iT)      = Data(block).Block_Info.trial(iT).stim(:,GV.stim_targetidx).offdelay - Data(block).Block_Info.trial(iT).stim(:,1).ondelay;   % Down is positive / Up is negative, so flip elevation from measuring file
         S(iB).frame(iT)         = {'Chair fixed'};
         
         if GV.stim_frames && S(iB).azimuth(iT) == 90    % select world fixed frames // transform azimuth position can only be done after epoching
            S(iB).frame(iT)      = {'World fixed'};
         end
      end
      S(iB).block_idx = block;
      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.gen_blockidx)) ')']);
   end
   disp(newline)
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

      world_fixed_stims    = ismember(Data.stimuli(iB).frame,'World fixed'); % get world fixed targets

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



function Data = filter_pupil(Data, GV)
   
   trace    = [Data.Pup.Data(2,:);Data.Pup.Data(3,:)]';
   conf     = Data.Pup.Data(1,:);
   
   trace    = heckman_filtering(trace,conf,GV);
   trace    = stampe_filtering(trace,GV);
   trace    = bw_filtering(trace,GV);

   % Store filtered data
   Data.Pup.Data(2,:) = trace(:,1)';
   Data.Pup.Data(3,:) = trace(:,2)';
end
