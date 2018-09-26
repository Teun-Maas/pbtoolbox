function handles = pb_vStoreData(handles, data)
% PB_VSTOREDATA(HANDLES, DATA)
%
% PB_VSTOREDATA(HANDLES, DATA)  stores all the trial data and configurements 
% on a trial basis in organized vc-files.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg = handles.cfg;
   
   cd([cfg.dname filesep 'trial'])

   [~,prefix]        = pb_fext(cfg.fname);
   fname             = [prefix '-' num2str(cfg.trialnumber(2),'%04d') '.vc'];
   
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

