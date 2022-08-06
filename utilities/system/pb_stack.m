function pb_stack(varargin)
% PB_STACK()
%
% PB_STACK()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl


   % keyval
   v           = varargin;
   b_returnmsg    = pb_keyval('return',v,true);
 
   % list all active functions on the stack
   l              = dbstack;
   fn             = which(l(2).file);
   line           = l(2).line;
   
   % Open 
   matlab.desktop.editor.openAndGoToLine(fn,line);     
   
   % Out
   if b_returnmsg; disp([newline 'In ' l(2).file ' (line ' num2str(line) ')' newline]); end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

