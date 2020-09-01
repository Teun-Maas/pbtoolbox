function obj = set_normalisation(obj,method)
% SET_NORMALISATION
%
% SET_NORMALISATION(OBJ,METHOD) sets normalisation method for pre and
% postprocessing of network
%
% See also PB_VOLTERRA

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   switch method
      case 'mapminmax'
         method = 'mapminmax';
      otherwise
         method = 'none';
   end

   obj.proccess.normalisation = method;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

