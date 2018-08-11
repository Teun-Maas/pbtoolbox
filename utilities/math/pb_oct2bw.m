function F = pb_oct2bw(F1,oct)
% PB_OCT2BW(F1,OCT)
%
% Generates sequence of F2 that lies oct octaves above F1.
%
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   F = F1 .* 2.^oct;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

