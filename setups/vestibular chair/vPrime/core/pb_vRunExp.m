function pb_vRunExp(handles)
% PB_VRUNEXP(varargin)
%
% PB_VRUNEXP() forms the core body of experimental paradigms in the VC, and 
% will loop over the trials.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% INITIALIZE
   %  load & read experiment
   
   pb_setupShow(handles);
   handles        = pb_gethandles(handles);
   handles        = pb_getblock(handles);
   
   
   %[block, cfg]  	= pb_vReadExp(handles);
  
   handles        = pb_createdir(handles);
   handles        = pb_vInitialize(handles,true);
   
   % NOT SURE WETHER THIS REMAINS	%  %  %  %  %  %  %  %  % %
   nblocks       	= handles.cfg.Blocks;                             % %
   nTotTrials    	= handles.cfg.Trials;                             % %
                                                            % %
   bDat(nblocks)     = struct('v',[],'h',[]);               % %                             % pre-allocate data for speed
   tDat(nTotTrials)  = struct;                              % %
   % NOT SURE WETHER THIS REMAINS   %  %  %  %  %  %  %  %  % % 
   
   %% BODY
   %  Iterate experiment
   
   block = handles.block;
      
   for iBlck = 1:nblocks
      % Runs blocks of trials with a vestibular condition
      
      nTrials                       = length(block(iBlck).trial);
      [bDat(iBlck),profile,dur]    = pb_vSignalVC(handles,block,iBlck);       % reads, checks, creates & plots vestibular signals
      
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
         cnt = handles.cfg.trialnumber;
         updateTrial(handles, iTrial, cnt, nTotTrials);
         %pb_vSetupTrial(block(iBlock).trial(iTrial).stim,cfg);
            
         pb_vClearTrial(cnt,iBlck,iTrial);
         handles = pb_vRecordData(handles);
         
         %pb_vRunTrial(experiment(iTrial));
         %pb_vFeedbackGUI();
         pb_vTraces(handles);
         pause(1)
         handles.cfg.trialnumber    = handles.cfg.trialnumber+1;
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
      handles.cfg.blocknumber	= handles.cfg.blocknumber+1;
   end 
   %% CHECK OUT
   pb_vInitialize(handles,false);
   
   % THIS CAN BE MOVED ELSEWHERE TO CLEAN UP CODE
   handles.cfg.recording = num2str(str2double(handles.cfg.recording)+1,'%04d');
   set(handles.editRec,'string',handles.cfg.recording)
   % THIS CAN BE MOVED ELSEWHERE TO CLEAN UP CODE 
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

