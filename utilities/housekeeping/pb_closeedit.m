function pb_closeedit(varargin)
% PB_CLOSEEDIT
%
% PB_EDITOR(varargin) allows you to save and reopen your coding 
% projects (multiple m-files in editor).
%
% See also PB_EDIT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   v     = varargin;
   mode  = pb_keyval('which',v,'current');
   
   switch mode
      case 'current'
         h = matlab.desktop.editor.getActive;
      case 'all'
         h = matlab.desktop.editor.getAll;
      otherwise
         return
   end
   h.close;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% com.mathworks.mlservices.MLEditorServices.closeAll