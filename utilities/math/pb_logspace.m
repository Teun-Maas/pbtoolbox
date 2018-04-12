function y = pb_logspace(d1, d2, n, base)
% PB_LOGSPACE()
%
% Creates a template function for PBToolbox.
%
% PB_LOGSPACE()  ...
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
    if nargin == 2
        n = 50;
        base = 10;
    end

    if d2 == pi || d2 == single(pi) 
        d2 = pb_log(d2, base);
    end

    y = base .^ linspace(d1, d2, n);

end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

