function pb_clean(varargin)
% PB_CLEAN(varargin)
%
% PB_CLEAN(varargin) cleans up your matlab. Closes all open figures,
% empties the command window, and clears all vars in base workspace.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   fig      = pb_keyval('fig',varargin,true);
   empty    = pb_keyval('clc',varargin,true);
   clr      = pb_keyval('clr',varargin,true);
   
   if fig; close all; end
   if empty; clc; end
   if clr; evalin('base','clear'); end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

