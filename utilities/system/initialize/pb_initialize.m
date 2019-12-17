function pb_initialize()
% PB_INITIALIZE()
%
% PB_INITIALIZE()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   global PBT_ROOT
   
   PBT_ROOT       = pb_userpath;
   INIT_ARCH      = computer('arch');
   INIT_DIR       = strcat(PBT_ROOT,'/utilities/system/initialize/init');
   INIT_ARCH_DIR  = strcat(PBT_ROOT,'/utilities/system/initialize/init/',INIT_ARCH);

   INIT_CWD       = cd;

   % Run generic commands
   cd(INIT_DIR);
   INIT_FILES = dir('*.m');
   for n = 1:size(INIT_FILES)
       [~,INIT_CMD,~] = fileparts(INIT_FILES(n).name);
       eval(INIT_CMD);
   end

   % Run architecture specficic commands
   cd(INIT_ARCH_DIR);
   INIT_FILES = dir('*.m');
   for n = 1:size(INIT_FILES)
       [~,INIT_CMD,~]=fileparts(INIT_FILES(n).name);
       eval(INIT_CMD);
   end

   cd(INIT_CWD);
   clear n INIT_*;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


