function [safe,threshold] = pb_vCheckVelSignal(signal)
% PB_VCHECKVELSIGNAL
%
% PB_VCHECKVELSIGNAL(signal) checks if the velocity profile of the signal
% exceeds a certain threshold.
%
% See also PB_VCREATESIGNAL, PB_VSAFETY

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   safe        = true;
   threshold   = 110;       % Should be 60 d/s: DO NOT CHANGE!! 
   SR          = 10;
   
   mvel = SR * max(abs(diff(signal))); 
   if mvel>threshold; safe = false; end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

