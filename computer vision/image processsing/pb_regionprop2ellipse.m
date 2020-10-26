function S = pb_regionprop2ellipse(S)
% PB_REGIONPROP2ELLIPSE()
%
% PB_REGIONPROP2ELLIPSE()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   t  = linspace(0,2*pi,50);
   
   for iS = 1:length(S)
      a     = S(iS).MajorAxisLength/2;
      b     = S(iS).MinorAxisLength/2;
      Xc    = S(iS).Centroid(1);
      Yc    = S(iS).Centroid(2);
      phi   = deg2rad(-S(iS).Orientation);
      x     = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
      y     = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
      
      S(iS).ellipse.x = x;
      S(iS).ellipse.y = y;
      S(iS).ellipse.Fx = [(Xc + (a^2 + b^2)) (Xc - sin(a^2 + b^2))];
      S(iS).ellipse.Fy = [(Yc + (a^2 + b^2)) (Yc - sin(a^2 + b^2))];
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

