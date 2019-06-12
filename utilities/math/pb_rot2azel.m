function [az,el] = pb_rot2azel(x,y,z)
% PB_ROT2AZEL
%
% PB_ROT2AZEL(x,y,z) returns the azimuth and elevation
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   if (nargin==1 && size(x,2)==3)
     y=x(:,2);
     z=x(:,3);
     x=x(:,1);
   end

   RTD   = 180/pi;
   p     = sqrt(x .* x + z .* z);
   az    = RTD * atan2 (x, sqrt (y.^2 + z.^2));
   el    = RTD * atan2(y,z);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

