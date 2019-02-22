function set_axcomp(obj,parameter,varargin)
% PB_DRAFT>SET_AXCOMP
%
% SET_AXCOMP(obj,row,col,varargin) creates subplots that compare over a
% selected parameter.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   if nargin <2 || isempty(parameter); return; end
   
   v           = varargin;
   orient      = pb_keyval('orientation',v,'horizontal');
   f.prefix    = pb_keyval('prefix',v);
   f.feature   = parameter;
   
   n           = length(unique(parameter));
   if strcmp('horizontal',orient); f.r = 1; f.c = n; else; f.r = n; f.c = 1; end
   
   obj(1).pva.axcomp = f;
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% p=inputParser;
% my_addParameter(p,'scale','fixed'); %options 'free' 'free_x' 'free_y' 'independent'
% my_addParameter(p,'space','fixed'); %'free_x','free_y','free'
% my_addParameter(p,'force_ticks',false);
% my_addParameter(p,'column_labels',true);
% my_addParameter(p,'row_labels',true);
% parse(p,varargin{:});
% 
% obj.facet_scale=p.Results.scale;
% obj.facet_space=p.Results.space;
% obj.column_labels=p.Results.column_labels;
% obj.row_labels=p.Results.row_labels;
% 
% if strcmp(obj.facet_scale,'independent') %Force ticks by default in that case
%     obj.force_ticks=true;
% else
%     obj.force_ticks=p.Results.force_ticks;
% end
% 
% %Handle case where facet_grid is called after update()
% if obj.updater.updated
%     if isnumeric(obj.aes.row) && isnumeric(obj.aes.column) && all(obj.aes.row==1) && all(obj.aes.column==1)
%         if isempty(obj.aes.row) && isempty(obj.aes.column)
%             %User probably tried to update all the data
%             obj.updater.facet_updated=0;
%         else
%             %We go from one to multiple facets
%             obj.updater.facet_updated=1;
%         end
%     else
%         if isempty(row) && isempty(col)
%             %We go from multiple to one facet
%             obj.updater.facet_updated=-1;
%         else
%             error('Updating facet only works when going from one to multiple facets or vice versa');
%         end
%     end
% end
% 
% obj.aes.row=shiftdim(row);
% obj.aes.column=shiftdim(col);
% 
% obj.wrap_ncols=-1;
% end