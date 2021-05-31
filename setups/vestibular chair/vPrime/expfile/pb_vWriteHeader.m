function pb_vWriteHeader(fid,nblocks,ntrials,GV)
% PB_VWRITEHEADER
%
% PB_VWRITEHEADER(fid, GV) writes expfile headers for vPrime setup
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl
   
   % Header of exp-file
   fprintf(fid,'%s\n','%');
   fprintf(fid,'%s\n',['%% Experiment: C:\DATA\' GV.datdir]);
   fprintf(fid,'%s\n','%');
   fprintf(fid,'\n');
   fprintf(fid,'%s %s\n','%%','HEADER');
   
   fprintf(fid,'%s\t\t%d\t%d\n','ITI', GV.ITI(1), GV.ITI(2));
   fprintf(fid,'%s\t%d\n','Blocks', nblocks);
   fprintf(fid,'%s\t%d\n','Trials', ntrials);
   fprintf(fid,'%s\t\t%d\n','Lab',GV.lab);
   fprintf(fid,'%s\t%d\n','Stim',GV.stim);
   fprintf(fid,'\n');
   
   % block comment
   fprintf(fid,'%s %s\t%s\t%s\t%s\t%s\n','%','AX','SIG','AMP','DUR','FREQ');
   fprintf(fid,'%s\n','%');
   fprintf(fid,'%s\t%s\t%s\n','%','1','NONE');
   fprintf(fid,'%s\t%s\t%s\n','%','2','SINE');
   fprintf(fid,'%s\t%s\t%s\n','%','3','NOISE');
   fprintf(fid,'%s\t%s\t%s\n','%','4','TURN');
   fprintf(fid,'%s\t%s\t%s\n','%','5','STEP');
   fprintf(fid,'%s\t%s\t%s\n','%','6','SUM OF SINES');
   fprintf(fid,'\n');
   
   % trial comment
   fprintf(fid,'%s %s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','%','MOD','X','Y','ID','INT','On','On','Off','Off','Event');
   fprintf(fid,'%s\t\t\t%s\t%s\t%s\t%s\t%s\t%s\n','%','edg','bit','Event','Time','Event','Time');
   fprintf(fid,'\n');
   
   % body line
   fprintf(fid,'%s %s','%%','BODY');
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

