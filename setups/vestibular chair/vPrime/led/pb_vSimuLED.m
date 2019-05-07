function led = pb_vSimuLED(led)
% PB_VSIMULED
%
% PB_VSIMULED(led) merges multiple leds with exact same timings but different locations together as one led pattern.
%
% See also PB_VSETUPTRIAL, PB_VRUNTRIAL

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   tmp(1)   = led(1);
   ctmp     = 1;
   for iT = 2:length(led)
      if    led(iT).onevent == led(iT-1).onevent && ...                    % if LED has same on- and offset
            led(iT).offevent == led(iT-1).offevent && ...
            led(iT).ondelay == led(iT-1).ondelay && ...
            led(iT).offdelay == led(iT-1).offdelay
         if led(iT).Z ~= tmp(ctmp).Z                                       % but different location (sanity check)
            tmp(ctmp).Z =  [tmp(ctmp). Z,led(iT).Z];                        
         end
      else
         ctmp = ctmp+1;
         tmp(ctmp) = led(iT);
      end
   end
   led = tmp;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

