function pb_vStoreData(h, dat)
% PB_VSTOREBLOCKDAT
%
% PB_VSTOREBLOCKDAT(cfg, Dat)  stores 'Dat' Data in files.
%
% See also PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg = h.cfg;
   
   dat(iBlck).event_data    = str(1).read;
   dat(iBlck).pupil_labs    = str(2).read;
   dat(iBlck).optitrack     = str(3).read;
   dat(iBlck).block_info    = handles.block(iBlck);

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

