function obj = update_app_handle(obj)
% UPDATE_APP_HANDLE
%
% UPDATE_APP_HANDLE  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if ~isempty(obj.app_handle)
      obj.app_handle.step = obj.app_handle.step+1;
      waitbar(obj.app_handle.step/length(obj.data.train.y), obj.app_handle.handle, sprintf('%1d',obj.app_handle.step))
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 