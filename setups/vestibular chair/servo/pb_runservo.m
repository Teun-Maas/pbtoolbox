function D = pb_runservo(profile,varargin)
% PB_RUNSERVO()
%
% PB_RUNSERVO()  ...
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

   % send_profile
   vs = vs_servo;
   vs.write_profile(profile.horizontal, profile.vertical);
   
   %run_profile(dur);      

   vs.enable;
   pause(1);
   vs.start;
   disp('started');
   pause(dur+5);
   vs.stop;
   disp('stopped');
   vs.disable;
   disp('done');
   
   %[sv,pv] = read_profile;
   [sv,~]=  vs.read_profile_sv;
   [pv,~]=  vs.read_profile_pv;
   delete(vs);
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

