function pb_vSacDet(Data,varargin)
% PB_VPREPDATA
%
% PB_VPREPDATA(varargin) will preprocess the raw converted data extracted
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

   %  Keyval
   fs          = pb_keyval('fs',varargin,120);
   duration    = pb_keyval('duration',varargin,3);
   start_idx   = pb_keyval('start_idx',varargin,1);
   stop_idx    = pb_keyval('stop_idx',varargin);
   cdir        = pb_keyval('cd',varargin,cd);   
   sd          = pb_keyval('sd',varargin,0.005);
   samples     = duration * fs;
   
   % get filename
   cd(cdir);
   l     = dir('../preprocessed*.mat');
   fn    = l(1).name;
   
   %  Correct for different end positions
   if isempty(stop_idx) || stop_idx > length(Data.epoch)
      stop_idx = length(Data.epoch);
   end
   
   for iB = start_idx:stop_idx

      % Saving calibrated data
      fname                   = fcheckext(['sacdet_' fn(14:end-4) '_block_' num2str(iB,'%03.f') '_azel'] ,'.hv');
      fid                     = fopen(fname,'w','l');
      
      % 0. get data
      az       = Data.epoch(iB).AzGazeEpoched;
      el       = Data.epoch(iB).ElGazeEpoched;
      
      % 1. smooth
      saz       = medfilt1(az,7); saz(1) = az(1);
      sel       = medfilt1(el,7); sel(1) = el(1);
      
      % 2. diff
      vaz      = gradient(saz,1./fs);
      vel      = gradient(sel,1./fs);
      svaz     = pa_gsmooth(vaz,fs,sd);
      svel     = pa_gsmooth(vel,fs,sd);
      
      % 3. filter
      svaz_f      = medfilt1(svaz,200); svaz_f(1) = svaz(1);
      svaz_f      = svaz-svaz_f;
      svel_f     = medfilt1(el,200); svel_f(1) = svel(1);
      svel_f      = svel-svel_f;
      
      % 4. integrate
      paz         = cumsum(svaz_f)/fs;      
      pel         = cumsum(svel_f)/fs;
     
      % 5. correct drift
      paz         = detrend(paz,1);
      pel         = detrend(pel,1); 
      
      AZEL = [paz; pel];

      fwrite(fid,AZEL,'float');
      fclose(fid);

      VC2csv(fname,fs,samples,1:length(Data.epoch(iB).AzGazeEpoched)/samples);

      if ~isfile(fname(1:end-3)) == 1
          pa_sacdet(fname,det_criteria);
          pause;
      end
   end
   
   % convert sac 2 mat
   l = dir('sacdet_*.hv');
   for iL = 1:length(l)
      fn    = l(iL).name(1:end-3);
      pa_sac2mat([fn '.hv'],[fn '.csv'],[fn '.sac']);
   end
end

function det = det_criteria
%  Generate default detection criterea for sacdet

    det.velocityon             	= 50;       % deg/s
    det.velocityoff           	= 50;       % deg/s
    det.smooth                 	= 0.01;
    det.duration                	= 10;       % ms
    det.amplitude              	= 2;        % deg
    det.start                  	= 0;        % ms, starting-time of detection
    det.end                     	= 2500;    	% ms, end-time of detection
    det.acc                    	= 0;
end
