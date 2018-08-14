function h = pb_clonefig(fID,parent)
% PB_CLONEFIG(fID)
%
% Creates a clone from a graphic object.
%
% PB_CLONEFIG(fID) clones figure into new empty figure. If no imput was 
% provided, default figure is gcf.
%
% See also PB_NICEGRAPH, PB_FOBJ
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   g = pb_fobj(groot,'Type','Figure');

   if isempty(g); return; end
   if nargin == 0; fID = gcf; parent = groot; end
   if nargin == 1; parent = groot; end

   h = copyobj(fID,parent);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

