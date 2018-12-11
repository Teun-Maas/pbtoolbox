function pb_vStoreData(cfg, data)
% PB_VSTOREDATA
%
% PB_VSTOREDATA(handles, data)  stores all the trial data and configurements 
% on a trial basis in organized vc-files.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP, PB_TDTINIT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cd([cfg.dname filesep 'trial'])

   [~,prefix]        = pb_fext(cfg.fname);
   fname             = [prefix '-' num2str(cfg.trialnumber(2),'%04d') '.vc'];
   
   beta  = setCFG(cfg);                %% TO DO: <-- FIX: SELECT CFGs FOR TRIAL ONLY
   
   save(fname,'data', 'beta', '-mat');
end

function beta = setCFG(cfg)
   % stores relevant handles into a new trial cfg
   
   beta   = struct('blocknumber',[],...
                  'trialnumber',[],...
                  'vestibularsignal',[],...
                  'nstim',[],...
                  'stim',[]);
               
   beta.blocknumber = cfg.blocknumber;
   beta.trialnumber = cfg.trialnumber;
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

