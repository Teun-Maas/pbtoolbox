function h = pb_vline(x, varargin)
% PB_VLINE(Y)
%
% Plot a vertical line through current axis.
%
% PB_VLINE(Y,'Style','LineSpec','Visability','VisibilitySpec') uses the color 
% and linestyle specified by the string 'LineSpec'. Default values for LineSpec 
% and VisibilitySpec are 'k--' & 'off', so that h remains unaffected by graphic 
% other function such as PB_NICEGRAPH. 
%
% See also PB_HLINE, PB_DLINE, PB_REVLINE, PB_NICEGRAPH

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   %% Initialization

   if nargin < 1; x = 0; end

   style      = pb_keyval('style',varargin,'k--');
   visibility = pb_keyval('visibility',varargin,'off');

   ho       = ishold; hold on;
   len      = length(x);
   h        = gobjects(len);

   %% Plot

   x        = x(:)'; 
   y_lim    = get(gca,'YLim');

   for i = 1:len
      h(i)  = plot([x(i);x(i)], y_lim, style);
      set(h(i),'Tag','graphical aid: vertical');
      set(h(i),'HandleVisibility',visibility); % set handle visibility
   end
   if ~ho; hold off; end
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

