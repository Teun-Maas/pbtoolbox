function [leds,s] = pb_fixled
% PB_LIGHTWARNING()
%
% PB_LIGHTWARNING()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   import org.zeromq.ZMQ
   
   leds  = ledcontroller_pi('dcn-led06','dcn-led07','dcn-led09','dcn-led10');
   
   n     = 2;
   s     = ledpattern(n);
   central_speaker = 10; % central led = 10 (11th starting with 0 from the left)
   for iC = 1:n
      if mod(iC,2) == 1
         s.set(central_speaker,'r');
      end
       s.intensity('r', 50);
   end

   leds.write(s);

end