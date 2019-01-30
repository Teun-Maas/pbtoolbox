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
      for iLed = 1:nled
         %  TDT RZ6
         %  Set timing information on LEDs
         %  Note that in RZ6 circuit, event 1 = start of experiment
         str1 = ['eventLED' num2str(2*iLed-1)];
         str2 = ['eventLED' num2str(2*iLed)];
         cfg.RZ6_1.SetTagVal(str1,led(iLed).onevent+1);
         cfg.RZ6_1.SetTagVal(str2,led(iLed).offevent+1);
         
         str1 = ['delayLED' num2str(2*iLed-1)];
         str2 = ['delayLED' num2str(2*iLed)];
         cfg.RZ6_1.SetTagVal(str1,led(iLed).ondelay+1);
         cfg.RZ6_1.SetTagVal(str2,led(iLed).offdelay+1);
      
         %  PLC
         if isfield(led,'colour')
            col = led(iLed).colour;
         else
            col = 1;
         end
         
         for ii	= 1:2
            cnt = cnt+1;
            if ii==1
               s(cnt).set(led(iLed).Z,cfg.ledcolours{col},1);
               s(cnt).intensity(cfg.ledcolours{col},led(iLed).intensity); % Vestibular range 0-100;
            else
               s(cnt).set(led(iLed).Z,cfg.ledcolours{col},0);
            end
         end
      end
      
      stim(find(selled,1)).ledhandle = ledcontroller_pi('dcn-led06','dcn-led07');
      stim(find(selled,1)).ledhandle.write(s);
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

   %% Wait
   
   ev             = stim.offevent;
   de             = stim.offdelay;
   mxevent			= max(ev);
   sel				= ismember(ev,mxevent);
   mxdelay			= max([de(sel) ceil(1000*cfg.nsamples./cfg.RZ6Fs) ]);
   
   cfg.RZ6_1.SetTagVal('eventWait',mxevent+1);
   cfg.RZ6_1.SetTagVal('delayWait',mxdelay);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

