function vs = pb_startServo(vs)
% PB_STARTSERVO
%
% PB_STARTSERVO(vs) enables and starts the vestibular chair.
%
% See also PB_SENDSERVO, PB_STOPSERVO, PB_READSERVO, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

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

