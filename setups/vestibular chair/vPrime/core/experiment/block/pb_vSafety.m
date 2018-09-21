function signal = pb_vSafety(signal)
% PB_VSAFETY()
%
% PB_VSAFETY()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if ~strcmp(signal(2).type,'none')
      if signal(2).duration > 300 
         warning('Unsafe signal: Horizontal duration too long. Duration reduced to 300.' );
         signal(2).duration = 300;
      end
      if signal(2).amplitude > 20
         warning('Unsafe signal: Horizontal amplitude too large. Amplitude reduced to 20');
         signal(2).amplitude = 20;
      end
   end
   
   if ~strcmp(signal(1).type,'none')
      if signal(1).duration > 300 
         warning('Unsafe signal: Vertical duration too long!');
         signal(1).duration = 300;
      end
      if signal(1).amplitude > 40
         warning('Unsafe signal: Horizontal amplitude too large!');
         signal(2).amplitude = 40;
      end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

