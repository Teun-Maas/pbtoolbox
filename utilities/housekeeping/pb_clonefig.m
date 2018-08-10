function h = pb_clonefig(fID)
% PB_CLONEFIG(fID)
%
% Creates a clone from a graphic object.
%
% PB_CLONEFIG(fID) clobes figure into new empty figure. If no imput was 
% provided, default figure is gcf.
%
% See also PB_NICEGRAPH, PB_FOBJ
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   g = pb_fobj(groot,'Type','Figure');
   
   if isempty(g); return; end
   if nargin == 0; fID = gcf; end

   h = copyobj(fID,groot);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

