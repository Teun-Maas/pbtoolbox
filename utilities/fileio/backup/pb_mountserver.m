function pb_mountserver(varargin)
% PB_MOUNTSERVER(varargin)
%
% PB_MOUNTSERVER(varargin) mounts server for pulling or storing data. TO
% DO: Fix for different OS's.
%
% See also pb_makelocal

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   srv      = pb_keyval('server',varargin,'mbaudit5');
   cin      = ['mount -t smbfs //' getcredentials(srv) '@' srv '-srv.science.ru.nl/' srv ' ~/sharename/'];
   [s,cout] = system(cin);
   
   if s > 0 && s ~= 64; disp(cout); end
   if s == 64; system('umount ~/sharename/'); end
end

function auth = getcredentials(srv)
   % obtains authentication credentials for server
   
   doi = [userpath '.credentials'];
   if ~isfolder(doi); mkdir(doi); end
   
   fn = [doi filesep srv '.crd'];
   if ~exist(fn,'file')
      fid = fopen(fn,'wt');
      [str1,str2] = dlg(srv);
      fprintf(fid,'%s:%s',str1,str2);
      fclose(fid);
   end
   
   fid   = fopen(fn);
   auth  = textscan(fid,'%s'); 
   auth = auth{1,1}; 
   auth = auth{1,1};
   fclose(fid);
end

function [str1,str2] = dlg(srv)
   % dialog box
   
   prompt   = {'Enter your username:','Enter password:'};
   title    = ['Connecting to ' srv];
   definput = {'jheckman','password'};
   dims     = [1 75];
   
   answer   = inputdlg(prompt,title,dims,definput);
   str1     = answer{1}; 
   str2     = answer{2};
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

