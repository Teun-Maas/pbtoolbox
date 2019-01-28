function invidx = pb_invidx(arr,idx)
% PB_INVIDX
%
% PB_INVIDX(arr, idx) calculates reverse array indexing (useful for subplotting).
%
% See also SUBPLOT, PB_DRAFT, DRAFT.

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   sz       = arr;
   c        = mod(idx,sz(2)); if c==0; c = sz(2); end
   r        = floor(idx/sz(2))+1-(idx/sz(2)==floor(idx/sz(2)));
   invidx   = sub2ind(sz,r,c);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 