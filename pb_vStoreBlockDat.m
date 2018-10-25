function pb_vStoreBlockDat(cfg, Dat)
% PB_VSTOREBLOCKDAT()
%
% PB_VSTOREBLOCKDAT()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   [~,fn] = pb_fext(cfg.fname);
   file = [cfg.dname filesep 'block_info_' fn '.mat'];
   save(file, 'Dat');
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
