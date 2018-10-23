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
   
   %  set debug mode
   debug = true;
   
   %  set handles
   pb_setupShow(handles);
   handles	= pb_gethandles(handles);
   handles 	= pb_getblock(handles);
   handles 	= pb_createdir(handles);
   handles	= pb_vInitialize(handles,true);
   
   %  set block information
   block          = handles.block;  
   nblocks        = handles.cfg.Blocks;
   Dat(nblocks)   = struct('vestibular_signal',[],'PL',[],'OT',[],'LSL',[]);
   
   %  initialize recordings
   rc             = pb_runPupil; 
   [ses,streams]  = pb_runLSL('ot',false);
   experimentTime = tic;
   
   %% START BLOCK 
   %  iterate experimental blocks 
   
   for iBlck = 1:nblocks
      %  Runs blocks of trials with a vestibular condition
      
      %  set block information
      nTrials  	= length(block(iBlck).trial);
      handles  	= updateCount(handles,'trial','reset');
      
      %  store signal data
      [sig,profile,dur]             = pb_vSignalVC(handles);               % reads, checks, creates & plots vestibular signals
      Dat(iBlck).vestibular_signals = sig;
      
      %  start recording
      pb_startLSL(ses);
      pb_startPupil(rc);
      
      %  start vestibular chair
      if ~ismac && ~debug      
         pb_sendServo(profile);
         vs = pb_startServo;
         pause(6);   blockTime   = tic;                                    % allow vestibular chair to get in sync with input signal
      end

      %% RUN TRIALS
      %  iterate over trials per block
      
      for iTrl = 1:nTrials
         % Runs all trials within one block
  
         % setup trial
         updateTrial(handles);
         stim                 = handles.block(iBlck).trial(iTrl).stim;
         handles.cfg          = pb_vClearTrial(stim,handles.cfg); 
         [stim, handles.cfg]  = pb_vSetupTrial(stim, handles.cfg);
         trialTime            = tic;
         
         pb_vRunTrial(handles.cfg, stim);
         pb_vTraces(handles);       
         
         %handles        = pb_vStoreData(handles, bDat);
         handles        = updateCount(handles,'trial','count');
         toc(trialTime)
      end
      
      %% END BLOCK
      %  stop chair, pupil labs, optitrack and LSL, save data
      
      %  stop vestibular chair
      if ~ismac && ~debug  
         elapsedTime = toc(blockTime);                
         if elapsedTime < dur; pause(dur-floor(elapsedTime)); end          % wait untill chair is finished running before disabling.

         pb_stopServo(vs);
         Dat =    pb_readServo;
      end

      %  stop recording
      pb_stopPupil(rc);
      pb_stopLSL(ses); 
      
      %  store data
      if ~exist('LSL_Dat','var')
         LSL_Data  = {};
      end
      
      LSL_Dat.ev_dat = streams(1).read;
      LSL_Dat.pl_dat = streams(2).read;
      % LSL_Dat.ot_dat = str(3).read;
      
      % TODO: SAVE LSL DATA
      % save(lsl_file, 'LSL_Dat');
      
      %  update block information
      handles = updateCount(handles,'block','count');
   end 
   
   %% CHECK OUT
   %  finalizes experiment, and resets handles.
   
   %  check out experiment
   pb_vEndExp(handles.cfg);
   pb_vInitialize(handles,false);
   toc(experimentTime)
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
% function send_profile(profile)
%    % writing profile to servo
%    
%    vs    = vs_servo;
%    vs.write_profile(profile.v,profile.h);
% end

% function Dat = read_profile(vs)
%    % read profile
%    
%    [sv.vertical,sv.horizontal] = vs.read_profile_sv;
%    [pv.vertical,pv.horizontal] = vs.read_profile_pv;
%    
%    delete(vs);
%    
%    Dat.sv   = sv;
%    Dat.pv   = pv;
% end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

