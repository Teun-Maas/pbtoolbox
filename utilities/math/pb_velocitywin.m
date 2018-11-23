function x = pb_velocitywin(x,l)
% PB_VELOCITYWIN(t,x)
%
% PB_VELOCITYWIN(t,x) will return a velocity window on a signal.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   xsz = length(x);
   l = ceil(xsz*l);
   
   x = diff(x);
   x = polyint(x);
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

