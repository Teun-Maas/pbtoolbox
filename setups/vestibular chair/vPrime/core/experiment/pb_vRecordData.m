function handles = pb_vRecordData(handles, data)
% PB_VRECORDDATA(HANDLES, DATA)
%
% PB_VRECORDDATA(HANDLES, DATA)  ...
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg = handles.cfg;
   
   cd([cfg.dname filesep 'trial'])

   [~,prefix]        = pb_fext(cfg.fname);
   fname             = [prefix '-' num2str(cfg.trialnumber,'%04d') '.vc'];
   
   data = data;               %% TO DO: <-- FIX: SELECT DATA FOR TRIAL ONLY
   cfg  = cfg;                %% TO DO: <-- FIX: SELECT CFGs FOR TRIAL ONLY
   
   save(fname,'data', 'cfg', '-mat');
   
   handles.cfg = cfg;
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
