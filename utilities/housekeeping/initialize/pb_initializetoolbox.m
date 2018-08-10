function pb_initializetoolbox()
% PB_INITIALIZETOOLBOX()
%
% Initializes PBToolbox.
%
% PB_INITIALIZETOOLBOX()  ...
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if is_initialized(); return; end %check if not already initialized

   supath = which('testup.m');
   if isempty(supath)
      supath = userpath;
      fid = fopen(supath,'wt');
      fprintf(fid,'');
      fclose(fid);
   end


   PBT = [];

   addline = "new_path = cd('[ROOT]');\naddpath(genpath(new_path));\n";
   addline = replace(addline, '[ROOT]',PBT);
end

function bool = is_initialized()
   bool = true;
end


 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

