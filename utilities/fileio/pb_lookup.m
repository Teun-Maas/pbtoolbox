function array = pb_lookup(array, varargin)
% PB_LOOKUP()
%
% PB_LOOKUP()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   fn    = pb_keyval('fn',varargin,[]); [~,sheets] = xlsfinfo(fn);
   sheet = pb_keyval('sheet',varargin,sheets{end}); 
   
   if nargin == 0; return; end
   if isempty(fn); return; end
   
   [num,~,~] = xlsread(fn,sheet);
   
   for i = 1:numel(array)
      array(i) = num(num(:,1)==array(i),2);
   end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

