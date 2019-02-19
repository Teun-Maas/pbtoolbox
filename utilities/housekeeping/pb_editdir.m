function pb_editdir
% PB_EDITDIR
%
% PB_EDITDIR will change directory to the current active file in the editor.
%
% See also PB_EDIT, PB_EDITOR

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   h  = matlab.desktop.editor.getActive;
   if ~isempty(h)
      fn 	= h.Filename;
      cdir  = fn(1:max(strfind(fn,filesep)));
      cd(cdir);
      disp(['cd: ' fn(1:max(strfind(fn,filesep)))])
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

