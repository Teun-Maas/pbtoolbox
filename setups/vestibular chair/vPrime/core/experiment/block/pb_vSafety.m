function signal = pb_vSafety(signal)
% PB_VSAFETY(SIGNAL)
%
% PB_VSAFETY(SIGNAL) checks the signal parameters for the vestibular chair 
% to see wether they are within a 'safe' range. Note that if not, the values 
% are fixed to safe maximum.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP, PB_VSIGNALVC.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% TODO: CONTROL SPEED OF EXPERIMENT (DIFF(SIGNAL))

   vAx = {'Vertical','Horizontal'};

   for iAx = 1:2
      if ~strcmp(signal(iAx).type,'none')
         if signal(iAx).duration > 300 
            warning(['Detected unsafe signal. ' vAx{iAx} ' duration too long!']);
            signal(iAx).duration = 300;
         end
         if signal(iAx).amplitude > 40/iAx
            warning(['Detected unsafe signal. ' vAx{iAx} ' amplitude too large!']);
            signal(iAx).amplitude = 40/iAx;
         end
        	if signal(iAx).frequency > .3
            warning(['Detected unsafe signal. ' vAx{iAx} ' frequency too high!']);
            signal(iAx).frequency = .3;
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

