function Dat = pb_readServo(vs, Dat)
% PB_READSERVO
%
% PB_READSERVO(vs) reads vestibular in- and output profiles and stores
% them.
%
% See also PB_STARTSERVO, PB_SENDSERVO, PB_STOPSERVO, PB_VRUNEXP.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   [sv.vertical,sv.horizontal] = vs.read_profile_sv;
   [pv.vertical,pv.horizontal] = vs.read_profile_pv;
   
   Dat.vestibular_signal.sv   = sv;
   Dat.vestibular_signal.pv   = pv;
   delete(vs);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

