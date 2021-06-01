function signal = pb_vSafety(signal)
% PB_VSAFETY(SIGNAL)
%
% PB_VSAFETY(SIGNAL) checks the signal parameters for the vestibular chair 
% to see wether they are within a 'safe' range. Note that if not, the values 
% are fixed to safe maximum.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP, PB_VSIGNALVC.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   vAx = {'Vertical','Horizontal'};
   
   % DO NOT CHANGE THESE!
   thresh_dur = 300;
   thresh_amp = 100;
   thresh_fre = 0.65;
   

   for iAx = 1:2
      if ~strcmp(signal(iAx).type,'none')
         
         %  Safe Durations
         if signal(iAx).duration > thresh_dur 
            warning(['Detected unsafe signal. ' vAx{iAx} ' duration too long!']);
            signal(iAx).duration = thresh_dur;
         end
         
         % Safe amplitude
         if signal(iAx).amplitude > thresh_amp/iAx
            warning(['Detected unsafe signal. ' vAx{iAx} ' amplitude too large!']);
            signal(iAx).amplitude = thresh_amp/iAx;
         end
         
         % Safe threshold
        	if signal(iAx).frequency > thresh_fre
            warning(['Detected unsafe signal. ' vAx{iAx} ' frequency too high!']);
            signal(iAx).frequency = 0.3;
         end
         
         % Safe sum of sines
         if strcmp(signal(iAx).type,'sum') && signal(iAx).frequency > 0.05
            signal(iAx).frequency = 0.05;
         end
      end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

