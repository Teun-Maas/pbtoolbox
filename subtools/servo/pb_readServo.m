function D = pb_readServo(vs)
% PB_READSERVO()
%
% PB_READSERVO()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   [sv.vertical,sv.horizontal] = vs.read_profile_sv;
   [pv.vertical,pv.horizontal] = vs.read_profile_pv;
   
   delete(vs);
   
   D.sv   = sv;
   D.pv   = pv;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

