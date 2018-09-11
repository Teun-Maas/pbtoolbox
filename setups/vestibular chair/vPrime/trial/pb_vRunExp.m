function pb_vRunExp(Exp,h)
% PB_VRUNEXP(varargin)
%
% PB_VRUNEXP() forms the core body of experimental paradigms in the VC, and 
% will loop over the trials.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   %% INITIALIZE
   %  load & read experiment
   
   [experiment, cfg]    = pb_vReadExp(Exp.expfile); % struct
   nblocks              = cfg.nblocks;
   nTotTrials           = cfg.ntrials;
   

   
   
   %% BODY
   %  iterate experiment
   
   for iBlock = 1:nblocks
      nTrials  = Experiment(iBlock).info.ntrials; % ntrials in block
      signal   = Experiment(iBlock).info.veststim; % IMPORTANT: veststim has to be a struct with hor and vert component!

      
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

