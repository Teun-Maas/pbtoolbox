function [M] = pb_mergesacdat(varargin)
% M = PB_MERGESACDAT(M1,M2) or N = PB_MERGESACDAT(M1, M2, M3, M4...)
%
% This function merges any number data arrays into one. 
% see also MSINDEX, SUPERSAC

% 2018 Jesse J. Heckman
% e-mail: j.heckman@donders.ru.nl

    narginchk(1, Inf)

    M = [];

    for i=1:length(varargin)
        M = [M;varargin{i}];
    end
end