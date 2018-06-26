function fname = pb_checkext(fname,ext)
% PB_CHECKEXT(FNAME,EXT)
%
% PB_CHECKEXT(FNAME,EXT) checks if filename contains a specific extension already, if not it
% provides the filename with the extension.
%
% See also PB_WRITEFUN, PB_FEXT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

    strBool = contains(fname,ext);
    if ~strBool
        fname = [fname ext];
    end
    checkValid(fname);
end

function checkValid(fname)
    % Checks for multiple dots: i.e. indication of mismatched extensions.
    check = length(strfind(fname, '.'));
    if check>1
        error('Error. Extensions do not match.')
    end
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

