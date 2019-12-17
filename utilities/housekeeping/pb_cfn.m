function cfn = pb_cfn(varargin)
% PB_CFN
%
% PB_CFN  returns current figure number
%
% See also pb_newfig

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl
   
   g = groot;
   if isempty(g.CurrentFigure)
      cfn = 0;
   else
      cfn = g.CurrentFigure.Number;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

