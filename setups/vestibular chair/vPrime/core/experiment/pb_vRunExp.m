function pb_vRunExp(handles)
% PB_VRUNEXP
%
% PB_VRUNEXP(handles) forms the core body of experimental paradigms run in 
% the VC, and will loop over the blocks and trials provided by the exp-file.
% Note that PB_VRUNEXP is called from the vPrime GUI, from which it
% receives its experimental handles.
%
% See also PB_VPRIME, PB_VPRIMEGUI.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% INITIALIZE
   %  load & read experiment
   
   %  set debug mode
   debug = true;
   
   %  set handles
   pb_setupShow(handles);
   handles     = pb_gethandles(handles);
   handles     = pb_getblock(handles);
   handles     = pb_createdir(handles);
   handles     = pb_vInitialize(handles, true);
   
   %  set block information
   block       = handles.block;  
   nblocks     = handles.cfg.Blocks;
   Dat         = pb_dataobj(nblocks);
    
   %  initialize recordings
   rc          = pb_runPupil; 
   [ses,str]   = pb_runLSL;
   expTime     = tic;
   
   %% START BLOCK 
   %  iterate experimental blocks 
   
   for iBlck = 1:nblocks
      
      %  set block information
      nTrials          	= length(block(iBlck).trial);
      handles          	= pb_updatecount(handles,'trial','reset');
      [profile,dur]    	= pb_vSignalVC(handles);
      
      %  start recording
      pb_startLSL(ses);
      pb_startPupil(rc);
      
      %  start vestibular chair
      if ~ismac && ~debug     
         pb_vCheckServo;
         
         vs            	= pb_sendServo(profile);
         blockTime    	= tic; 
         pb_startServo(vs);
         pause(6);                                                         % allow vestibular chair to get in sync with input signal
      end

      %% RUN TRIALS
      %  iterate over trials per block
      
      for iTrl = 1:nTrials
         
         %  setup trial
         handles              = pb_vUpdateTrial(handles);
         stim                 = handles.block(iBlck).trial(iTrl).stim;
         handles.cfg          = pb_vClearTrial(stim, handles.cfg); 
         [~, handles.cfg]     = pb_vSetupTrial(stim, handles.cfg);
         trialTime            = tic;
         
         %  run trial
         pb_vRunTrial(handles.cfg.zBus, handles.cfg.trialdur);
         pb_vTraces(handles);       
         
         %  save trial
         handles              = pb_vStoreTrial(handles, profile);
         handles.cfg          = pb_updatecount(handles.cfg,'trial','count');
         toc(trialTime);
      end
      
      %% END BLOCK
      %  stop chair, pupil labs, optitrack and LSL, save data
      
      %  stop vestibular chair
      if ~ismac && ~debug  
         elapsedTime = toc(blockTime);                
         if elapsedTime < dur; pause(dur-floor(elapsedTime)+6); end        % wait untill chair is finished running before disabling.
         pb_stopServo(vs);
         Dat(iBlck) = pb_readServo(vs, Dat(iBlck));
         delete(vs);
      end

      %  stop recording
      pb_stopPupil(rc);
      pb_stopLSL(ses); 
      
      %  store data
      Dat(iBlck).event_data    = str(1).read;
      Dat(iBlck).pupil_labs    = str(2).read;
      Dat(iBlck).optitrack     = str(3).read;
      Dat(iBlck).block_info    = handles.block(iBlck);

      %  update block information
      handles.cfg = pb_updatecount(handles.cfg,'block','count');
   end 
   
   %% CHECK OUT
   %  finalizes experiment, and resets handles.
   
   %  check out experiment
   pb_vEndExp;
   pb_vStoreData(handles.cfg, Dat);
   pb_vInitialize(handles, false);
   
   pb_delobj(ses, rc, str);
   toc(expTime);
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

