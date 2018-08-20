function signal = pb_cleanSP(signal,len)
% PB_CLEANSP(signal,len)
%
% Removes excessive data tail from VC servo analysis signals. 
% 
% PB_CLEANSP(signal,len) takes the signal and cuts of the
% 0-tail until the minimum length, len, of the signal. If len is not 
% provided it cuts of at the second 0 after the last non zero.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   signal = rot90(signal,2);

   
   logicBool = signal ~= 0;
   signal = rot90(signal(find(logicBool==1,1)-1:end),2);
   
   if nargin == 1; len = length(signal); end
   if len > length(signal)
      signal(end+1:len) = 0;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

