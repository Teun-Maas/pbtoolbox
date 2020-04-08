function pb_johnplot(X,Y,varargin)
% PB_JOHNPLOT()
%
% PB_JOHNPLOT()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   if nargin == 1
      Y = 1:length(X);
   end
   if size(X) ~= size(Y); disp('Dimensions X and Y do not agree'); return; end
   
   markersize     = pb_keyval('markersize',varargin,2);
   defsz          = markersize*2; %* max([(max(X)-min(X)),(max(Y)-min(Y))]) / max([max(X),max(Y)]) * 10;
   
   hs = ishold;
   gca; hold on;
   axis square;
   
   marker = imread(which('marker_john_1.png'),'BackgroundColor', [1 1 1]);

   for iScat = 1:length(X)
      x = [X(iScat) - defsz*0.133 X(iScat) + defsz*0.133];
      y = [Y(iScat) + defsz*0.2 Y(iScat) - defsz*0.2];
      h(iScat) = image(x,y,marker); 
   end
   if ~hs; hold off; end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

