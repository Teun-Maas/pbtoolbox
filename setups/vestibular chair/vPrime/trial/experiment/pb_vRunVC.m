function Dat = pb_vRunVC(signal)
% PB_VRUNVC()
%
% PB_VRUNVC()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% CREATE SIGNALS
   vSignal = pb_vCreateSignal(1, signal(1).duration, 10, 1, signal(1).type);
   hSignal = pb_vCreateSignal(1, signal(2).duration, 10, 1, signal(2).type);
 
   Dat.v.x = vSignal.x .* signal(1).amplitude;
   Dat.v.t = (0:1:length(Dat.v.x)-1)/10;
   Dat.h.x = hSignal.x .* signal(2).amplitude;
   Dat.h.t = (0:1:length(Dat.h.x)-1)/10;
   
   %% RUN CHAIR

   profile.v = Dat.v.x;
   profile.h = Dat.h.x;

   %% excecute profile
   
   dur = max([signal(1).duration signal(2).duration]);
   send_profile(profile); 
   run_profile(dur);
   %[sv,pv] = read_profile;

   %% save data
   Dat.signal = [1 1];
   Dat.amplitude = [signal(1).amplitude signal(2).amplitude];
   %Dat.sv = sv;
   %Dat.pv = pv;

end

function send_profile(profile)
   disp('writing profile to servo');
   
   %vs   = vs_servo;
   %vs.write_profile(profile.v,profile.h);
   %delete(vs);
end

function [sv,pv]=read_profile
   %vs=vs_servo;
   %[sv.vertical,sv.horizontal] = vs.read_profile_sv;
   %[pv.vertical,pv.horizontal] = vs.read_profile_pv;
   %delete(vs);
end

function run_profile(dur)
   %vs=vs_servo;
   %vs.enable;
   %pause(1);
   %vs.start;
   %disp('started');
   %pause(dur+5);
   %vs.stop;
   %disp('stopped');
   %vs.disable;
   %disp('done');
   %delete(vs);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

