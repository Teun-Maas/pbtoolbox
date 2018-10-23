function pb_sendServo(profile)
% PB_SENDSERVO()
%
% PB_SENDSERVO()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   vs   = vs_servo;
   vs.write_profile(profile.v,profile.h);
   delete(vs);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

