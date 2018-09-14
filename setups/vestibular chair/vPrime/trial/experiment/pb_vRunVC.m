function Dat = pb_vRunVC(signal)
% PB_VRUNVC()
%
% PB_VRUNVC()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   dur = 10;
   amp = 10;
   type = 'sine';

   vSignal = pb_vCreateSignal(1, dur, 10, 1, type);
   hSignal = pb_vCreateSignal(1, dur, 10, 1, type);
 
   Dat.v.x = vSignal.x .* amp;
   Dat.v.t = (0:1:length(Dat.v.x)-1)/10;
   Dat.h.x = hSignal.x .* 0;
   Dat.h.t = (0:1:length(Dat.h.x)-1)/10;

end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

