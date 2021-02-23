function out = pb_vPrepData(varargin)
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
   GV.path           = pb_keyval('path',V,cd);
   GV.store          = pb_keyval('store',V,0);

   % load data
   cd(GV.path);
   if exist(GV.fn,'file')==2
      load(GV.fn);
   else
      [path, prefix, fname, ext] = getfname(GV);                              % get fileparts
      if ~path                                                                % assert
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
   out      = pb_struct({'stimuli','timestamps','position'},{S,T,P});
   
   if GV.store; save_data(out,GV); end
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
         S(iB).azimuth(iT)     = Data(block).Block_Info.trial(iT).stim(:,GV.stim_idx).azimuth;
         S(iB).elevation(iT)   = Data(block).Block_Info.trial(iT).stim(:,GV.stim_idx).elevation;
         S(iB).duration(iT)    = Data(block).Block_Info.trial(iT).stim(:,GV.stim_idx).offdelay-Data(block).Block_Info.trial(iT).stim(:,1).ondelay;
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
   [fname, path]  = pb_getfile('cd',GV.cdir);
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

function save_data(Data, GV)
   % stores the preprocessed data
   fn = strrep(GV.fn,'converted_data_','');
   save(['preprocessed_data_' fn],'Data')
end