function obj = update_app_handle(obj,mode)
% UPDATE_APP_HANDLE
%
% UPDATE_APP_HANDLE  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if ~isempty(obj.app_handle)
      switch mode
         case 'epoch'
            obj.app_handle.step = obj.app_handle.step+1;
            waitbar(obj.app_handle.step/obj.num_epochs, obj.app_handle.handle, sprintf('Epoch: %1d/%1d',obj.app_handle.step,obj.num_epochs))
      end
   end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 