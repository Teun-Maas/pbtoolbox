function Data = pb_chronolizepupil(Data)
%
% PB_CHRONOLIZEPUPIL()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

   % Get timestamps
   ts       = lsl_correct_lsl_timestamps(Data);
   [~,idx]  = sort(ts);
   ts       = ts(idx);

   % Correct pupil Data and timestamps
   Data.Data(:,idx);
   Data.Timestamps = ts;

   % Correct pupil time corrections
   for iC = 1:length(Data.TimeCorrection)
      idx_c                = Data.TCindex(iC);
      new_idx              = find(idx == idx_c);
      Data.TCindex(iC)     = new_idx;
   end

   % Resort them
   [~,idx]                 = sort(Data.TCindex);
   Data.TCindex            = Data.TCindex(idx);
   Data.TimeCorrection    	=  Data.TimeCorrection(idx);

end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

