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
      AZEL                    = [Data.epoch(iB).AzGazeEpoched; Data.epoch(iB).ElGazeEpoched];

      fwrite(fid,AZEL,'float');
      fclose(fid);

      fn_csv = fname;
      VC2csv(fn_csv,fs,samples,1:length(Data.epoch(iB).AzGazeEpoched)/samples);

      if ~isfile(fn_csv(1:end-3)) == 1
          pa_sacdet;
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

