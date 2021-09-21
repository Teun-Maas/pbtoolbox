function Data = pb_vPrepData(varargin)
% PB_VPREPDATA
%
% PB_VPREPDATA(varargin) will preprocess the raw converted data extracted
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   % keyval
   V = varargin;
   GV.cdir           = pb_keyval('cd',V,cd);
   GV.block_idx      = pb_keyval('block',V,'all');
   GV.stim_idx       = pb_keyval('stim',V,1);
   GV.fn             = pb_keyval('fn',V);
   GV.gaze_method    = pb_keyval('gaze',V,'old');
   GV.heuristic_f    = pb_keyval('heuristic_filter',V,1);
   GV.sgolay_f       = pb_keyval('sgolay_filter',V,1);
   GV.median_f       = pb_keyval('median_filter',V,1);
   GV.path           = pb_keyval('path',V,cd);
   GV.store          = pb_keyval('store',V,1);
   GV.discern_frames = pb_keyval('frames',V,1);
   GV.fs             = pb_keyval('fs',V,120);
   GV.acquisition    = pb_keyval('acquisition',V,3);
   GV.epoch          = pb_keyval('epoch',V,1);

   
   % load data
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
         load([path GV.fn]); 
      end
   end
   disp(['>> Data loaded...' newline]);
   
   
   % parse data
   GV       = readkeyval(D,GV);
   S        = getstims(D, GV);                                             % read the stimuli
   T        = gettimestamps(D, GV);                                        % correct the LSL timestamps
   [P,GV]	= getdata(D, T, GV);                                           % obtain the response behaviour
   [T,P]    = getchair(D, T, P, GV);                                       % add chair rotation
   Data      = pb_struct({'stimuli','timestamps','position'},{S,T,P});
   
   % store data
   if GV.epoch; Data = epoch_data(Data, GV); end                             % epoch data
   if GV.store; save_data(Data,GV); end                                     % store data
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


% Some nested functions for readability

function GV = readkeyval(Data,GV)

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
      P(iB).pupilometry          = getdilation(Data(iB), T(iB), pup_idx, GV);
      P(iB).optitrack            = getopti(Data(iB), opt_idx,GV);
      P(iB).gaze                 = computegaze(Data(iB), T(iB), opt_idx, pup_idx, GV);
      P(iB).chair                = [];
      P(iB).block_idx            = block;
      
      disp(['   ' '- block ' num2str(block) ' was parsed (' num2str(iB) '/' num2str(length(GV.block_idx)) ')']);
   end
   disp(newline)
end

function [pup_idx, opt_idx] = get_fixation_idx(block_data,block_time)
   % Function will read, filter, and interpolate eye traces
   
   % optitrack
   qw   	= block_data.Opt.Data.qw; 
   qx   	= block_data.Opt.Data.qx; 
   qy   	= block_data.Opt.Data.qy; 
   qz   	= block_data.Opt.Data.qz;
   q   	= quaternion(qw,qx,qy,qz);
   
   % pupillabs
   x     = block_data.Pup.Data.gaze_normal_3d(:,1);
   y     = block_data.Pup.Data.gaze_normal_3d(:,2);
   z     = block_data.Pup.Data.gaze_normal_3d(:,3);
   
   % azel
   azel_opt       = quat2azelAnnemiek(q);
   azel_eye       = -VCxyz2azel(x,y,z);

   % graph
   cfn = pb_newfig(231);
   hold on;

   plot(block_time.optitrack - block_time.optitrack(1), azel_opt - azel_opt(1,1));
   plot(block_time.pupillabs - block_time.optitrack(1), azel_eye - azel_eye(1,:));
   
   legend('Head azimuth','Head elevation','Eye azimuth','Eye elevation')
   xlim([0 25]);
   ylim([-50 50])
   pb_nicegraph;
   
   [input_x,~] = ginput(1);

   [~, pup_idx] = min(abs(block_time.pupillabs - block_time.optitrack(1) - input_x));
   [~, opt_idx] = min(abs(block_time.optitrack - block_time.optitrack(1) - input_x));
   
   close(cfn);
end

function trace = getpupil(block_data,block_time,idx,GV)
   % Function will read, filter, and interpolate eye traces
   
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
   
   trace       = -quat2azelAnnemiek(qEye);
   trace       = filter_trace(trace,GV);
end

function trace = getdilation(block_data,block_time,idx,GV)
   % Function will read, filter, and interpolate eye traces
   
   % PREPROCESSING  Collects pupil traces from the raw data set and
   %                creates a list that codes for valid and invalid traces
   %                based on the percentage of blinks.
   % LINEAR INT     Fills in gaps created by blinks.
   %                Note that blinks will also create gaps in eye-movement
   %                data. This is not covered in this workshop.
   % MOVING AVE     Moving average filter for smoothing data.
   % AVERAGING      Average over all traces is calculated.
   
   % 1. Preprocessing
   raw_diameter     = block_data.Pup.Data.base_data.diameter_3d;
   time              = (1:length(raw_diameter))/GV.fs; 
   diameter_filt  = raw_diameter;
   
   % find blinks
   blinks_zero             = find(raw_diameter==0);
   diametersz              = size(raw_diameter);
   diameterl               = length(raw_diameter);
   blink_bool              = false(diametersz);
   blink_bool(blinks_zero) = true;
   
   sum(blink_bool)
   window = 5;
   
   % front cut
   for iS = window+1:diameterl-(window+1)
      if blink_bool(iS); blink_bool(iS-window:iS) = true; end
   end
   
   sum(blink_bool)
   
   % back cut
   rev_blink_bool = flipud(blink_bool);
   for iS = window+1:diameterl-(window+1)
      if rev_blink_bool(iS); rev_blink_bool(iS-window:iS) = true; end
   end
   
   blink_bool = flipud(rev_blink_bool);
   sum(blink_bool)
   
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
   
   %trace     = medfilt1(trace,10);
   
%    % Graph
%    pb_newfig(231);
%    hold on;
%    plot(time,raw_diameter)
%    plot(time,trace);
%    
%    pb_nicegraph;
%    axis square;
%    legend('none','interpolate')
   
   trace = diameter_filt;
end

function trace = getopti(block_data,idx,GV)
   % Function will read, filter, and interpolate head traces
   
   % get quaternions
   q           = quaternion(block_data.Opt.Data.qw, block_data.Opt.Data.qx, block_data.Opt.Data.qy, block_data.Opt.Data.qz);
   qRot        = q(idx);                        % compute offset
   
   % convert to azel
   trace       = -quat2azelAnnemiek(q*qRot');   
   trace       = filter_trace(trace,GV);
end

function trace = computegaze(block_data, block_time, opt_idx, pup_idx, GV)
   % Function will compute gaze 
   
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
         trace       = -quat2azelAnnemiek(qHead.*qEye);                       % Simpele manier om gaze te bepalen, quaternion multiplicatie dus puur beide rotaties combineren
      otherwise
         trace       = -VCxyz2azel(PGnorms(1,:),PGnorms(2,:),PGnorms(3,:));   % Oude manier om gaze te bepalen, incl translaties
   end
end

function trace = filter_trace(trace,GV)
   % Function will apply all relevant filters
   
   % Heuristics
   if GV.heuristic_f
      trace = stampe_filtering(trace);
   end
   
   % Smoothen (Savinsky-Golay)
   if GV.sgolay_f 
      trace = sgolay_filtering(trace);
   end
   
   % remove spikes with median filter
   if GV.median_f
      trace = median_filtering(trace);
   end
end


function trace = stampe_filtering(trace)
   % Function will implement a set of 2 heuristic filters (Stampe, 1993) 
   
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
end

function trace = sgolay_filtering(trace)
   % Function will implement a set of 2 heuristic filters (Stampe, 1993) 
   
   %  settings
   order    = 3; 
   framelen = 7;
   
   for iO = 1:size(trace,2)
      trace(:,iO) = sgolayfilt(trace(:,iO),order,framelen);
   end
end

function trace = median_filtering(trace)
   
   %  settings
   window    = 7; 
   
   for iO = 1:size(trace,2)
      trace(:,iO) = medfilt1(trace(:,iO),window);
   end
end



function T = gettimestamps(Data,GV)
   % Function will get timestamps for the different streams
   disp('>> Obtaining LSL timestamps...');
   
   for iB = 1:length(GV.block_idx)
      % iterate over blocks
      
      block = GV.block_idx(iB);
         
      % correct pupil labs
      lsl_tsPupRaw         = Data(block).Timestamp.Pup;
      lsl_tsPup            = Data(block).Pup.Data.timestamp' - Data(block).Pup.Data.timestamp(6) + lsl_tsPupRaw(6);
      diffs                = abs(lsl_tsPup-lsl_tsPupRaw);
      lsl_tsPup(diffs>10)  = lsl_tsPupRaw(diffs>10);

      % store timestamps
      T(iB).pupillabs            = lsl_tsPup;
      T(iB).optitrack            = Data(block).Timestamp.Opt;
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
      
      %  XCorr synchronization
      fsPup          = length(tsVestibularI)/tsVestibularI(end);
      [r,lag]        = xcorr(vestibular_posDI, sensehat_posD);
      [~,I]          = max(abs(r));
      lagDiff        = lag(I)/fsPup;
      tsVestibularI  = tsVestibularI - lagDiff;  

      % store data
      P(iB).chair                = vestibular_posDI;
      T(iB).chair                = tsVestibularI;
      
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
   fname          = [fname];     % Chair = {D,S} % Head = {R,U}
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
      
      Data = correct_world_fixed_azimuth(Data,GV);
   end
end

function Data = correct_world_fixed_azimuth(Data,GV)
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
            Data.stimuli(iB).azimuth(iS)  = -(chair_at_stim_onset);                            % flip the script, brothaaa (- is + en + is -)

         end
      end
   end
end

function save_data(Data, GV)
   % stores the preprocessed data
   fn = strrep(GV.fn,'converted_data_','');
   path = fullfile(cd,'..');
   save([path filesep 'preprocessed_data_' fn],'Data')
end
