function pb_stopServo(vs)
% PB_STOPSERVO
%
% PB_STOPSERVO(vs)  stops and disables the vestibular chair.
%
% See also PB_STARTSERVO, PB_SENDSERVO, PB_READSERVO, PB_VRUNEXP.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   vs.stop;
   vs.disable;
   delete(vs);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

