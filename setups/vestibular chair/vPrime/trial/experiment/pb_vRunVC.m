function Dat = pb_vRunVC(signal)
% PB_VRUNVC()
%
% PB_VRUNVC()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   dur = 10;


   vSignal = pb_vCreateSignal(1, signal(1).duration, 10, 1, signal(1).type);
   hSignal = pb_vCreateSignal(1, signal(2).duration, 10, 1, signal(2).type);
 
   Dat.v.x = vSignal.x .* signal(1).amplitude;
   Dat.v.t = (0:1:length(Dat.v.x)-1)/10;
   Dat.h.x = hSignal.x .* signal(2).amplitude;
   Dat.h.t = (0:1:length(Dat.h.x)-1)/10;

end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

