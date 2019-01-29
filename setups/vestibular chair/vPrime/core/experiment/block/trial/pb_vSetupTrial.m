function [stim, cfg] = pb_vSetupTrial(stim,cfg)
% PB_VSETUPTRIAL
%
% PB_VSETUPTRIAL(stim, cfg) sets up experimental parameters for Trial.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   %% Set TDT parameters
   selled		= strcmpi({stim.modality},'LED');
   selsnd		= strcmpi({stim.modality},'sound');
   
      %% LED
   if any(selled)
      led		= stim(selled);
      nled	= numel(led);
      % 	nled = 2
      n		= nled*2; % LEDs need to be turned on and off
      s		= ledpattern(n);

      cnt		= 0;
      for iLED = 1:nled
         % TDT RZ6
         % Set timing information on LEDs
         % Note that in RZ6 circuit, event 1 = start of experiment
         str1 = ['eventLED' num2str(2*iLED-1)];
         str2 = ['eventLED' num2str(2*iLED)];
         cfg.RZ6_1.SetTagVal(str1,led(iLED).onevent+1);
         cfg.RZ6_1.SetTagVal(str2,led(iLED).offevent+1);
         
         str1 = ['delayLED' num2str(2*iLED-1)];
         str2 = ['delayLED' num2str(2*iLED)];
         cfg.RZ6_1.SetTagVal(str1,led(iLED).ondelay+1);
         cfg.RZ6_1.SetTagVal(str2,led(iLED).offdelay+1);
      
      
         % PLC
         if isfield(led,'colour')
            col = led(iLED).colour;
         else
            col = 1;
         end
         
         for ii	= 1:2
            cnt = cnt+1;
            if ii==1
               s(cnt).set(led(iLED).Z,cfg.ledcolours{col},1);
               s(cnt).intensity(cfg.ledcolours{col},led(iLED).intensity); % Vestibular range 0-100;
            else
               s(cnt).set(led(iLED).Z,cfg.ledcolours{col},0);
            end
         end
      end
      
      stim(find(selled,1)).ledhandle = ledcontroller_pi('dcn-led06','dcn-led07'); %% CORRECT THESE LOCATIONS
      stim(find(selled,1)).ledhandle.write(s);
   end

   %% Acquisition
   if any(selacq)
      acq	= stim(selacq);
      cfg.RZ6_1.SetTagVal('eventAcq',acq.onevent+1);
      cfg.RZ6_1.SetTagVal('delayAcq',acq.ondelay);
      cfg.RZ6_1.SetTagVal('acqSamples',cfg.nsamples); % amount of DA samples
   end

   %% Sound

   if any(selsnd)
      snd		= stim(selsnd);
      nsnd     = numel(snd);
      for sndIdx = 1:nsnd
         sndsetup	= cfg.lookup(snd(sndIdx).Z+1,2:4);
         switch sndsetup(1)
            case 1
               maxSamples = setSound(snd(sndIdx),cfg,'RP2_1');
            case 2
               maxSamples = setSound(snd(sndIdx),cfg,'RP2_2');
         end
      end
   end

   if ~exist('maxSamples','var')
      maxSamples = 0;
   end
   cfg.maxSamples = maxSamples;

   %% Wait for?
   % search for latest event with longest offset
   % which should also include sampling period and sound although this does not have an
   % offevent
   
   e				= [stim.offevent];
   d				= [stim.offdelay];
   mxevent			= max(e);
   sel				= ismember(e,mxevent);
   mxdelay			= max([d(sel) ceil(1000*cfg.nsamples./cfg.RZ6Fs) ]);

   %%
   cfg.RZ6_1.SetTagVal('eventWait',mxevent+1);
   cfg.RZ6_1.SetTagVal('delayWait',mxdelay);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

