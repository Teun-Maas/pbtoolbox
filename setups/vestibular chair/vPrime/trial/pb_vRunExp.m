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
   
   [block, cfg]  	= pb_vReadExp(expinfo.expfile);
   cnt            = pb_vInitialize(h,true);
   
   nblocks       	= cfg.Blocks;
   nTotTrials    	= cfg.Trials;
   
   bDat(nblocks)     = struct('v',[],'h',[]);                                             % pre-allocate data for speed
   tDat(nTotTrials)  = struct;
   
   %% BODY
   %  Iterate experiment
      
   for iBlock = 1:nblocks
      % Runs blocks of trials with a vestibular condition
      
      nTrials                       = length(block(iBlock).trial);
      [bDat(iBlock),profile,dur]    = pb_vSignalVC(h,block,iBlock);       % reads, checks, creates & plots vestibular signals
      
      %% START CHAIR
      if ~ismac                                                            % in order to debug at my own laptop withouth getting servo related errors.                                           
         send_profile(profile); 
         vs = vs_servo;
         vs.enable;  
         pause(1); 
         vs.start;   
         tic;
      end

      %% RUN TRIALS
      for iTrial = 1:nTrials
         % Runs all trials within one block
         cnt = cnt+1; 
         updateTrial(h, iTrial, cnt, nTotTrials);
            
         pb_vClearTrial(cnt,iBlock,iTrial);
         pb_vRecordData(expinfo,cnt);
         %pb_vRunTrial(experiment(iTrial));
         %pb_vFeedbackGUI();
         pb_vTraces(h);
         pause(1);
         
      end
      
      %% STOP CHAIR
      if ~ismac
         elapsedTime = toc;                 
         if elapsedTime < dur; pause(dur-floor(elapsedTime)); end          % wait untill chair is finished running before disabling.

         vs.stop;
         vs.disable;
         delete(vs);
         
         [sv,pv]  = read_profile;
         Dat.sv   = sv;
         Dat.pv   = pv;
      end
   end 
   %% CHECK OUT
   pb_vInitialize(h,false);
end

function updateTrial(h, iTrial, cnt, nTotTrials)
   % Updates the trial information to the GUI
   
   h.figure1.Name = ['vPrime - ' num2str(cnt) '/' num2str(nTotTrials) ' Trials'];      % counting title
   
   tn = num2str(iTrial,'%03d');                                                        % blocktrial
   set(h.Tn,'string',tn)
end

%-- Run VC functions --%
function send_profile(profile)
   disp('writing profile to servo...');
   
   vs   = vs_servo;
   vs.write_profile(profile.v,profile.h);
   delete(vs);
end

function [sv,pv] = read_profile
   disp('read profile...');
   
   vs=vs_servo;
   [sv.vertical,sv.horizontal] = vs.read_profile_sv;
   [pv.vertical,pv.horizontal] = vs.read_profile_pv;
   delete(vs);
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

