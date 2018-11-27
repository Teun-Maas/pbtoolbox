function vs = pb_sendServo(profile)
% PB_SENDSERVO
%
% PB_SENDSERVO(profile) sends profile signals to servo.
%
% See also PB_STARTSERVO, PB_STOPSERVO, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   vs   = vs_servo;
   vs.write_profile(profile.v,profile.h);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

