function pb_delobj(varargin)
% PB_DELOBJ
%
% PB_DELOBJ(varargin) will delete all objects parsed. 
% On OS X it is also possible to use: delete([obj1,obj2,obj3...])
%
% See also DELETE

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   if nargin == 0; return; end
   for idx = 1:length(varargin)
      delete(varargin{1});
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

