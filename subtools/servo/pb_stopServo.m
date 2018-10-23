function pb_stopServo(vs)
% PB_STOPSERVO()
%
% PB_STOPSERVO()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   vs.stop;
   vs.disable;
   
   Dat  = pb_readServo(vs);
   
   delete(vs);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

