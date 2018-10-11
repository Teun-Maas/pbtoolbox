function pb_vRunExp(handles)
% PB_VRUNEXP(HANDLES)
%
% PB_VRUNEXP(HANDLES) forms the core body of experimental paradigms run in 
% the VC, and will loop over the blocks and trials provided by the exp-file.
%
% See also PB_VPRIME, PB_VPRIMEGUI.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% INITIALIZE
   %  load & read experiment
   
   debug = true;
   experimentTime = tic;
   
   pb_setupShow(handles);
   handles	= pb_gethandles(handles);
   handles 	= pb_getblock(handles);
   handles 	= pb_createdir(handles);
   handles	= pb_vInitialize(handles,true);
   
   block          = handles.block;  
   nblocks        = handles.cfg.Blocks;
   bDat(nblocks)  = struct('v',[],'h',[]);
   
   %% CORE BODY 
   %  iterate experiment
   
   for iBlck = 1:nblocks
      % Runs blocks of trials with a vestibular condition
      
      nTrials                       = length(block(iBlck).trial);
      handles                       = updateCount(handles,'trial','reset');
      [bDat(iBlck),profile,dur]     = pb_vSignalVC(handles);               % reads, checks, creates & plots vestibular signals
      
      %  START CHAIR
      if ~ismac && ~debug                                        
         send_profile(profile); 
         
         vs = vs_servo;
         vs.enable;        pause(1); 
         vs.start;         blockTime = tic;
      end

      %%  RUN TRIALS
      for iTrl = 1:nTrials
         % Runs all trials within one block
         trialTime = tic;
         
         updateTrial(handles);
         stim				= handles.block(iBlck).trial(iTrl).stim;
         handles.cfg    = pb_vClearTrial(stim,handles.cfg); 
         
         [stim, cfg]    = pb_vSetupTrial(stim, handles.cfg);
         
         pb_vRunTrial(handles.cfg, stim);
         % pb_trialclean(stim, cfg);

         % pb_vFeedbackGUI();          %% <-- MAYBE NOT NECESSAIRY?
         pb_vTraces(handles);       
         handles        = pb_vStoreData(handles, bDat);
         handles        = updateCount(handles,'trial','count');            % update trial
         toc(trialTime);
      end
      
      %  STOP CHAIR
      if ~ismac && ~debug  
         elapsedTime = toc(blockTime);                 
         if elapsedTime < dur; pause(dur-floor(elapsedTime)); end          % wait untill chair is finished running before disabling.

         vs.stop;
         vs.disable;
         delete(vs);
         
         [sv,pv]  = read_profile;
         Dat.sv   = sv;
         Dat.pv   = pv;
      end
      handles = updateCount(handles,'block','count');
   end 
   %% CHECK OUT
   pb_vInitialize(handles,false);
   toc(experimentTime);
end

%-- Feedback functions --%
function updateTrial(handles)
   % Updates the trial information to the GUI
   tn = handles.cfg.trialnumber;
   handles.figure1.Name = ['vPrime - ' num2str(tn(2)) '/' num2str(handles.cfg.Trials) ' Trials'];       % counting title

   str = num2str(tn(1),'%03d');                                                                       % blocktrial
   set(handles.Tn,'string',str)
end

function handles = updateCount(handles,varargin)
   % Updates the count of trialnumber and block number during experiment
   
   cfg = handles.cfg;
   
   trial = pb_keyval('trial',varargin);
   block = pb_keyval('block',varargin);
   
   if ~isempty(trial)
      switch trial
         case 'count'
            cfg.trialnumber      = cfg.trialnumber+1;
         case 'reset'
            cfg.trialnumber(1)   = 1;
      end
   end
   
   if ~isempty(block)
      switch block
         case 'count'
            cfg.blocknumber      = cfg.blocknumber+1;
      end
   end
   handles.cfg = cfg;
end

%-- Run VC functions --%
function send_profile(profile)
   % writing profile to servo
   
   vs    = vs_servo;
   vs.write_profile(profile.v,profile.h);
   
   delete(vs);
end

function [sv,pv] = read_profile
   % read profile
   
   vs    = vs_servo;
   
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

