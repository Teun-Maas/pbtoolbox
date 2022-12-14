function pb_nicegraph(varargin)
% PB_NICEGRAPH(VARARGIN)
%
% PB_NICEGRAPH(VARARGIN) adjusts figure settings for all axes in current or
% selected figure. Optional input arguments are: figure, color def, conditions
% and colmatch.
% 
% See also PB_DEFSUBPLOTS, PB_NICEBOXPLOT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Initialization: Define axes, colorschemes, & plots

	fig         =   pb_keyval('fig',varargin,gcf);
	def         =   pb_keyval('def',varargin,2);
	conditions  =   pb_keyval('conditions',varargin,1);
	linewidth   =   pb_keyval('linewidth',varargin,1);
   font        =  pb_keyval('font',varargin,'Times New Roman');
   fsize       =  pb_keyval('fontsize',varargin,20);

	ax      = pb_fobj(gcf,'Type','Axes');
	if ax<1; return; end

	[n,p] = pb_defsubplot(fig); 

	if max(p)>0
      ncol    = max(p)*conditions; 
      col     = pb_selectcolor(ncol,def);
	else
      ncol    = 0;
      col     = [];
   end
   
	col = flipud(col);
   
   %% Set Fonts
   
   % COLORBAR:
   h_cbar = pb_fobj(gcf,'Type','Colorbar');
   
   for i = 1:length(h_cbar)
      h_cbar(i).FontName = font;
   end

   %% Body: Make nice graphs
	for i = 1:n

      % Set axis properties
      setAx = ax(i);

      setAx.Box           = 'off';
      setAx.TickDir       = 'out';
      setAx.TickLength    = [.02 .02];
      setAx.XMinorTick    = 'on';
      setAx.YMinorTick    = 'on';
      setAx.YGrid         = 'on';
      setAx.XGrid         = 'on';
      setAx.XColor        = [.3 .3 .3];
      setAx.YColor        = [.3 .3 .3];
      setAx.FontSize      = fsize;
      setAx.YDir          = 'normal';
      setAx.LineWidth     = 1;
      
      SetAx.FontName = font; 

      % LINE:
      %
      % Use as 'primary' data
      h_line = pb_fobj(ax(i),'Type','Line','-not','Tag','Fixed');

      for j=1:length(h_line)
         set(h_line(length(h_line)+1-j), ...
         'Color'         , col(j,:)  , ...
         'LineWidth'     , linewidth         );
      end
      
      % FUNCTIONLINE:
      %
      % Use as 'primary' data
      h_fline = pb_fobj(ax(i),'Type','FunctionLine','-not','Tag','Fixed');

      for iFline=1:length(h_fline)
         set(h_fline(length(h_fline)+1-iFline), ...
         'Color'         , col(iFline,:)  , ...
         'LineWidth'     , linewidth         );
      end

      % ERRORBAR:
      %
      % Use as 'primary' data
      h_error = pb_fobj(ax(i),'Type','ErrorBar','-not','Tag','Fixed');

      for j=1:length(h_error)
         set(h_error(length(h_error)+1-j), ...
         'Color'         , col(j,:)  , ...
         'LineWidth'     , linewidth         );
      end

      % BAR:
      %
      % Use as 'primary' data
      h_bar = pb_fobj(ax(i),'Type','Bar','-not','Tag','Fixed');

      for k=1:length(h_bar)
         set(h_bar(k), ...
         'FaceColor'         , col(k,:)  , ...
         'EdgeColor'         , col(k,:)./2, ...
         'LineWidth'         , linewidth         );
         if length(h_bar) > 1
            set(h_bar(k), ...
           'FaceAlpha'     , 0.66);
         end
      end

      % HISTOGRAM:
      % 
      % Use as 'primary' data
      h = pb_fobj(ax(i),'Type','Histogram','-not','Tag','Fixed');

      for l=1:length(h)
      set(h(l), ...
      'FaceColor'         , col(l,:)  , ...
      'EdgeColor'         , col(l,:)./2, ...
      'LineWidth'         , linewidth         );
      if length(h) > 1
      set(h(l), ...
      	'FaceAlpha'     , 0.66);
      end
      end

      % SCATTER: 
      %
      % Use as 'background' data for fits and regressions
      h = pb_fobj(ax(i),'Type','Scatter','-not','Tag','Fixed');
      ScatCol = pb_statcolor(length(h)+1,[],[],[],'def',5);

      for iScat = 1:length(h)
         DotSize = 36; %DSize(length(h(iScat).XData));
         set(h(iScat), ...
         'Marker'            , 'o' , ...
         'MarkerFaceColor'   , ScatCol(1,:), ...
         'MarkerEdgeColor'   , ScatCol(1,:), ...
         'SizeData'          , DotSize, ...
         'HandleVisibility'  , 'off');      
      end


      % AREA: 
      % 
      % Use as 'range' to match with fitted data plots.
      h = pb_fobj(ax(i),'Type','Area','-not','Tag','Fixed');
      AreaCol = pb_statcolor(length(h)+1,[],[],[],'def',5);

      for iArea = 1:length(h)
         set(h(iArea), ...
         'FaceColor'         , AreaCol(iArea,:)  , ...
         'LineStyle'         , 'none' , ...
         'FaceAlpha'         , 0.4);
      end

      % PATCH: 
      % 
      % Use as 'range' to match with fitted data plots.
      h = pb_fobj(ax(i),'Type','Patch','-not','Tag','Fixed');
      PatchCol = pb_statcolor(length(h)+1,[],[],[],'def',1);

      for iPatch = 1:length(h)
         set(h(iPatch), ...
         'FaceColor'         , col(iPatch,:) , ...
         'LineWidth'         , 1             , ...        
         'LineStyle'         , '--'          , ...
         'EdgeColor'         , [0 0 0]  , ...
         'FaceAlpha'         , 0.3);
      end
      
      % STEM:
      %
      % Use as 'primary' data
      h_stem = pb_fobj(ax(i),'Type','Stem','-not','Tag','Fixed');

      for iStem=1:length(h_stem)
         set(h_stem(length(h_stem)+1-iStem), ...
         'Color'         , col(iStem,:)  , ...
         'MarkerFaceColor', col(iStem,:)  , ...
         'LineWidth'     , linewidth*1.5         );
      end
      
   end
   pb_highlightaxes(gcf);
end

function DotSize = DSize(NDots)
   % Defines the DotSize for scatterplot
   DotSize = 2500/NDots;
   if DotSize < 36
      DotSize = 36;
   end
end



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 