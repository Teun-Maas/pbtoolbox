function normdata = pb_normalize(data,varargin)
% PB_NORMALIZE()
%
% PB_NORMALIZE()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl
   
   order    = pb_keyval('order',varargin,50);
   datasz 	= size(data);
   dim      = length(datasz);
   
   mind     = data;
   maxd     = data;
   for iD = 1:dim
      mind = min(mind);
      maxd = max(maxd);
   end
   
   for iR = 1:datasz(1)
      for iC = 1:datasz(2)
         normdata(iR,iC) = data(iR,iC)^order;
      end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

