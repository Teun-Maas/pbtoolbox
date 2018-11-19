function pb_vWriteHeader(fid,datdir,ITI,Nblcks,Ntrls,Rep,Rnd,Mtr,varargin)
% PB_VWRITEHEADER()
%
% PB_VWRITEHEADER()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   lab = keyval('Lab',varargin);
   if isempty(lab)
      lab = 1; % hoop by default
   end
   % Header of exp-file
   fprintf(fid,'%s\n','%');
   fprintf(fid,'%s\n',['%% Experiment: C:\DATA\' datdir]);
   fprintf(fid,'%s\n','%');
   fprintf(fid,'\n');
   fprintf(fid,'%s %s\n','%%','HEADER');
   
   fprintf(fid,'%s\t\t%d\t%d\n','ITI',ITI(1),ITI(2));
   fprintf(fid,'%s\t%d\n','Blocks',Nblcks);
   fprintf(fid,'%s\t%d\n','Trials',Ntrls);
   fprintf(fid,'%s\t%d\n','Repeats',Rep);
   fprintf(fid,'%s\t%d\t%s\n','Random',Rnd,'% 0=no, 1=per set, 2=all trials');
   fprintf(fid,'%s\t\t%s\n','Motor',Mtr);
   if lab>1
      fprintf(fid,'%s\t\t%d\n','Lab',lab);
   end
   fprintf(fid,'\n');
   fprintf(fid,'%s %s\t%s\t%s\t%s\t%s\n','%','AX','SIG','AMP','DUR','FREQ');
   fprintf(fid,'%s\n','%');
   fprintf(fid,'\n');
   % Information Line of body
   fprintf(fid,'%s %s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','%','MOD','X','Y','ID','INT','On','On','Off','Off','Event');
   fprintf(fid,'%s\t\t\t%s\t%s\t%s\t%s\t%s\t%s\n','%','edg','bit','Event','Time','Event','Time');
   fprintf(fid,'\n');
   fprintf(fid,'%s %s','%%','BODY');
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

