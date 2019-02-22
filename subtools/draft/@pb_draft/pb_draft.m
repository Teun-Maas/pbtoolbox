classdef pb_draft < matlab.mixin.Copyable
% PB_DRAFT
%
% d = pb_draft creates a instance of a DRAFT object. 
%
% See also DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Properties
   
   %  Set public properties
   properties (Access = public)
      h_title
      h_ax_legend
      h_ax_labels
      h_ax_plot
      results
      ...
   end

   %  Set protected properties
   properties (Access = protected, Hidden = true)
      parent      = [];
      
      pva;
      labels;
      
      dplot       = {};
      
      % title
      title       = '';
      title_O     = {};
      subtitle    = '';
      subtitle_O  = {};
      ...
   end

   %% Methods
   
   %  Define public methods
   methods (Access = public)

      % Constructor function
      function obj = pb_draft(varargin)
         % read and parse varargin
         parse_va(obj,varargin{:});             % read parse keys
      end
      
      %  Set functions
      set_title(obj,title,varargin);            % set title
      set_legend(obj,varargin);                 % set legend               /// NOT YET DONE
      set_labels(obj,varargin);                 % set labels
      set_grid(obj,varargin);                   % set grid
      set_axcomp(obj,feature,varargin);         % set comparision axe      /// WORKING ON IT
      
      %  Plot functions
      plot_rawdata(obj,varargin);               % plot the rawdata
      plot_hline(obj,varargin);                 % plot horizontal lines
      plot_vline(obj,varargin);                 % plot vertical lines
      plot_dline(obj,varargin);                 % plot diagonal lines
      plot_bubble(obj,varargin);                % plot bubble histoplot
      
      %  Statistical functions
      stat_regres(obj,varargin);                % transform regression     // NOT YET DONE
      stat_probit(obj,varargin);                % transform probit
      
      %  Fitting functions
      fit_ellipse(obj,varargin);                % make ellipse fit
      fit_sigmoid(obj,varargin);                % make sigmoidal fit
      fit_polyn(obj,varargin);                  % make polynomial fit
      
      %  Core functions
      draft(obj);                               % draw figure
      print(obj,varargin);                      % make file

      function obj = set_parent(obj,parent)
         obj.parent = parent;
      end
   end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

