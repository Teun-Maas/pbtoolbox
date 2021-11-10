function D = pb_convertdata(fn)
% PB_CONVERTDATA
%
% PB_CONVERTDATA(fname) converts and bulks all datafiles for each block in the vestibular setup together
%
% See also PB_ZIPBLOCKS

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   %  Prep Data
   load(fn);
   datl        = length(dat);
   D           = struct('Pup',[],'Opt',[],'Sensehat',[],'VC',[],'Timestamp',[],'Calibration',[]);
   D(datl).Pup = [];

   [fn,path]   = pb_fsplit(fn);
   l           = dir([path filesep 'calibration_*.mat']);                  % Look for calibration data
   
   %% Get Data
   %  Convert Pupil & Optitrack data, synchronize and store.

   for iSig = 1:datl
      %  Loop over pb_data

      %  temp variables
      pup            = dat(iSig).pupil_labs;
      
      if isa(pup.Data,'cell')
         pup.Data       = lsl_pupil_convert2soa(pup);
      end

      if ~isempty(dat.optitrack)
         opt               = dat(iSig).optitrack;
         opt.Data          = lsl_optitrack_convert2soa(opt);
         
         D(iSig).Opt             = opt;
         D(iSig).Timestamp.Opt   = lsl_correct_lsl_timestamps(opt);
      else

         D(iSig).Timestamp.Opt   = lsl_correct_pupil_timestamps(pup);
         D(iSig).Opt.Data.qw   	= zeros(size(D(iSig).Timestamp.Opt)); 
         D(iSig).Opt.Data.qx   	= zeros(size(D(iSig).Timestamp.Opt));
         D(iSig).Opt.Data.qy   	= zeros(size(D(iSig).Timestamp.Opt)); 
         D(iSig).Opt.Data.qz   	= zeros(size(D(iSig).Timestamp.Opt));
      end
      
      event             = dat(iSig).event_data;
      sensehat          = dat(iSig).sensehat;

      D(iSig).Pup       = pup;
      D(iSig).Sensehat  = mat2struct(sensehat.Data,pb_struct_sensehat);
      D(iSig).VC        = dat(iSig).vestibular_signal;

      D(iSig).Timestamp.Pup   = lsl_correct_pupil_timestamps(pup);
      D(iSig).Timestamp.Sense = lsl_correct_lsl_timestamps(sensehat);
      
      % If no event data is being stored, event_data is not the right object type (lsl_data).
      if ~isempty(dat(iSig).event_data)
         D(iSig).Timestamp.Stim  = lsl_correct_lsl_timestamps(event);
      end
      
      % If there is calibration data store it
      if ~isempty(l)
         cal                        = load([l(1).folder filesep l(1).name]);     % Load the calibration file if it is stored within the folder containing the block data
         D(iSig).Calibration.Data   = cal.dat;
      end
            
      dat(iSig).block_info.fn = fn;
      D(iSig).Block_Info      = dat(iSig).block_info;
   end
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
