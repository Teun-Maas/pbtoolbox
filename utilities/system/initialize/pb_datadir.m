function path = pb_datadir(varargin)
% PB_DATADIR()
%
% PB_DATADIR()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %pb_keyval(,varargin,);
   
   fn    = [pb_userpath 'utilities/system/initialize/init/datadir.txt'];
   if ~exist(fn,'file'); fopen(fn,'wt+'); end
   
   text  = fileread(fn);
   if ~any(text) 
      question = 'Select your data directory';
      disp(question);
      text = pb_getdir('title',question); 
      fid = fopen(fn,'wt+'); 
      fwrite(fid,text);
      fclose(fid);
   end
   
   path = [pb_keyval('path',varargin,text) filesep];
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

