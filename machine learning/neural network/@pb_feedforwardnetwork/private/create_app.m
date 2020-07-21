function obj = create_app(obj)
% CREATE_APP
%
% CREATE_APP  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if obj.visualize_training
      obj.app_handle.handle   = waitbar(0,'1','Name','Epoch iteration...');
      obj.app_handle.step     = 0;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 