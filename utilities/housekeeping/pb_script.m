function pb_script(varargin)
% PB_SCRIPT()
%
% Creates a template analyses script for PBToolbox.
%
% See also PB_WRITESCRIPT, PB_CHECKEXT, PB_EDIT, PB_WRITEFUN
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

    
    %% Initialization
    
    pbt_D = '/Users/jjheckman/Documents/Code/Matlab/PBToolbox/analyses/scripting/';
    cd(pbt_D);
    
    switch nargin
        case 0
            [fname,path] = uiputfile({'*.m'},'Save file name');
            if fname == 0; return; end
        case 1
            fname   = varargin{1};
            path    = which(fname);
            if isempty(path)
                path    = pbt_D;
            else
                edit(path);
                return
            end
        case 2
            fname   = varargin{1};
            if varargin{2}(end) ~= '/' 
                varargin{2} = [varargin{2} '/']; 
            end
            path    = [pbt_D varargin{2}];
        case 3
            error('Error: Too much input arguments.');
    end
    
    fname   =   pb_checkext(fname,'.m');
    file    =   [path fname];
    
    if ~exist(path,'dir')
        mkdir(path);
        addpath(genpath(path));
    end
    
    cd(path);
    
    if ~exist(file,'file')
        pb_writescript(path, fname);
    end
    
    edit(file);


 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

