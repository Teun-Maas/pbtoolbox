function pb_savefig(varargin)
% PB_SAVEFIG()
%
% Creates a template function for PBToolbox.
%
% PB_SAVEFIG()  ...
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
    cd('/Users/jjheckman/Documents/Data/PhD/Figure');
    
    g = groot;
    
    if nargin == 0
        filter = {'*.fig';'*.pdf'};
        [file, path] = uiputfile(filter);        
    end

 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

