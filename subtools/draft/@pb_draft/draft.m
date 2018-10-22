function obj = draft(obj)
% OBJ.DRAFT()
%
% DRAFT() ...
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   % If no parent was given we use the current figure
   if isempty(obj(1).parent)
      for iObj = 1:numel(obj)
      	obj(iObj).parent     = gcf;
      end
   end
   
   
   
   
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

