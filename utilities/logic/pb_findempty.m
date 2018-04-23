function [ind, log] = pb_findempty(varargin)
% PB_FINDEMPTY()
%
% Creates a template function for PBToolbox.
%
% PB_FINDEMPTY()  ...
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

    if nargin<1
        return
    end

    log = zeros(1,nargin);
    
    for i = 1:nargin
        log(i) = isempty(varargin{i});
    end

    ind = find(log == 1);    
    
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

