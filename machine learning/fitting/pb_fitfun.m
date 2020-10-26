function [ypred,parameters_opt] = pb_fitfun(x,fun_handle,varargin)
% PB_FITFUN
%
% PB_FITFUN(X,myfun) will fit any function to any temporally linear dataset 
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   % Varargin
   parameters     = pb_keyval('parameters',varargin,[]);
   startpar       = pb_keyval('starpar',varargin,'random');
   minfun         = pb_keyval('minfun',varargin,'rmse');
   
   parametersz    = readinputfun(fun_handle);  
   
   % Set starting parameters (It's better to estimate your own starting parameters!)
   if isempty(parameters)
      switch startpar
         case 'zeros'
            parameters = zeros(parametersz);
         case 'random'
            parameters = randn(parametersz);
         case 'otherwise'
         error('Not a valid optimization function!');
      end
   end
  
   % Set optimization function
   switch minfun
      case 'ssd'
         ds             = @(parameters) sum(fun_handle(parameters)-x).^2;
      case 'rmse'
         ds             = @(parameters) sqrt(mean((x - fun_handle(parameters)).^2));
      case 'otherwise'
         error('Not a valid optimization function!');
   end
   
   % Minimize prediction error
   parameters_opt = fminsearch(ds,parameters);
   ypred          = fun_handle(parameters_opt);
end

function parametersz = readinputfun(fun)
   str         = functions(fun).function;
   parstr      = str(3:min(strfind(str,')'))-1);
   parametersz = size(strfind(str,[parstr '(']));  
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

