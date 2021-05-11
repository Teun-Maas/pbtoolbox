function pb_lightshow(leds)
% PB_LIGHTSHOW
%
% PB_LIGHTSHOW(leds) turns on the spectecular lightshow.
%
% See also PB_VENDEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   import org.zeromq.ZMQ

   n     = 8;
   s     = ledpattern(n);
   ir    = 50;
   ig    = ir;

   % Sequence needs updating due to new SLC distribution
   seq1  = [0:2  5 6 11 12 16:2:31]; %% [0:2:63];
   seq2  = [3 4 7 8 9 10 13 14 17:2:31]; %% [1:2:63];
   
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
      pause(0.35);
   end
   delete(s);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

