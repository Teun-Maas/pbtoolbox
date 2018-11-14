function pb_makelocal(varargin)
% PB_MAKELOCAL(varargin)
%
% PB_MAKELOCAL(varargin) copies dat from server to local computer.
%
% See also PB_MOUNTSERVER, PB_MAKEGLOBAL

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   user        = pb_keyval('user',varargin,'JJH');
   local       = pb_keyval('destination',varargin,[pb_datapath filesep user]);
   srv         = pb_keyval('server',varargin,'mbaudit5');
   d           = dir(['~/sharename/']); 
   srv         = d.folder;
   
   if ~exist(srv,'dir')
      disp('Server cannot be found. Please first mount server (pb_mountserver).');
      return
   end
   
   cdir        = pb_getdir('dir',srv,'title','Select Data..');
   
   % Prevent copy of entire DATA dir
   globaldir    = strrep(cdir,[srv filesep],'');
   wmsg        = [newline 'Prohibited action: DATA dir cannot be made local.' newline];
   if strcmp(globaldir,'DATA'); disp(wmsg); return; end

   % Prevent overwrite in local dir
   dest  = [local filesep cdir(find(cdir==filesep, 1,'last')+1:end)];
   if exist(dest); dest = [dest ' (1)']; end

   cnt   = 0;
   while exist(dest)
      cnt = cnt+1;
      dest = [dest(1:end-2) num2str(cnt) ')'];
   end
   
   copyfile(cdir, dest);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

