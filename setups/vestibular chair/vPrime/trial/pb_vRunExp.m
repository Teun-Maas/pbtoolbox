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
   
   [block, cfg]  	= pb_vReadExp(expinfo.expfile);     % struct
   nblocks       	= cfg.Blocks;
   nTotTrials    	= cfg.Trials;
   
   cnt               = 0;
   bDat(nblocks)     = struct;                        % pre-allocate data for speed
   tDat(nTotTrials)  = struct;
   
   set(h.buttonClose,   'Enable', 'off')                % avoid closing GUI during executing run function     
   set(h.buttonRun,     'Enable', 'off');
   set(h.buttonLoad,    'Enable', 'off') 
   %% BODY
   %  Iterate experiment
   
   for iBlock = 1:nblocks
      % Runs blocks of trials with a vestibular condition
      nTrials  = length(block(iBlock).trial);
      
      signal(1)   = block(iBlock).signal.ver;  
      signal(2)   = block(iBlock).signal.hor;     
      
      updateBlock(h,iBlock,signal);
      pb_vSafety(signal);                             % Checks for safe vestibular parameters!! 
      
      bDat(iBlock).signal = pb_vRunVC(signal);
      
      % Plot signals
      h.signals; cla; hold on; col = pb_selectcolor(2,2);
      plot(bDat(iBlock).signal.v.t,bDat(iBlock).signal.v.x,'Color',col(1,:)); 
      plot(bDat(iBlock).signal.h.t,bDat(iBlock).signal.h.x,'Color',col(2,:));
   
      for iTrial = 1:nTrials
         % Runs all trials within one block
         cnt = cnt+1; 
         updateTrial(h, iTrial, cnt, nTotTrials, tDat);
            
         %pb_vClearTrial();
         %pb_vRecordData();
         %pb_vRunTrial(experiment(iTrial));
         %pb_vFeedbackGUI();
         pause(.1);
      end
      pause(2)
   end 
   %% CHECK OUT
   %  store data
   
   set(h.buttonClose,   'Enable', 'on');
   set(h.buttonRun,     'Enable', 'on');
   set(h.buttonLoad,    'Enable', 'on');
end

function updateBlock(h, iBlock, signal)
   % Updates the block information to the GUI
   
   bn = pb_sentenceCase(num2str(iBlock,'%03d'));                           % count block
   set(h.Bn,'string',bn);
   
   vs = ['V = ' pb_sentenceCase(signal(1).type) ...                       % VC stim
      ', H = ' pb_sentenceCase(signal(2).type)];
   set(h.Vs,'string',vs);
end

function updateTrial(h, iTrial, cnt, nTotTrials, Dat)
   % Updates the trial information to the GUI
   
   h.figure1.Name = ['vPrime - ' num2str(cnt) '/' num2str(nTotTrials) ' Trials'];    % counting title
   
   tn = num2str(iTrial,'%03d');                                            % blocktrial
   set(h.Tn,'string',tn)
   
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

