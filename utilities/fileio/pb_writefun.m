function pb_writefun(path,fname)
% PB_WRITEFUN(PATH,FNAME)
%
% Creates a template for PBToolbox functions.
%
% PB_EDIT(PATH,FNAME) generates default function template for PBToolbox, and stores it in the PBToolbox. Option al input
% parameters are 'function_name' and 'directory'. 
%
% See also PB_FWRITECOMMENTS, PB_CHECKEXT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
    
    fpath = [path fname];
    
    if exist(fpath,'file')
        return % safety measure
    end
    
    tpath = '/Users/jjheckman/Documents/Code/Gitlab/pbtoolbox/documentation/templates/';
    template = 'template_pbfun.txt';
    
    tText = fileread([tpath template]);
    tText = replace(tText,'[pb_name]',fname(1:end-2)); % omit extension (.m) 
    tText = replace(tText,'[PB_NAME]',upper(fname(1:end-2))); 
    tText = replace(tText,'[YEAR]',num2str(year(datetime('now'))));
    
    fid = fopen(fpath,'wt');
    fprintf(fid,'%s\n', tText);
    fclose(fid);

end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
