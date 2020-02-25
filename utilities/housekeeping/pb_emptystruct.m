function sobj = pb_emptystruct(sz, varargin)
% PB_EMPTYSTRUCT()
%
% PB_EMPTYSTRUCT()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   if nargin == 0; sz = 0; end
   if isempty(varargin)
      S  = struct([]);
   else
      S 	= struct(varargin);
   end
   
   for iS = 1:sz(1)
      sobj(iS) = S;
   end
   if length(sz) == 2
      for iS = 1:sz(2)
         sobj(iS,2) = S;
      end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

