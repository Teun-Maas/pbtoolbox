function [TOT,h] = pb_bubbleplot(X,Y,varargin)
% PB_BUBBLEPLOT()
%
% PB_BUBBLEPLOT()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   
   XW       = pb_keyval('Xwidth',varargin);
   YW       = pb_keyval('Ywidth',varargin);
   scale    = pb_keyval('scale',varargin,1);
   def      = pb_keyval('col',varargin,5);
   
   if isempty(XW); [~,~,XW,~] = pb_binsize(X); XW = XW*scale; end
   if isempty(YW); [~,~,YW,~] = pb_binsize(Y); YW = YW*scale; end

   %% Histogram
   X			= round(X/XW)*XW;
   Y			= round(Y/YW)*YW;

   uX			= unique(X);
   uY			= unique(Y);

   [UX,UY] = meshgrid(uX,uY);

   x		= uY;

   TOT		= NaN(size(UX));
   for ii	= 1:length(uX)
      sel			= X == uX(ii);
      r			= Y(sel);
      N			= hist(r,x);
      if isscalar(x)
      N			= histogram(r,[x-XW x+XW]);
      end
      TOT(:,ii)	= N;
   end

   %% Normalize
   TOT		= log10(TOT+1);
   mxTOT	= nanmax(nanmax(TOT));
   mnTOT	= nanmin(nanmin(TOT));
   TOT		= (TOT-mnTOT)./(mxTOT-mnTOT);

   %% Plot
   M	= TOT(:);
   x	= UX(:);
   y	= UY(:);

   sel = M>0;
   M	= M(sel);
   x	= x(sel);
   y	= y(sel);

   SZ			= ceil(100*M)*scale;
   [~,~,idx]	= unique(M);
   col			= statcolor(max(idx),[],[],[],'def',def);
   C			= col(idx,:);
   h			= scatter(x,y,SZ,C,'filled');
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

