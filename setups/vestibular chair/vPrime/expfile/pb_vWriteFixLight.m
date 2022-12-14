function pb_vWriteFixLight(fid,GV)
% PB_VWRITEFIXLIGHT()
%
% PB_VWRITEFIXLIGHT()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

   
   switch GV.stim_fixlight
      case 1   % Chair frame
         x  = 0;
         y  = 0;
      case 2   % World frame
         x  = 90;
         y  = 0;
   end

	fprintf(fid,'%s\t%.0f\t%.0f\t \t%d\t%d\t%d\t%d\t%d\n','LED',x,y,50,0,0,0,GV.stim_fixdur);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

