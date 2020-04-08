function cfn = pb_clean(varargin)
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
   dir      = pb_keyval('cd',varargin);
   
   if fig; close all hidden; end
   if nargout; cfn = 0; end
   if empty; clc; end
   if islogical(clr)
      if clr; pb_clear(); end
   else
      pb_clear(clr);
   end
   if ~isempty(dir)
      cd(dir);
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

