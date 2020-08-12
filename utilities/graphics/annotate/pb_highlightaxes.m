function pb_highlightaxes(h,varargin)
% PB_HIGHLIGHTAXES
%
% PB_HIGHLIGHTAXES(h) ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   % Assert
   if ~or(isgraphics(h(1),'Axes'),isgraphics(h(1),'Figure')); return; end
    
   % Identify axes to highlight
   if isgraphics(h(1),'Figure'); h = identify_axes(h); end
   
   % Varargin
   basecol     = pb_keyval('basecol',varargin,[0 0 0]);
   col         = pb_keyval('col',varargin,repmat(basecol,length(h),1));
   linewidth   = pb_keyval('linewidth',varargin,3);
   
   for iA = 1:length(h)
      % Get Identifiers
      list_objs  	= flipud(h(1).Parent.Children);
      list_axes   = list_objs(isgraphics(list_objs,'Axes'));
      idfy_a      = find(list_axes == h(iA));
      
      tag      = ['Highlight #A' num2str(idfy_a)];
      pos     	= get_positions(h(iA));
      hand     = annotation('Rectangle',pos,'Color',col(iA,:),'LineWidth',linewidth,'Tag',tag,'HandleVisibility','on');
   end
end

function h = identify_axes(fig)
   % Determine the axes with 
   h     = findall(fig);
   h     = flipud(h);
   b_h   = false(1,length(h));
   
   for iH = 1:length(h)
     b_h(iH) = isa(h(iH),'matlab.graphics.shape.Rectangle');
   end
   h = h(b_h);
   
   ax    = pb_fobj(fig,'Type','Axes');
   selax = zeros(1,length(h));
   for iH = 1:length(h)
      selax(iH) = str2double(strrep(h(iH).Tag,'Highlight #A',''));
   end
   delete(h);
   h = ax(selax);
end

function pos = get_positions(h)
   currunit = get(h, 'units');
   axisPos  = getpixelposition(h);
   darismanual  = strcmpi(get(h, 'DataAspectRatioMode'),    'manual');
   pbarismanual = strcmpi(get(h, 'PlotBoxAspectRatioMode'), 'manual');

   if ~darismanual && ~pbarismanual
       pos = axisPos;
   else

       xlim = get(h, 'XLim');
       ylim = get(h, 'YLim');

       % Deal with axis limits auto-set via Inf/-Inf use

       if any(isinf([xlim ylim]))
           hc = get(h, 'Children');
           hc(~arrayfun( @(h) isprop(h, 'XData' ) & isprop(h, 'YData' ), hc)) = [];
           xdata = get(hc, 'XData');
           if iscell(xdata)
               xdata = cellfun(@(x) x(:), xdata, 'uni', 0);
               xdata = cat(1, xdata{:});
           end
           ydata = get(hc, 'YData');
           if iscell(ydata)
               ydata = cellfun(@(x) x(:), ydata, 'uni', 0);
               ydata = cat(1, ydata{:});
           end
           isplotted = ~isinf(xdata) & ~isnan(xdata) & ...
                       ~isinf(ydata) & ~isnan(ydata);
           xdata = xdata(isplotted);
           ydata = ydata(isplotted);
           if isempty(xdata)
               xdata = [0 1];
           end
           if isempty(ydata)
               ydata = [0 1];
           end
           if isinf(xlim(1))
               xlim(1) = min(xdata);
           end
           if isinf(xlim(2))
               xlim(2) = max(xdata);
           end
           if isinf(ylim(1))
               ylim(1) = min(ydata);
           end
           if isinf(ylim(2))
               ylim(2) = max(ydata);
           end
       end

       dx = diff(xlim);
       dy = diff(ylim);
       dar = get(h, 'DataAspectRatio');
       pbar = get(h, 'PlotBoxAspectRatio');

       limDarRatio = (dx/dar(1))/(dy/dar(2));
       pbarRatio = pbar(1)/pbar(2);
       axisRatio = axisPos(3)/axisPos(4);

       if darismanual
           if limDarRatio > axisRatio
               pos(1) = axisPos(1);
               pos(3) = axisPos(3);
               pos(4) = axisPos(3)/limDarRatio;
               pos(2) = (axisPos(4) - pos(4))/2 + axisPos(2);
           else
               pos(2) = axisPos(2);
               pos(4) = axisPos(4);
               pos(3) = axisPos(4) * limDarRatio;
               pos(1) = (axisPos(3) - pos(3))/2 + axisPos(1);
           end
       elseif pbarismanual
           if pbarRatio > axisRatio
               pos(1) = axisPos(1);
               pos(3) = axisPos(3);
               pos(4) = axisPos(3)/pbarRatio;
               pos(2) = (axisPos(4) - pos(4))/2 + axisPos(2);
           else
               pos(2) = axisPos(2);
               pos(4) = axisPos(4);
               pos(3) = axisPos(4) * pbarRatio;
               pos(1) = (axisPos(3) - pos(3))/2 + axisPos(1);
           end
       end
   end

   % Convert plot box position to the units used by the axis
   hparent = get(h, 'parent');
   hfig = ancestor(hparent, 'figure'); % in case in panel or similar
   currax = get(hfig, 'currentaxes');

   temp = axes('Units', 'Pixels', 'Position', pos, 'Visible', 'off', 'parent', hparent);
   set(temp, 'Units', currunit);
   pos = get(temp, 'position');
   delete(temp);

   set(hfig, 'currentaxes', currax);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

