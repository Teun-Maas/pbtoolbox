function pb_vStoreData(h, dat, bn, str)
% PB_VSTOREBLOCKDAT
%
% PB_VSTOREBLOCKDAT(cfg, Dat)  stores 'Dat' Data in files.
%
% See also PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg = h.cfg;
   
   dat(bn).event_data    = str(1).read;
   dat(bn).pupil_labs    = str(2).read;
   dat(bn).optitrack     = str(3).read;
   dat(bn).block_info    = handles.block(bn);

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

