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

   leds = ledcontroller_pi('dcn-led00','dcn-led01'); %('dcn-led06','dcn-led07','dcn-led09','dcn-led10');
   pb_lightshow(leds);

   %% Mop up
   % Turn off the lights
   
   t = ledpattern;
   leds.write(t);
   leds.trigger;
   
   pb_delobj(leds,t);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

