classdef pb_draft < matlab.mixin.Copyable
% PB_DRAFT
%
% d = pb_draft creates a instance of a DRAFT figure.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Properties
   
   %  Set public properties
   properties (Access = public)
      title = []; 
      ...
         
   end

   %  Set protected properties
   properties (Access=protected,Hidden=true)
      parent = [];
      ...
         
   end

   %% Methods
   
   %  Define public methods
   methods (Access = public)

      % Constructor function
      function obj = pb_draft(varargin)
         set_title(obj);
         ...
            
      end
      
      obj = create_figure(obj,fig)
      obj = draft(obj);

      function obj=set_parent(obj,parent)
         obj.parent = parent;
         ...
      end
   end

   ...
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

