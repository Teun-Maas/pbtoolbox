function pb_savefig(varargin)
% PB_SAVEFIG()
%
% Creates a template function for PBToolbox.
%
% PB_SAVEFIG() FUNCTION NOT YET FINISHED
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

    fig     = pb_keyval('fig',varargin);
    fname   = pb_keyval('fname',varargin);
    dir     = pb_keyval('dir',varargin,'/Users/jjheckman/Documents/Data/PhD/Figure');
    cd(dir);
    
    g = groot;
    
    if nargin == 0 && ~isempty(g.Children)
        filter = {'*.fig';'*.pdf'};
        h = get(g,'currentFigure');
        [fname, path] = uiputfile(filter,[],strcat('Fig_',num2str(h.Number)));
    end
    if nargin >= 1 && ~isempty(g.Children)
    
    end
    
    h = get(g,'currentFigure');
    
    path = [path fname];
    
    savefig(h,path)
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

