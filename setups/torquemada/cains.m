classdef cains < matlab.mixin.Copyable
% PB_VOLTERRA
% 
% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   properties (GetAccess = public, SetAccess = public)

   end
   
   properties (Access = public, Hidden = true)

   end

   properties (Access = protected, Hidden = true)    
      kv
   end

   methods (Access = public)
        
      % Constructor
      function obj = cains(varargin)
         % Build volterra-object

         %  Read input arguments
         %obj   = read_keyval(obj,varargin{:});

      end
   end
   
   methods (Access = private)
      %obj   = read_keyval(obj,varargin);
   end
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

