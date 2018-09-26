function handles = pb_vRecordData(handles)
% PB_VRECORDDATA()
%
% PB_VRECORDDATA()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg = handles.cfg;
   
   cd([cfg.dname filesep 'trial'])

   [~,prefix]        = pb_fext(cfg.fname);
   fname             = [prefix '-' num2str(cfg.trialnumber,'%04d') '.vc'];
   
   fid = fopen(fname,'wt');
   fwrite(fid, fname);
   fclose(fid);
   
   handles.cfg = cfg;
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

