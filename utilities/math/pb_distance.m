function distance = pb_distance(target,points)
% PB_DISTANCE()
%
% PB_DISTANCE()  ...
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl


   for iP = 1:size(points,1)
      distance(iP,1) = sqrt(sum(abs(target-points(iP,:)).^2));
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

