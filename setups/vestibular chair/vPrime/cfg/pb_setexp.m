function [Dat,bool_cal] = pb_setexp(handles)
% PB_SETEXP
%
% PB_SETEXP will determine the data object type and determine if experiment
% is calibration or not.
%
% See also PB_VPRIME

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl


   switch pb_fext(handles.cfg.expfname)
      case '.cal'
         Dat         = pb_calobj(handles.cfg.Blocks);
         bool_cal  	= true;
      case '.exp'
         Dat         = pb_dataobj(handles.cfg.Blocks);
         bool_cal  	= false;
      otherwise
         error('Unknown experiment file type extension! (fnames must be either .exp or .cal)');
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

