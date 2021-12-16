function pb_swinglight
% PB_SWINGLIGHT
%
% PB_SWINGLIGHT will turn on light cross during swing time
%
% See also PB_VPRIME

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

   seq1  = [0 1 2 5 6];
   [leds,s] = pb_fixled('led',seq1);
   leds.trigger;
   pause(1.5*pi);            % allow vestibular chair to get in sync with input signal
   leds.trigger;
   pb_delobj(leds, s);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

