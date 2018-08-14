function h = pb_implot(Idx, varargin)
% PB_IMPLOT(IDX, VARARGIN)
%
% PB_IMPLOT(IDX, VARARGIN) is a plot function that takes indices rather
% than x and y coordinates.
%
% See also PLOT
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if isempty(Idx); return; end

   f  = pb_keyval('fig',varargin,gcf);
   a  = pb_keyval('axis',varargin,gca);
   style = pb_keyval('style',varargin,'rx');

   ho = pb_keyval('ho',varargin,ishold);

   if ~isgraphics(f); f = pb_selectfig(f); end
   if ~isgraphics(a); a = pb_selectaxis(a); end

   hold on; 
   [x,y] = i2xy(Idx,a);
   h = plot(x,y,style);

   if ~ho; hold off; end 
end

function [x,y] = i2xy(Idx,a)
   % Converts array index to x and y coordinates.
   l = length(Idx); x = ones(1,l); y = ones(1,l);
   for i = 1:l
      y(i) = mod((a.YLim(2)*a.XLim(2))-Idx(i),a.YLim(2))+1;
      x(i) = ceil(Idx(i)/a.YLim(2));
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

