function pb_lightwarning()
% PB_LIGHTWARNING()
%
% PB_LIGHTWARNING()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   import org.zeromq.ZMQ
   
   leds = ledcontroller_pi('dcn-led00','dcn-led01');

   n     = 6;
   s     = ledpattern(n);
   ir    = 50;

   % Sequence needs updating due to new SLC distribution
   seq1  = 0:31;
   
   for iC = 1:n
      if mod(iC,2) == 1
         s(iC).set(seq1,'r');
      end
       s(iC).intensity('r', ir);
   end
   
   leds.write(s);
   
   for iC = 1:n
      leds.trigger;
      if ~iseven(iC); pause(0.1); else; pause(0.1); end
   end
   delete(s);
   delete(leds);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

