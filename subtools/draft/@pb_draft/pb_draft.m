classdef pb_draft < handle
% PB_DRAFT
%
% d = pb_draft creates a instance of a DRAFT figure.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   properties (Access = public)
      title = []; 
      ...
   end

      methods (Access = public)

         function obj = pb_draft(varargin)
            set_title(obj);
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

