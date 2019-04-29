function pb_MUX(RP,Device,Channel)
% PB_MUX()
%
% PB_MUX()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   if nargin<3; Channel = 0; end

   RP.SetTagVal('DeviceSelect',Device-1);          % select the device
   if Channel                                      % activate a channel
       RP.SetTagVal('ChanSelect',Channel-1);       % select the channel
   end
   RP.SoftTrg(1);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

