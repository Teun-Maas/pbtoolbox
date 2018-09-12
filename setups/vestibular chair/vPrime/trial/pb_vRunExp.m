function pb_vRunExp(expinfo,h)
% PB_VRUNEXP(varargin)
%
% PB_VRUNEXP() forms the core body of experimental paradigms in the VC, and 
% will loop over the trials.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   %% INITIALIZE
   %  load & read experiment
   
   [block, cfg]    = pb_vReadExp(expinfo.expfile); % struct
   nblocks         = cfg.Blocks;
   nTotTrials      = cfg.Trials;
   

   
   
   %% BODY
   %  iterate experiment
   
   for iBlock = 1:nblocks
      nTrials  = length(block(iBlock).trial);   
      signal   = block(iBlock).signal;          
      
      pb_vSafety(signal);                       % Checks for safe vestibular parameters!! 

      
      for iTrial = 1:nTrials
      %pb_vClearTrial();
      %pb_vRecordData();
      %pb_vRunTrial(experiment(iTrial));
      %pb_vFeedbackGUI();
   end
   
   
   %% CHECK OUT
   %  store data
   
   
   
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

