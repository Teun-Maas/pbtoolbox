function signal = pb_vBuildSignal(block)
% PB_VBUILDSIGNAL
%
% PB_VBUILDSIGNAL(block) will create the vestibular signals for a given
% experimental block.
%
% See also PB_VPRIME, PB_VSIGNALVC, PB_VSAFETY, PB_VCHECKVELSIGNAL

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   % read signals
   signal(1)   = block.ver;
   signal(2)   = block.hor; 
   
   for iSig = 1:2
      % correct for vestibular chair's inertia.
      if strcmp(signal(iSig).type,'sine'); signal(iSig).type = 'predictsine'; end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

