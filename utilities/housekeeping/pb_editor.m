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
      %  Run mode dialog
      quest    = 'Choose editor action...';
      title    = 'Editor Action';
      mode     = questdlg(quest, title,'Save','Open','Cancel','Cancel'); 
   end 
   switch mode
      %  Switch function mode
      case 'Save'
         %  Save 
         h     = matlab.desktop.editor.getAll;
         fns   = {h.Filename};
         cd(cdir);
         uisave('fns','');
         cd(dc)
      case 'Open'
         %  Open
         if isempty(fn)
            fn = pb_getfile('dir',cdir);
         end
         if fn ~= 0
            h  = matlab.desktop.editor.getAll;
            if ~isempty(h)
               quest    = 'Do you want to empty all current files in editor?';
               title    = 'Editor Action';
               answer   = questdlg(quest, title,'Yes','No','Cancel','Cancel');

               if strcmp(answer,'Yes')

                  quest    = 'Save current editor setup?';
                  title    = 'Editor Action';
                  answer   = questdlg(quest, title,'Yes','No','Yes');

                  if strcmp(answer,'Yes'); pb_editor('mode','Save'); end
                  pb_closeedit('which','all');
               elseif strcmp(answer,'Cancel')
                  return
               end
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
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 