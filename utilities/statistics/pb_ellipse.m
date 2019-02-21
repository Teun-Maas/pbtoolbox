function [MU,SD,A,x,y] = pb_ellipse(x,y,varargin)
% PB_ELLIPSE
%
% PB_ELLIPSE(x,y,varargin) 
%
% See also PB_ELLIPSEPLOT, PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   v     = varargin;
   out   = pb_keyval('outlier',v,[]);

   % Eigen-values for covariance-matrix
   [Veig,Deig]     = eig(cov(x,y));                         % Veig gives main axes
   A               = bf_rad2deg(atan2(Veig(2),Veig(1)));    % angle

   % Delete response >3SD
   if ~isempty(out)
      SD       = sqrt(diag(Deig)); % diagonal Deig = variance in the 2 main axes
      xmu      = mean(x);
      ymu      = mean(y);

      [Xr,Yr]	= rotate2d(x,y,-A);
      seld		= abs(Xr-mean(Xr))<out*SD(2) & abs(Yr-mean(Yr))<out*SD(1);
      x			= x(seld);
      y			= y(seld);

      % Eigen-values for covariance-matrix
      [Veig,Deig]     = eig(cov(x,y)); % Veig gives main axes
      A               = bf_rad2deg(atan2(Veig(2),Veig(1))); % angle
   end

   % diagonal Deig = variance in the 2 main axes
   SD              = sqrt(diag(Deig));
   xmu             = mean(x);
   ymu             = mean(y);
   MU              = [xmu ymu];
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

