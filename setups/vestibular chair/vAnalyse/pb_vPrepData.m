function Data = pb_vPrepData(varargin)
% PB_VPREPDATA
%
% PB_VPREPDATA(varargin) will preprocess the raw converted data extracted
%
% See also PB_ZIPBLOCKS, PB_CONVERTDATA

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl
   
   % Parse parameters
   GV.cdir           = pb_keyval('cd', varargin, cd);
   GV.block_idx      = pb_keyval('block', varargin, 'all');
   GV.stim_idx       = pb_keyval('stim', varargin, 1);
   GV.fn             = pb_keyval('fn', varargin);
   GV.gaze_method    = pb_keyval('gaze', varargin, 'old');
   GV.heuristic_f    = pb_keyval('heuristic_filter', varargin, 1);
   GV.sgolay_f       = pb_keyval('sgolay_filter', varargin, 0);
   GV.median_f       = pb_keyval('median_filter', varargin, 0);
   GV.butter_f       = pb_keyval('butter_filter', varargin, 1);
   GV.path           = pb_keyval('path', varargin, [cd filesep '..']);
   GV.store          = pb_keyval('store', varargin, 1);
   GV.discern_frames = pb_keyval('frames', varargin, 1);
   GV.fs             = pb_keyval('fs', varargin, 200);
   GV.acquisition    = pb_keyval('acquisition', varargin, 3);
   GV.epoch          = pb_keyval('epoch', varargin, 1);
   GV.debug          = pb_keyval('debug', varargin, true);
   GV.chrono_pup     = pb_keyval('chrono',varargin, true);

   % Load and clean data
   [D,GV]         = load_data(GV);                                         % Will load the data
   [D,GV]         = clean_data(D,GV);                                      % filters, and removes any inconsentensies from raw data
   
   % Parse data
   S        = getstims(D, GV);                                             % read the stimuli
   T        = gettimestamps(D, GV);                                        % correct the LSL timestamps
   [P,GV]	= getdata(D, T, GV);                                           % obtain the response behaviour
   [T,P]    = getchair(D, T, P, GV);                                       % add chair rotation
   Data      = pb_struct({'stimuli','timestamps','position'},{S,T,P});
   
   % store data
   if GV.epoch; Data = epoch_data(Data, GV); end                           % epoch data
   if GV.store; save_data(Data,GV); end                                    % store data
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function [D,GV] = load_data(GV)
   cd(GV.path);
   if exist(GV.fn,'file')==2
      load(GV.fn);
   else
      [path, prefix, fname, ext] = getfname(GV);                           % get fileparts
      if ~path                                                             % assert
         disp('>> pb_vPrepData aborted as no file was selected.');
         return
      else
         GV.fn = [prefix fname ext];
         load([path GV.fn],'D'); 
      end
   end
   disp(['>> Data loaded...' newline]);
end

function [D,GV] = clean_data(Data,GV)

   % Read keyval
   GV       = readkeyval(Data,GV);                                            % convert some GV inputs
   
   % Temporally restructure and filter pupil data
   Data     = chronolize_pupil(Data,GV);
   Data     = filter_pupil(Data,GV);
   
   % Calibrate
   if isfield(Data,'Calibration')
         D  = train_calibration(Data, GV);                                     % train calibration network
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

function GV = readkeyval(Data,GV)
% Read and correct keyvals

   % Fix blocks
   if ~isnumeric(GV.block_idx)
      switch GV.block_idx
         case 'all'
            GV.block_idx = 1:length(Data);
         otherwise
            GV.block_idx = 1;
      end
   end
end

function Data = chronolize_pupil(Data,GV)
   % This function will restructure the pupil labs data in chronocological
   % order.
   
   if GV.chrono_pup     % Make sure this is true
   
      % Get timestamps
      ts       = Data.Timestamp.Pup;
      [~,idx]  = sort(ts);
      ts       = ts(idx);
      
      % Correct pupil Data and timestamps
      Data.Pup.Data(:,idx);
      Data.Pup.Timestamps(idx);
      Data.Timestamp.Pup = ts;
      
      % Correct pupil time corrections
      for iC = 1:length(Data.Pup.TimeCorrection)
         idx_c    = Data.Pup.TCindex(iC);
         new_idx  = find(idx == idx_c);
         Data.Pup.TCindex(iC) = new_idx;
      end
      
      % Resort them
      [~,idx] = sort(Data.Pup.TCindex);
      Data.Pup.TCindex           = Data.Pup.TCindex(idx);
      Data.Pup.TimeCorrection    =  Data.Pup.TimeCorrection(idx);
   end
end

function Data = train_calibration(Data,GV)
% This will train neural network to map pupillabs norm position to real
% world azimuth/elevation values.

   
   Cal = Data(1).Calibration.Data;

   if isempty(Cal); return; end % Check if data exists
   
   % Prep calibration data
   calsz    = [length(Cal.block_info.trial) 2];
   plx      = Cal.pupil_labs.Data(2,:);                       % normposx
   ply      = Cal.pupil_labs.Data(3,:);                       % normposy
   
   %trace = filter_trace([plx; ply]',GV);
   trace = [plx; ply]';
   plx_f = trace(:,1)';
   ply_f = trace(:,2)';
   
   ts_pup   = lsl_correct_lsl_timestamps(Cal.pupil_labs);
   %ts_pup   = lsl_correct_pupil_timestamps(Cal.pupil_labs)
   ts_ei    = [];
   if ~isempty(Cal.event_in)
   ts_ei    = lsl_correct_lsl_timestamps(Cal.event_in);
   end
   ts_eo    = lsl_correct_lsl_timestamps(Cal.event_out);

   ts_ei    = ts_ei - ts_eo(1);
   ts_pup   = ts_pup - ts_eo(1);                                           % synch with respect to event data
   ts_eo    = ts_eo - ts_eo(1);
      
   idx_p    = find(ts_pup>0,1);
   idx_t    = find(ts_pup>ts_eo(end));
   ts_pup   = ts_pup(idx_p:idx_t);
   plx_f    = plx_f(idx_p:idx_t);
   ply_f    = ply_f(idx_p:idx_t);
   
   ts_eoc   = ts_ei;
   %ts_eoc   = ts_eo(3:3:end)+0.1;

   % remove dubble kliks
   ts_bool  = true(size(ts_ei));
   
   for iT = 2:length(ts_ei)
      if ts_ei(iT) - ts_ei(iT-1) < 1
         ts_bool(iT) = false;
      end
   end
   ts_ei = ts_ei(ts_bool);
   
   % preallocate training data
   inputs   = zeros(calsz);
   targets  = zeros(calsz);
   
   if GV.debug
      col = pb_selectcolor(2,2);

      est_x = [0.1, 0.48, 0.87, 0.13, 0.16, 0.48, 0.47, 0.86, 0.82, 0.24, 0.28, 0.46, 0.455, 0.75, 0.65];
      est_y = [0.4, 0.46, 0.30, 0.60, 0.28, 0.68, 0.30, 0.53, 0.20, 0.84, 0.20, 0.88, 0.150, 0.80, 0.10];
      
      cfn = pb_newfig(231); 
      colormap winter

      title('Calibration (trial = 1')
      hold on;
      axis square;
      xlim([0 1]);
      ylim([0 1]);
      xlabel('X-coordinate');
      ylabel('Y-coordinate');
      
      pb_nicegraph;

      c     = linspace(1,10,length(plx_f));
      alpha = 0.2;
      scatter(plx_f,ply_f,15,c,'filled','markerfacealpha',alpha,'markeredgealpha',alpha); %,'markerfacecolor', col(1,:),'markeredgecolor',col(1,:),'markerfacealpha',0.2);
      plot(est_x,est_y,'o','color',col(2,:),'Markersize',30,'linewidth',2);
      legend('Gaze','AutoUpdate',false);
   end
   
   for iT = 1:length(inputs)

      % Get the index for median x and y input positions
      ts_buttonpress = ts_ei(iT);
      idx_pup        = find(ts_pup >= ts_buttonpress,1);
      range          = idx_pup:(idx_pup + floor(GV.fs/10));
      med_x          = median(plx_f(range));
      med_y          = median(ply_f(range));
      
      % Store inputs
      inputs(iT,1) = med_x;
      inputs(iT,2) = med_y;
     
      % get targets from block info
      targets(iT,1) = Cal.block_info.trial(iT).stim.azimuth;
      targets(iT,2) = Cal.block_info.trial(iT).stim.elevation;
      
      if GV.debug
         el = Cal.block_info.trial(iT).stim.elevation;
         az = Cal.block_info.trial(iT).stim.azimuth;
         
         
         title(['Calibration (trial = ' num2str(iT) ')']); 
         scatter(plx_f(range),ply_f(range),'markerfacecolor',col(1,:),'markeredgecolor',col(1,:),'markerfacealpha',0.9);
         plot(med_x,med_y,'x','color',col(1,:),'markersize',30,'linewidth',5);
         plot(est_x(iT),est_y(iT),'o','color',col(1,:),'markersize',30,'linewidth',3);
         
         
         pb_delete;
         pb_delete;
         pb_delete
      end
   end
   
   remove_poor_data = [2, 4, 5, 6, 7, 8, 9, 10, 12, 14]; 
   %remove_poor_data = 1:15;
   inputs   = inputs(remove_poor_data,:);
   targets  = targets(remove_poor_data,:);
   
   scaler         = max(max(abs(targets)));
   ntargets     	= targets ./ scaler;
      
   % Train network
   net = feedforwardnet(3);                  % Train network with 3 hidden units
   net.divideParam.trainRatio = 1;
   net.divideParam.testRatio = 0;
   net.divideParam.valRatio = 0;

   net = train(net,inputs',ntargets');       % Note the orientation for neural network inputs/outputs
   
   % Store nn
   for iB = 1:size(Data)
      Data(iB).Calibration.net      = net;
      Data(iB).Calibration.scaler   = scaler;
   end
end

% Parsing functions
function [P,GV] = getdata(Data, T, GV)
   % Function will get timestamps for the different streams
   disp('>> Obtaining data streams...');
   
   for iB = 1:length(GV.block_idx)
      % iterate over blocks
      
      block = GV.block_idx(iB);
      
      % determine fixation point
      [pup_idx,opt_idx] = get_fixation_idx(Data(iB),T(iB));

      % store timestamps
      P(iB).pupillabs            = getpupil(Data(iB), T(iB), pup_idx, GV);
      P(iB).pupilometry          = getdilation(Data(iB), GV);
      P(iB).optitrack            = getopti(Data(iB), opt_idx,GV);
      P(iB).gaze                 = computegaze(P,Data(iB), T(iB), opt_idx, pup_idx, GV);
      P(iB).chair                = [];
      P(iB).block_idx            = block;
      
      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.block_idx)) ')']);
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
      normx             = block_data.Pup.Data(2,:);
      normy             = block_data.Pup.Data(3,:);

      % Simulate network
      net               = block_data.Calibration.net;
      azel              = sim(net,[normx; normy])';                        % NOTE, FLIP BACK ORIENTATION
      azel              = azel .* block_data.Calibration.scaler;           % Scale back for normalization
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
   time              = (1:length(raw_diameter))/GV.fs; 
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
   trace    = highpass(trace,'Fc',0.1,'Fs',GV.fs)';
	trace    = lowpass(trace,'Fc',2,'Fs',GV.fs)';
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
   if GV.sgolay_f 
      trace = sgolay_filtering(trace,GV);
   end
   
   % Butterworth low-pass
   if GV.butter_f                %(cut-off: 20-25, order: 5, see table 2 Mack et al 2017)
      trace = bw_filtering(trace,GV);
   end
   
   % remove spikes with median filter
   if GV.median_f
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

   if GV.debug; visualize_filter(ot,trace,GV); end
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
   
   if GV.debug; visualize_filter(ot,trace,GV,conf); end
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
   
   if GV.debug; visualize_filter(ot, trace, GV); end
end

function trace = bw_filtering(trace,GV)
   % See Mack et al 2017 for best filter settings: 200Hz + high noise -->
   % 20-25 fc, 5th order.
   
   ot       = trace;
   
   order    = 5;
   fc       = 20;
   
   [b,a]    = butter(order,fc/(GV.fs/2));
   
   for iO = 1:size(trace,2)
      trace(:,iO) = filtfilt(b,a,trace(:,iO));
   end
   
   if GV.debug; visualize_filter(ot,trace,GV); end
end

function trace = median_filtering(trace,GV)
   % This function will perform a median filter
   
   ot = trace;
   
   %  settings
   window    = 7; 
   
   for iO = 1:size(trace,2)
      trace(:,iO) = medfilt1(trace(:,iO),window);
   end
   
   if GV.debug; visualize_filter(ot, trace, GV); end
end

function visualize_filter(old, new, GV, conf)

   iT  = 1;          % Azimiuth = 1 / Elevation  = 2;
   
   dur      = length(new);
   t        = (1:dur)/GV.fs;
   
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
   
   for iB = 1:length(GV.block_idx)
      % iterate over blocks
      
      block = GV.block_idx(iB);
         
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
      
      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.block_idx)) ')']);
   end
   disp(newline)
end

function S = getstims(Data,GV)
   % Function will sort stimulus times/targets
   disp('>> Obtaining stimuli...');

   for iB = 1:length(GV.block_idx)
      % iterate over blocks
      
      block = GV.block_idx(iB);
      
      for iT = 1:length(Data(block).Block_Info.trial)
         % iterate over trials
                  
         % store stimuli
         S(iB).azimuth(iT)       = Data(block).Block_Info.trial(iT).stim(:,GV.stim_idx).azimuth;
         S(iB).elevation(iT)     = Data(block).Block_Info.trial(iT).stim(:,GV.stim_idx).elevation;
         S(iB).duration(iT)      = Data(block).Block_Info.trial(iT).stim(:,GV.stim_idx).offdelay - Data(block).Block_Info.trial(iT).stim(:,1).ondelay;
         S(iB).frame(iT)         = {'Chair fixed'};
         
         if GV.discern_frames && S(iB).azimuth(iT) == 90    % select world fixed frames // transform azimuth position can only be done after epoching
            S(iB).frame(iT)      = {'World fixed'};
         end
      end
      S(iB).block_idx = block;
      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.block_idx)) ')']);
   end
   disp(newline)
end

function [T,P] = getchair(Data, T, P, GV)
   % Function will sort chair times & targets
   disp('>> Inserting chair data...');
      
   % globals
   fs    = 9.95;
   
   for iB = 1:length(GV.block_idx)
      % iterate over blocks
      
      block = GV.block_idx(iB);
      
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

      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.block_idx)) ')']);
   end
   disp(newline)
end

% Read functions
function [path, prefix, fname, ext] = getfname(GV)
   % Function selects data 
   
   % select dir
   [fname, path]  = pb_getfile('cd',[GV.cdir filesep '..'],'ext','converted_data_.mat'); % Open the converted data
   if ~isa(fname,'char')
      prefix   = false; 
      ext      = false;
      return
   end
   
   % store fileparts
   [ext, fname]   = pb_fext(fname);
   prefix         = fname(1:15);       % 'converted_data_'
   fname          = fname(16:end);
end

function Data = epoch_data(Data,GV)
   % function will automatically epoch your data into chuncks as suggested
   % by the acquisition information
   
   samples     = GV.fs*GV.acquisition - 1;

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
      
      ind         = GV.stim_idx;
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
   
   
   if GV.discern_frames
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

function save_data(Data, GV)
   % stores the preprocessed data

   fn       = strrep(GV.fn,'converted_data_','');
   fpath    = fullfile(cd);
   
   save([fpath filesep 'preprocessed_data_' fn],'Data')
end
