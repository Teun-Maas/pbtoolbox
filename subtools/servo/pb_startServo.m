function vs = pb_startServo
% PB_STARTSERVO()
%
% PB_STARTSERVO()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   vs = vs_servo;
   vs.enable;
   pause(1);
   vs.start;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

