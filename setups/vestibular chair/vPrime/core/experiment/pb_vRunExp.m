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
   bool_debug = false;
   
   %  set handles
   pb_setupShow(handles);
   handles     = pb_gethandles(handles);
   handles     = pb_getblock(handles);
   handles     = pb_createdir(handles);
   handles     = pb_vInitialize(handles, true);
   
   %  set block information
   block             = handles.block;  
   nblocks           = handles.cfg.Blocks;
   [Dat,bool_cal]    = pb_setexp(handles);
   
   %  initialize recordings
   rc                      = pb_runPupil; 
   [ses,str, meta_pup]     = pb_runLSL;
   exptime                 = tic;
   
   %% START BLOCK 
   %  iterate experimental blocks 
   
   for iBlck = 1:nblocks
      
      %  set block information
      nTrials                    = length(block(iBlck).trial);
      handles                    = pb_updatecount(handles,'trial','reset');
      [profile,dur,bool_mov]    	= pb_vSignalVC(handles);
      pb_vCheckServo(~bool_debug);
      
      %  start recording
      pb_startLSL(ses);
      pb_startPupil(rc);
      
      %  start vestibular chair
      if ~bool_debug && ~bool_cal && bool_mov
         
         % Start chair
         vs            	= pb_sendServo(profile);
         blocktime    	= tic; 
         
         pb_lightwarning;
         pb_startServo(vs);
         pb_swinglight;       % Central fixation light during in-swing
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
         pb_vRunTrial(handles.cfg.zBus, handles.cfg);
         pb_vTraces(handles);       
         
         %  save trial
         handles              = pb_vStoreTrial(handles, profile);
         handles.cfg          = pb_updatecount(handles.cfg,'trial','count');
         toc(trialTime);
      end
      
      %% END BLOCK
      %  stop chair, pupil labs, optitrack and LSL, save data
      
      %  stop vestibular chair
      if ~bool_debug && ~bool_cal && bool_mov
         elapsedtime = toc(blocktime);                
         if elapsedtime < dur; pause(dur-floor(elapsedtime)+(4*pi)); end        % wait untill chair is finished running before disabling.
         pb_lightwarning;
         pb_stopServo(vs);
         Dat(iBlck) = pb_readServo(vs, Dat(iBlck));
         delete(vs);
      end

      %  stop recording
      pb_stopPupil(rc);
      pb_stopLSL(ses); 
      
      %  store data
      pb_vStoreData(handles, Dat, iBlck, str, meta_pup);

      %  update block information
      handles.cfg = pb_updatecount(handles.cfg,'block','count');
   end
   
   %% CHECK OUT
   %  finalizes experiment, and resets handles.
   
   %  check out experiment
   pb_vEndExp;
   pb_vInitialize(handles, false);
   pb_delobj(ses, rc, str);
   toc(exptime);
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

