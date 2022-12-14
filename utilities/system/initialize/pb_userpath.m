function path = pb_userpath
% PB_USERPATH()
%
% PB_USERPATH() returns the userpath for pbtoolbox.
%
% See also pb_initializetoolbox

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if isunix
      path = strrep(which('pb_userpath.m'),'utilities/system/initialize/pb_userpath.m','');
   else
      path = strrep(which('pb_userpath.m'),'utilities\system\initialize\pb_userpath.m','');
   end
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

