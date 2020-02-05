function D = pb_convertdata(fn,varargin)
% PB_CONVERTDATA
%
% PB_CONVERTDATA() converts and bulks all datafiles for each block in the vestibular setup together
%
% See also PB_ZIPBLOCKS

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   %  Prep Data
   load(fn);
   datl        = length(dat);
   D           = struct('Pup',[],'Opt',[],'Sensehat',[],'VC',[],'Timestamp',[]);
   D(datl).Pup = [];

   fn          = pb_fsplit(fn);
   
   %% Get Data
   %  Convert Pupil & Optitrack data, synchronize and store.

   for iSig = 1:datl
      %  Loop over pb_data

      %  temp variables
      pup            = dat(iSig).pupil_labs;
      pup.Data       = lsl_pupil_convert2soa(pup);

      opt            = dat(iSig).optitrack;
      opt.Data       = lsl_optitrack_convert2soa(opt);

      sensehat       = dat(iSig).sensehat;

      D(iSig).Pup       = pup;
      D(iSig).Opt       = opt;
      D(iSig).Sensehat  = mat2struct(sensehat.Data,struct_sensehat_fields);
      D(iSig).VC        = dat(iSig).vestibular_signal;

      D(iSig).Timestamp.Pup   = lsl_correct_pupil_timestamps(pup);
      D(iSig).Timestamp.Opt   = lsl_correct_lsl_timestamps(opt);
      D(iSig).Timestamp.Sense = lsl_correct_lsl_timestamps(sensehat);
      
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
