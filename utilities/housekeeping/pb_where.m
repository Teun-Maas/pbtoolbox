function out = pb_where(varargin)
% PB_WHERE()
%
% PB_WHERE()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   if nargin == 0; return; end
   
   fn = which(varargin{1});
   if isempty(fn); return; end
   
   p = fn(1:end-(length(varargin{1})+2));
   
   if nargout == 1
      out = p;
   else
      disp(p);
      clipboard('copy',p);
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

