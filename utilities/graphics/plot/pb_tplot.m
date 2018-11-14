function pb_tplot(target,varargin)
% PB_TPLOT()
%
% PB_TPLOT()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   if nargin == 0; return; end
   
   ax    = pb_keyval('axis', varargin, gca);
   col   = pb_keyval('color', varargin, 'r');
   
   axes(ax);
   targetsz = size(target,1);
   
   for tIdx = 1:targetsz
      y     = target(tIdx,1);
      y     = [y y];
      t1    = target(tIdx,2);
      dur   = target(tIdx,3);
      t2    = t1+dur;
      t     = [t1 t2];
      plot(t,y,'color',col,'tag','target plot','HandleVisibility','off')
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

