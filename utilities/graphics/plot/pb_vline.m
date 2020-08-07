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

   style       = pb_keyval('style',varargin,'k--');
   visibility  = pb_keyval('visibility',varargin,'off');
   lim         = pb_keyval('lim',varargin,get(gca,'YLim'));
   col         = pb_keyval('color',varargin);
   lw          = pb_keyval('LineWidth',varargin,1);

   ho       = ishold; hold on;
   len      = length(x);
   h        = gobjects(len);

   %% Plot

   x        = x(:)'; 
   
   % Approach zero
   lim(lim==0) = 1e-100;
   
   for i = 1:len
      h(i)  = plot([x(i);x(i)], lim, style);
      if ~isempty(col); set(h(i),'Color',col); end
      set(h(i),'Tag','graphical aid: vertical');
      set(h(i),'LineWidth',lw);
      set(h(i),'HandleVisibility',visibility);        % set handle visibility
   end
   if ~ho; hold off; end
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

