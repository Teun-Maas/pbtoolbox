function pb_vWriteSnd(fid,SND,X,Y,ID,Int,EventOn,Onset,Offset)
% PB_VWRITESND()
%
% PB_VWRITESND()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl


% WRITESND(FID,SND,X,Y,ID,INT,EVENTON,ONSET,EVENTOFF,OFFSET)
%
% Write a SND-stimulus line in an exp-file with file identifier FID.
%
% SND		- 'SND1' or 'SND2'
% X			- SND theta angle
% Y			- SND phi number (1-29 and 101-129)
% INT		- SND Intensity (0-100)
% EVENTON	- The Event that triggers the onset of the SND (0 - start of
% trial)
% ONSET		- The Time after the On Event (msec)
% EVENTOFF  - The event that triggers the offset of the SND
% OFFSET    - The time after the off event (mse)

   fprintf(fid,'%s\t%d\t%d\t \t%d\t%d\t%d\t%d\t%d\n',SND,X,Y,ID,Int,EventOn,Onset,Offset);
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

