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

   for iS = 1:datl
      %  Loop over pb_data

      %  temp variables
      pup            = dat(iS).pupil_labs;
      
      if isa(pup.Data,'cell')
         pup.Data       = lsl_pupil_convert2soa(pup);
      end

      if ~isempty(dat.optitrack)
         
         opt               = dat(iS).optitrack;
         opt.Data          = lsl_optitrack_convert2soa(opt);
         
         D(iS).Opt             = opt;
         D(iS).Timestamp.Opt   = lsl_correct_lsl_timestamps(opt);
         
      else
         
         D(iS).Timestamp.Opt 	= lsl_correct_lsl_timestamps(pup);
         D(iS).Opt.Data.qw   	= zeros(size(D(iS).Timestamp.Opt)); 
         D(iS).Opt.Data.qx   	= zeros(size(D(iS).Timestamp.Opt));
         D(iS).Opt.Data.qy   	= zeros(size(D(iS).Timestamp.Opt)); 
         D(iS).Opt.Data.qz   	= zeros(size(D(iS).Timestamp.Opt));
      end
      
      event_in                = dat(iS).event_in;
      event_out               = dat(iS).event_out;
      sensehat                = dat(iS).sensehat;

      D(iS).Pup               = pup;
      D(iS).Sensehat          = mat2struct(sensehat.Data,pb_struct_sensehat);
      
      % Fill VC
      D(iS).VC                      	= dat(iS).vestibular_signal;
      if isempty(D(iS).VC)
         D(iS).VC.sv.horizontal        = zeros(1,2000); 
         D(iS).VC.sv.vertical          = zeros(1,2000);          
         D(iS).VC.pv.horizontal        = zeros(1,2000); 
         D(iS).VC.pv.vertical          = zeros(1,2000); 
      end

      D(iS).Timestamp.Pup     = lsl_correct_lsl_timestamps(pup);
      D(iS).Timestamp.Sense   = lsl_correct_lsl_timestamps(sensehat);
      
      % If no event data is being stored, event_data is not the right object type (lsl_data).
      if ~isempty(dat(iS).event_in); D(iS).Timestamp.Trig      = lsl_correct_lsl_timestamps(event_in); end
      if ~isempty(dat(iS).event_out); D(iS).Timestamp.Stim     = lsl_correct_lsl_timestamps(event_out); end
      
      % If there is calibration data store it
      if ~isempty(l)
         cal                        = load([l(1).folder filesep l(1).name]);     % Load the calibration file if it is stored within the folder containing the block data
         D(iS).Calibration.Data     = cal.dat;
      end
            
      dat(iS).block_info.fn = fn;
      D(iS).Block_Info      = dat(iS).block_info;
   end
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
