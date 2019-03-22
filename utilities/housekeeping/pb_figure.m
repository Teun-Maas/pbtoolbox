function h = pb_figure(n,varargin)
% PB_FIGURE()
%
% PB_FIGURE()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   if nargin == 0
      g = groot;
      n = 1;
      if ~isempty(g.Children); n = g.Children(end).Number+1; end 
   end
   
   MP = get(0, 'MonitorPositions');
   FigH = figure(n);
   
   if size(MP, 1) == 1  % Single monitor
     set(figH,varargin{:})
   else                 % Multiple monitors
     % Catch creation of figure with disabled visibility: 
     indexVisible = find(strncmpi(varargin(1:2:end), 'Vis', 3));
     if ~isempty(indexVisible)
       paramVisible = varargin(indexVisible(end) + 1);
     else
       paramVisible = get(0, 'DefaultFigureVisible');
     end
     %
     Shift    = MP(1, 1:2);
     set(FigH,varargin{:}, 'Visible', 'off');
     set(FigH, 'Units', 'pixels');
     pos      = get(FigH, 'Position');
     set(FigH, 'Position', [pos(1:2) + Shift, pos(3:4)],'Visible', paramVisible);
   end
   if nargout ~= 0; h = FigH; end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

