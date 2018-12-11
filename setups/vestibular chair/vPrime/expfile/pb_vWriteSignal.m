function pb_vWriteSignal(fid,block)
% PB_VWRITESIGNAL(fid,block)
%
% PB_VWRITESIGNAL(fid,block)  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   h  = block.Horizontal;
   v  = block.Vertical;
   
   fprintf(fid,'%s\t\t%d\t%d\t%d\t%0.1f\n','HOR',h.Signal,h.Amplitude,h.Duration,h.Frequency);
   fprintf(fid,'%s\t\t%d\t%d\t%d\t%0.1f\n','VER',v.Signal,v.Amplitude,v.Duration,v.Frequency);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

