function handles = pb_vStoreTrial(handles, data)
% PB_VSTOREDATA
%
% PB_VSTOREDATA(handles, data)  stores all the trial data and configurements 
% on a trial basis in organized vc-files.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP, PB_TDTINIT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg = handles.cfg;
   cd([cfg.dname filesep 'trial'])

   [~,prefix]        = pb_fext(cfg.fname);
   fname             = [prefix '-' num2str(cfg.trialnumber(2),'%04d') '.vc'];
   
   beta  = setCFG(cfg);                %% TO DO: <-- FIX: SELECT CFGs FOR TRIAL ONLY
   
   save(fname,'data', 'beta', '-mat');
   
   handles.cfg = cfg;
end

function beta = setCFG(cfg)
   % stores relevant handles into a new trial cfg
   
   beta   = struct('blocknumber',[],...
                  'trialnumber',[],...
                  'vestibularsignal',[],...
                  'nstim',[],...
                  'stim',[]);
              
   ACQsz            = cfg.RZ6_1.GetTagVal('Index');
               
   beta.blocknumber = cfg.blocknumber;
   beta.trialnumber = cfg.trialnumber;
   beta.sound       = cfg.RZ6_1.ReadTagV('ACQ_Data',0,ACQsz);
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

