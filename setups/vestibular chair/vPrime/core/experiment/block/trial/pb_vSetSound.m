function pb_vSetSound(snd,cfg,RZ6str)
% PB_VSETSOUND
%
% PB_VSETSOUND(snd,cfg,RZ6str) sets sound parameters for modulated GWNs.
%
% See also PB_VPRIME, PB_VRUNEXP,PB_VSETUPTRIAL

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   Z           = snd.Z;
   %warning('Are you using calibrated attenuation values???');
   atten       = max(snd.intensity,0); % the 'intensity' parameter is the attenuation
   sndsetup    = cfg.lookup(Z+1,2:3);

   %% Filter properties
   % The filter properties are set in the parameter file, which has the same
   % name as the exp file, but with the extensenion .mat
   
   id  	= snd.parameters;
   par	= cfg.parameters(id);
   snd	= addfields(snd,par);

   %% 

   cfg.RZ6_1.SetTagVal('eventSND',snd.onevent+1);
   cfg.RZ6_1.SetTagVal('delaySND',snd.ondelay);
   cfg.RZ6_1.SetTagVal('soundDur',snd.duration);

   cfg.RZ6_1.SetTagVal('AttenuationA',atten); % Note: sounds are set for 2 channels, but only 1 sound is played (see MUX below)
   cfg.RZ6_1.SetTagVal('AttenuationB',atten);

   cfg.RZ6_1.SetTagVal('freq1',snd.filter1.freq);
   cfg.RZ6_1.SetTagVal('bw1',snd.filter1.bw);
   cfg.RZ6_1.SetTagVal('type1',snd.filter1.type);
   cfg.RZ6_1.SetTagVal('enable1',snd.filter1.enable);

   cfg.RZ6_1.SetTagVal('freq2',snd.filter2.freq);
   cfg.RZ6_1.SetTagVal('bw2',snd.filter2.bw);
   cfg.RZ6_1.SetTagVal('type2',snd.filter2.type);
   cfg.RZ6_1.SetTagVal('enable2',snd.filter2.enable);


   MUX(cfg.(RZ6str),sndsetup(1),sndsetup(2));
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
