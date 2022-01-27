function dat = pb_lsl_correct(D, varargin)
% PB_LSL_CORRECT
%
% PB_LSL_CORRECT() will correct timestamps, and restructure the data from
% lsl_objects
%
% See also lsl_correc_lsl_timestamps

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

   
   % Assert
   if ~isa(D,'lsl_data'); error('Data is not lsl_object class'); end
   
   
   D                    = lsl_correct_lsl_timestamps(D);
   
   % Change data format toi struct;
   dat.Data             = D.Data;
   dat.Timestamps       = D.Timestamps;
   dat.TimeCorrection   = D.TimeCorrection;
   dat.TCindex          = D.TCindex;
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

