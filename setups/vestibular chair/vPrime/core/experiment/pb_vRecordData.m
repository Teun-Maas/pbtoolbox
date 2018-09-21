function pb_vRecordData(exp,trial)
% PB_VRECORDDATA()
%
% PB_VRECORDDATA()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cd(exp.dir)
   day   = datestr(now,'yy-mm-dd');
   trial = num2str(trial,'%04d');
   fname = [exp.experimenter '-' ...
            exp.SID '-' ...
            day '-' ...
            exp.recording '-' ...
            trial '.vc'];
         
   fid = fopen(fname, 'wt');
   fprintf(fid,'test\n');
   fclose(fid);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

