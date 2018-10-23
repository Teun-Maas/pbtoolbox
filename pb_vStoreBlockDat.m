function pb_vStoreBlockDat(cfg, Dat)
% PB_VSTOREBLOCKDAT()
%
% PB_VSTOREBLOCKDAT()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   file = [cfg.dname '/block_info.m'];
   save(file, 'Dat');
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

