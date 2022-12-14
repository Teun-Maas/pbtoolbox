function pb_vStoreData(h, dat, bn, str,meta_pup)
% PB_VSTOREBLOCKDAT
%
% PB_VSTOREBLOCKDAT(cfg, dat)  stores 'Dat' Data in files.
%
% See also PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg = h.cfg;
    
   switch pb_fext(cfg.expfname)
      case '.cal'
         
         % Write calibration data
         dat(bn).pupil_labs      = str(1).read;
         dat(bn).event_in        = str(4).read;
         dat(bn).event_out       = str(5).read;
         dat(bn).block_info      = h.block(bn);
         
         prefix = 'calibration_';

      case '.exp'
         
         % Write experimental data
         dat(bn).pupil_labs      = str(1).read;
         dat(bn).optitrack       = str(2).read;
         dat(bn).sensehat        = str(3).read;
         dat(bn).event_in        = str(4).read;
         dat(bn).event_out       = str(5).read;
         dat(bn).block_info      = h.block(bn);

         % store the meta data
         dat(bn).meta_pup      = meta_pup;
         
         prefix = 'block_info_';
   end
   
   % Store data
   [~,fn]      = pb_fext(cfg.fname);
   file        = [cfg.dname filesep prefix fn '.mat'];
   save(file, 'dat');
   
   assignin('base','dat',dat); % open data
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

