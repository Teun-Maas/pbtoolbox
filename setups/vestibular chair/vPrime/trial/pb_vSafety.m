function pb_vSafety(signal)
% PB_VSAFETY()
%
% PB_VSAFETY()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if ~strcmp(signal.hor.type,'none')
      if signal.hor.duration > 300 
         error('Unsafe signal: Horizontal duration too long!')
      end
      if signal.hor.amplitude > 20
         error('Unsafe signal: Horizontal amplitude too large!')
      end
   end
   
   if ~strcmp(signal.ver.type,'none')
      if signal.ver.duration > 300 
         error('Unsafe signal: Vertical duration too long!')
      end
      if signal.ver.amplitude > 50
         error('Unsafe signal: Horizontal amplitude too large!')
      end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

