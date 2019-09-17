function pb_lightwarning()
% PB_LIGHTWARNING()
%
% PB_LIGHTWARNING()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   import org.zeromq.ZMQ
   
   leds = ledcontroller_pi('dcn-led06','dcn-led07','dcn-led09','dcn-led10');

   n     = 4;
   s     = ledpattern(n);
   ir    = 50;
   ig    = ir;

   % Sequence needs updating due to new SLC distribution
   seq1  = [0:9 fliplr(16:1:63)]; %% [0:2:63];
   seq2  = []; %% [1:2:63];
   
   for iC = 1:n
      if mod(iC,2) == 0
         s(iC).set(seq1,'r');
      else 
         s(iC).set(seq2,'g');
      end
       s(iC).intensity('r', ir);
       s(iC).intensity('g', ig);
   end
   
   leds.write(s);
   
   for iC = 1:n
      leds.trigger;
      if isodd(iC); pause(0.3); else; pause(0.15); end
   end
   delete(s);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

