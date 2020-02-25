function azel = pb_xyz2azel(x,y,z)
% PB_XYZ2AZAL
%
% PB_XYZ2AZAL transforms coordinates from 3D (x,y,z) 2 Azel (az,el) 
% (algorithm by Annemiek Barsingerhorn).
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if (nargin == 1 && size(x,2) == 3)
      y=x(:,2);
      z=x(:,3);
      x=x(:,1);
   end

   RTD = 180/pi;
   azel = zeros(length(x),2);

   p           = sqrt((x .* x) + (z .* z));
   azel(:,1)   = RTD * atan2(x, sqrt(y.^2 + z.^2));
   azel(:,2)   = RTD * atan2(y,z);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

