function pb_initializetoolbox()
% PB_INITIALIZETOOLBOX()
%
% Initializes PBToolbox.
%
% PB_INITIALIZETOOLBOX()  ...
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   cdp   = cd; 
   startupf = 'startup.m';
   fstartup = which(startupf);
   
   clc; disp('Initializing ProgrammeerBeerToolbox...');
   
   pbpath = strrep(which('pb_initializetoolbox.m'),'pb_initializetoolbox.m','');
   text = fileread([pbpath 'documentation/templates/template_startup.txt']);
   
   disp([newline '   - localising startup.m']);
   if isempty(fstartup)
      cd(userpath);
      fid     = fopen(startupf, 'wt+');
      fprintf(fid,'%s\n', text);
      fclose(fid);
   else
      startuptext = fileread(fstartup);
      if ~contains(startuptext,text)
         fid     = fopen(fstartup, 'at+');
         fprintf(fid,'\n\n');
         fprintf(fid,'%s\n', text);
         fclose(fid);
      end
   end   
   disp('   - writing startup.m');
   
   startup;
   cd(cdp);
   clc; disp(['ProgrammeerBeerToolbox was succesfully initialized...' newline])
end



 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

