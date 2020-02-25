function azel = pb_quat2azel(q)
% PB_QUAT2AZEL
%
% PB_QUAT2AZEL(quaternion) Transforms coordinates from quaternions 2 azel 
% (algorithm by Annemiek Barsingerhorn).
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   vp    = RotateVector(q,[0 0 1]',1);    % qobj method
   azel  = pb_xyz2azel(vp(1,:),vp(2,:),vp(3,:));
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

