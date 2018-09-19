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
   set(h.buttonRun,     'Enable', 'off')
   set(h.buttonLoad,    'Enable', 'off')
   
   % Ready feedback plots
   axes(h.signals); cla;   
   axes(h.eTrace); cla; h.eTrace.YLim = [0 300]; h.eTrace.XLim = [0 2.5]; 
   axes(h.hTrace); cla; h.hTrace.YLim = [0 300]; h.hTrace.XLim = [0 2.5];
   
   %% BODY
   %  Iterate experiment
   
   pause(2);
   
   for iBlock = 1:nblocks
      % Runs blocks of trials with a vestibular condition
      nTrials  = length(block(iBlock).trial);
      
      %% RUN CHAIR
      %  read signals
      signal(1)   = block(iBlock).signal.ver;
      signal(2)   = block(iBlock).signal.hor;     
      signal      = pb_vSafety(signal); 
      
      % run chair
      bDat(iBlock).signal = pb_vRunVC(signal); 
      
      %% PLOT SIGNALS
      %  set axis and plot signals
      axes(h.signals); cla; hold on; 
      h.signals.YLim = [-50 50];
      
      plot(bDat(iBlock).signal.v.t,bDat(iBlock).signal.v.x,'k');
      plot(bDat(iBlock).signal.h.t,bDat(iBlock).signal.h.x,'b');
      
      updateBlock(h,iBlock,signal);
   
      for iTrial = 1:nTrials
         % Runs all trials within one block
         cnt = cnt+1; 
         updateTrial(h, iTrial, cnt, nTotTrials, tDat);
            
         pb_vClearTrial(cnt,iBlock,iTrial);
         pb_vRecordData(expinfo,cnt);
         %pb_vRunTrial(experiment(iTrial));
         %pb_vFeedbackGUI();
         pause(1);
         
         %% PLOT TRACES
         %  head trace
         axes(h.hTrace); hold on;
         ws = 20; b  = (1/ws)*ones(1,ws); a  = 1;
         
         x  = 0:.05:2.5; 
         y  = randi(300,1,length(x)) .* tukeywin(length(x), 2)';
         y  = filter(b,a,y) .* tukeywin(length(x),1)';
         plot(x,y);
         
         %  eye trace
         axes(h.eTrace); hold on;    
         ws = 20; b  = (1/ws)*ones(1,ws); a  = 1;
         
         x  = 0:.05:2.5; 
         y  = randi(300,1,length(x)) .* tukeywin(length(x), 2)';
         y  = filter(b,a,y) .* tukeywin(length(x),1)';
         plot(x,y);
         
         %  highlight active traces
         te = pb_fobj(h.eTrace,'Type','Line'); 
         th = pb_fobj(h.hTrace,'Type','Line'); 
         col = pb_selectcolor(10,5);
         
         for iT = 1:length(th)
            switch iT 
               case length(th)
                  th(iT).Color = col(10,:);
                  te(iT).Color = col(10,:);
               otherwise 
                  th(iT).Color = col(1,:);
                  te(iT).Color = col(1,:);
            end
         end
      end
      pause(1)
   end 
   %% CHECK OUT
   disp([newline newline 'Experiment finished!'])

   set(h.buttonClose,   'Enable', 'on');
   set(h.buttonRun,     'Enable', 'on');
   set(h.buttonLoad,    'Enable', 'on');
end

function updateBlock(h, iBlock, signal)
   % Updates the block information to the GUI
   
   bn = pb_sentenceCase(num2str(iBlock,'%03d'));                           % count block
   set(h.Bn,'string',bn);
   
   vs = ['V = ' pb_sentenceCase(signal(1).type) ...                        % VC stim
      ', H = ' pb_sentenceCase(signal(2).type)];
   set(h.Vs,'string',vs);
end

function updateTrial(h, iTrial, cnt, nTotTrials, Dat)
   % Updates the trial information to the GUI
   
   h.figure1.Name = ['vPrime - ' num2str(cnt) '/' num2str(nTotTrials) ' Trials'];      % counting title
   
   tn = num2str(iTrial,'%03d');                                                        % blocktrial
   set(h.Tn,'string',tn)
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

