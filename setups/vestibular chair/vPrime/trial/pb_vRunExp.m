function pb_vRunExp(varargin)
% PB_VRUNEXP(varargin)
%
% PB_VRUNEXP() forms the core body of experimental paradigms in the VC, and 
% will loop over the trials.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   %% INITIALIZE
   %  load & read experiment
   
   experiment  = pb_vReadExp;
   ntrials     = length(experiment);
   
   
   
   %% BODY
   %  iterate experiment
   
   for iTrial = 1:ntrials
      
      pb_vClearTrial();
      pb_vRecordData();
      pb_vRunTrial(experiment(iTrial));

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

