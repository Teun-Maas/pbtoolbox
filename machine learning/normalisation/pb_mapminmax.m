function [output,ps] = pb_mapminmax(input,varargin)
% PB_MAPMINMAX
%
% PB_MAPMINMAX normalizes inputs for neural networks into a mapping from
% ymin to ymax (default: [-1 1]). Note that in order to reverse
% normalisation, direction must be set to 'reverse'.
%
% See also pb_feedforwardmap

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   direction   = pb_keyval('direction',varargin,'apply');
   mapx        = pb_keyval('mapx',varargin,[min(input) max(input)]);
   mapy        = pb_keyval('mapy',varargin,[-1 1]);

   % Generate mapping
   syms x y;
   mapfun   = (mapy(2)-mapy(1)) * ((x-mapx(1))/(mapx(2)-mapx(1))) + mapy(1);     % y = (ymax-ymin) * (x-xmin)/(xmax-xmin) + ymin
   remapfun = solve(y == mapfun,x);                                              % reverse mapping --> solve for x
   
   switch direction
      case 'apply'
         fun = matlabFunction(mapfun);
      case 'reverse'
         fun = matlabFunction(remapfun);
      otherwise
         error('Direction should be set to apply or reverse.')
   end
   
   % process settings
   ps.mapx = mapx;
   ps.mapy = mapy;
   
   % normalised output
   output = fun(input);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

