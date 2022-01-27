function [C,idx] = pb_datesort(C,varargin)
% PB_DATESORT()
%
% PB_DATESORT()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

   
   direction = pb_keyval('direction',varargin,'descend');   % descend will get newest datestr on top
   
   % assert
   if ~isa(C,'cell'); error('T is not a cell.'); end
   
   Clen  = length(C);
   dn    = zeros(Clen,1);
   
   for iC = 1:Clen
      dn(iC) = datenum(C(iC));
   end
   
   [~,idx]  = sort(dn,direction);
   C        = C(idx);  
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

