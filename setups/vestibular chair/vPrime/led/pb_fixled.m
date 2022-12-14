function [leds,s] = pb_fixled(varargin)
% PB_LIGHTWARNING()
%
% PB_LIGHTWARNING()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   target = pb_keyval('led',varargin,5);
   
   import org.zeromq.ZMQ
   leds  = ledcontroller_pi('dcn-led00');%('dcn-led06','dcn-led07','dcn-led09','dcn-led10');
   
   n     = 2;
   s     = ledpattern(n);
   for iC = 1:n
      if mod(iC,2) == 1
         s(iC).set(target,'r');
      end
       s(iC).intensity('r', 50);
   end
   leds.write(s);
end