function handles = pb_getblock(handles)
% PB_GETBLOCK(HANDLES)
%
% PB_GETBLOCK(HANDLES) retracts block info provided by the exp file. 
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg                  = handles.cfg;
   [block, cfg]         = pb_vReadExp(cfg);

   %% CFG file
   cfg.cfgfname         = which('HumanNH.cfg');
   cfg						= pb_vReadCFG(cfg); % read cfg cfile
   cfg.acqdur				= cfg.humanv1.ADC(1).samples / cfg.humanv1.ADC(1).rate * 1000; % TODO: HumanV1/duration of data acquisition (ms)
   cfg.nsamples			= round(cfg.acqdur/1000*cfg.RZ6Fs); % length data acquisition (samples)
   cfg.nchan				= 3;
   
   %% Correct Block
   block                = pb_vPrimeZ(block,cfg);
   
   handles.block        = block;
   handles.cfg          = cfg;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

