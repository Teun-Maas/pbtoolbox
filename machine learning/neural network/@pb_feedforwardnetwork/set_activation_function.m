function obj = set_activation_function(obj,fun)
% SET_ACTIVATION_FUNCTION
%
% SET_ACTIVATION_FUNCTION  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

 
   obj.activation_function = @tansig;%fun;
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 