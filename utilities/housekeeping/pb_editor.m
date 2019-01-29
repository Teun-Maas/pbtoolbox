function pb_editor(varargin)
% PB_EDITOR
%
% PB_EDITOR(varargin) allows you to save and reopen your coding 
% projects (multiple m-files in editor).
%
% See also PB_EDIT

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   v     = varargin;
   mode  = pb_keyval('mode',v);
   cdir  = pb_keyval('dir',v,[pb_datadir 'PhD' filesep 'Projects' filesep]);
   fn    = pb_keyval('fn',v);
   dc    = cd;
   
   if isempty(mode)
      
      quest    = 'Choose editor action...';
      title    = 'Editor Action';
      mode     = questdlg(quest, title,'Save','Open','Cancel','Cancel');
      
      switch mode
         case 'Save'
            h     = matlab.desktop.editor.getAll;
            fns   = {h.Filename};
            cd(cdir);
            uisave('fns','');
            cd(dc)
         case 'Open'
            if isempty(fn)
               fn = pb_getfile('dir',cdir);
            end
            if fn ~= 0
               h  = matlab.desktop.editor.getAll;
               if ~isempty(h)
                  quest    = 'Do you want to empty all current files in editor?';
                  title    = 'Editor Action';
                  answer   = questdlg(quest, title,'Yes','No','Cancel','Cancel');
               end
               if strcmp(answer,'Yes')
                  h.close;
               elseif strcmp(answer,'Cancel')
                  return
               end
               load(fn,'fns');
               for idx = 1:length(fns)
                  edit(fns{idx})
               end
               clear('fns');
            end
         case 'Cancel'
            return
      end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% com.mathworks.mlservices.MLEditorServices.closeAll