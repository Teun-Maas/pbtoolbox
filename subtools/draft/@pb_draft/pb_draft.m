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
   properties (Access=protected,Hidden=true)
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
         parse_va(obj,varargin{:}); 
      end
      
      set_title(obj,title,varargin);
      set_legend(obj,varargin);
      set_labels(obj,varargin);
      set_grid(obj,varargin);
      
      plot_rawdata(obj,varargin);               % plot the rawdata
      plot_hline(obj,varargin);                 % plot horizontal lines
      plot_vline(obj,varargin);                 % plot vertical lines
      plot_dline(obj,varargin);                 % plot diagonal lines
      plot_bubble(obj,varargin);                % plot bubblr histoplot
      
      stat_regres(obj,varargin);                % transform regression
      stat_probit(obj,varargin);                % transform probit
      
      fit_ellipse(obj,varargin);                % make ellipse fit
      fit_sigmoid(obj,varargin);                % make sigmoidal fit
      fit_polyn(obj,varargin);                  % make polynomial fit
      
      draft(obj);                               % make plot
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

