function pb_vEndExp
% PB_VENDEXP
%
% PB_VENDEXP ends experiment, displays lightshow and turns lights off.
%
% See also PB_VRUNEXP.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   stim.X            = 0;
   stim.Y            = 0;
   stim.channel		= [];
   stim.detect       = [];
   stim.event        = [];
   stim.intensity    = 60;
   stim.modality     = 'sound';
   stim.offdelay     = 0;
   stim.offevent     = 0;
   stim.ondelay      = 0;
   stim.onevent      = 0;
   stim.matfile      = 'rehandel.mat';
   stim.azimuth      = 3.5084e-15;
   stim.elevation    = -3.5084e-15;
   stim.Z            = 10;
   stim.ledhandle    = [];
   stim.parameters	= 99;

   %% Let's run some LEDs instead

   pb_lightshow;

   %% Mop up
   % Turn off the lights
   
   t = ledpattern;
   leds.write(t);
   leds.trigger;
   
   delete([leds,t]);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

