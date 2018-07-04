function pb_terminal(varargin)
% PB_TERMINAL(varargin)
%
% PB_TERMINAL(VARARGIN) is general terminal function for unix users.
% The functions allows for 'local' or 'system' user interaction with the 
% terminal, which can be set in the 'medium' key. Direct interaction can be
% obtained via the 'cmd' key.
% 
% See also SYSTEM
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if ispc; fprintf('pb_terminal is a function limited to unix systems'); return; end

   medium   = pb_keyval('medium',varargin,'system');
   cmd      = pb_keyval('cmd',varargin,[]);
   
   if ~isempty(cmd); system(cmd); return; end
   
   switch medium
      case 'system'
         system('open -a terminal');
      case 'local'
         localInput = ['Welcome to the terminal. How may I help you? (Abort: [X]).' newline];
         clc; fprintf(localInput); 
         run_terminal(localInput);
      otherwise
         disp('No valid input argument given for "medium"')
   end
end

function run_terminal(D)
   % run_terminal recursively displays user input and terminal output,
   % until abortion input is selected
   
   D = input([newline '  '],'s');
   if D == 'X'
      quit = 'nothing';
      while quit ~= 'n' | quit ~= 'Y' | quit ~= 'y'
         quit = input([newline 'Are you sure you would like to exit the local terminal? [Y/n]' newline newline '  '],'s');
         while isempty(quit)
            quit = input([newline 'Are you sure you would like to exit the local terminal? [Y/n]' newline newline '  '],'s');
         end
         if quit == 'Y' | quit == 'y'
            fprintf([newline 'Local terminal aborted' newline newline]);
            return
         elseif quit == 'n'
            D = input([newline '  '],'s');
            break
         end
      end
   end
   fprintf('  '); system(D);
   fprintf('  '); run_terminal(D);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

