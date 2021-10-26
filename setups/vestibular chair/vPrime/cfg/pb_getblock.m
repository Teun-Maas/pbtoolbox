function handles = pb_getblock(handles)
% PB_GETBLOCK
%
% PB_GETBLOCK(handles) retracts block info provided by the exp file. 
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% INITIALIZE
   %  Get handles and read experiment.
   
   cfg                  = handles.cfg;
   [block, cfg]         = pb_vReadExp(cfg);

   %% FILTER PARAMETERS
   %  Will select the appriopriate filter setting for GWN sounds, default is expname else
   %  soundParameters.mat is loaded.
   
   fn   	= fullfile(cfg.expdir,cfg.expfname);
   fn  	= fcheckext(fn,'mat');
   par 	= 'parameters';
   if exist(fn,'file')
      load(fn,par);
   else
      load(which('soundParameters.mat'),par)
   end
   cfg.parameters    = parameters;
   
   %% CFG FILE
   %  Will extract the correct cfg settings. Current default is set to
   %  HumanNH.cfg. 
   
   cfg.cfgfname    	= which('HumanNH.cfg');
   cfg					= pb_vReadCFG(cfg);  % read cfg cfile
   cfg.acqdur			= cfg.humanv1.ADC(1).samples / cfg.humanv1.ADC(1).rate * 1000; % TODO: HumanV1/duration of data acquisition (ms)
   cfg.nsamples		= round(cfg.acqdur/1000*cfg.RZ6Fs); % length data acquisition (samples)
   cfg.nchan			= 3;
   
   %% CHECK-OUT
   %  Define trial duration, correct stimulus positions, and store handles. 

   if isempty(cfg.trialdur)
      cfg.trialdur    	= getdurations(block);
   end
   
   handles.block    	= pb_vPrimeZ(block,cfg);
   handles.cfg      	= cfg;
end

function td = getdurations(block)
   %  Extracts trial and block dur 
   stimarr = [];
   
   blocksz = length(block);
   for bidx = 1:blocksz
      trialsz = length(block(bidx).trial);
      for tidx = 1:trialsz
         stimarr(end+1) = block(bidx).trial(tidx).stim(end).offdelay;
      end
   end
   td    = ceil(max(stimarr)/500)/2;                                          % rounds up max trial duration with .5 precision
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


