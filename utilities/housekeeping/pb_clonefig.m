function h = pb_clonefig(fID)
% PB_CLONEFIG(fID)
%
% Creates a clone from a graphic object.
%
% PB_CLONEFIG(fID)  
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 

    %% Initialize

    g = pb_fobj(groot,'Type','Figure');
    if isempty(g); return; end
    
    if nargin == 0
        fID = gcf;
    end
        
    h = copyobj(fID,groot);

 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

