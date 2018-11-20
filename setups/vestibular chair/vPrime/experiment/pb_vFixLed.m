function VIS = pb_vFixLed(VIS,fixled,varargin)
% PB_VFIXLED(VIS,fixled,varargin)
%
% PB_VFIXLED(VIS,fixled,varargin)  adds a fixation led at start of VS prior
% to the stimulus
%
% See also PB_VGENVISEXP, PB_VWRITESTIM

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if ~fixled.bool || ~isstruct(VIS); return; end
   
   x     = pb_keyval('x',varargin,0);
   y     = pb_keyval('y',varargin,0);
   dur   = pb_keyval('dur',varargin,500);
   
   VIS(end+1)  = VIS;
   
   VIS(1).X       = x; 
   VIS(1).Y       = y; 
   VIS(1).Int        = 50; 
   VIS(1).EventOn    = 0; 
   VIS(1).Onset      = 0;
   VIS(1).EventOff   = 0; 
   VIS(1).Offset     = dur; 
   
   c = 1;
   for i = length(VIS)-1
      if VIS(c).EventOn == VIS(c+1).EventOn
         stimdur           = VIS(c+1).Offset-VIS(c+1).Onset;
         VIS(c+1).Onset    = VIS(c).Onset + dur;
      end
      if VIS(c).EventOff == VIS(c+1).EventOff
         VIS(c+1).Offset   = VIS(c+1).Onset + stimdur;
      end
      c=c+1;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 