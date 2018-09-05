function pb_pause(msg)
% PB_PAUSE(msg)
%
% PB_PAUSE() allows you to pause with display msg until any key is pressed.
%
% See also PAUSE, INPUT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin == 0; pause; return; end
   disp(msg);
   pause;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

