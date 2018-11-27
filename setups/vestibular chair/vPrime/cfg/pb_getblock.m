function handles = pb_getblock(handles)
% PB_GETBLOCK
%
% PB_GETBLOCK(handles) retracts block info provided by the exp file. 
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
   
   %% Timing
   cfg.trialdur         = getdurations(block);                             % sets trialdur

   handles.block        = block;
   handles.cfg          = cfg;
end

function td = getdurations(block)
   % extracts trial and block dur 
   stimarr = [];
   
   blocksz = length(block);
   for bidx = 1:blocksz
      trialsz = length(block(bidx).trial);
      for tidx = 1:trialsz
         stimarr(end+1) = block(bidx).trial(tidx).stim(end).offdelay;
      end
   end
   td = ceil(max(stimarr)/500)/2;                                          % rounds up max trial duration with .5 precision
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


