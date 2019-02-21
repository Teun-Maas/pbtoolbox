function h = pb_ellipseplot(Mu,SD,Phi,varargin)
% PB_ELLIPSEPLOT
%
% PB_ELLIPSEPLOT(Mu,SD,Phi,varargin) 
%
% See also PB_ELLIPSEP, PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   v        = varargin;
   col      = pb_keyval('color',v,'k');
   alpha    = pb_keyval('alpha',v,.33);
   ls       = pb_keyval('linestyle',v,'--');
   SD       = pb_keyval('sd',v,SD*2);
   disp     = pb_keyval('disp',v,false);
   regcol   = pb_keyval('regcol',v,col);
   
   hs       = ishold(gca);
   hold on;
   
   Xo	= Mu(1);
   Yo	= Mu(2);
   L	= SD(1);
   S	= SD(2);
   DTR = pi/180;
   Phi = Phi*DTR;

   %  Ellipse
   wt  = (0:.1:360) .* DTR;
   X   = Xo + L*cos(Phi)*cos(wt) - S*sin(Phi)*sin(wt);
   Y   = Yo + L*sin(Phi)*cos(wt) + S*cos(Phi)*sin(wt);

   %  Graphics
   h  = patch(X,Y,col);
   set(h(1),...
      'EdgeColor',col,...
      'LineWidth',1,...
      'LineStyle',ls,...
      'FaceAlpha',alpha);
   
   
   if disp; h(2) = pb_regplot(X,Y,'data',false,'color',col); end  %% REGRESSION DOES NOT MATCH ANGLE OF ELLIPSE
   if ~hs; hold on; end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
