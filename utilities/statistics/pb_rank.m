function rank = pb_rank(vector,direction)
% PB_RANK()
%
% PB_RANK()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

   if nargin == 1; direction = 'ascend'; end
   
   switch direction
      case 'descend'
         for iV = 1:length(vector)
            vector(iV)  = inv(vector(iV));
         end
   end
   [~,rank]       = ismember(vector,unique(vector));
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

