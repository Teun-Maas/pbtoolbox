function pb_setlatex
% PB_SETLATEX()
%
% PB_SETLATEX()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl


   %  Set Interpreters
   set(groot,  'DefaultAxesTickLabelInterpreter','latex', ...
               'DefaultLegendInterpreter','latex',...
               'DefaultTextInterpreter','latex')
  
   
   %  Set Font
   font = 'Didot';  % TrueType Fonts only!
   set(groot,  'DefaultAxesFontSize', 8,...
               'DefaultLegendFontSize', 8);
   set(groot,  'DefaultUicontrolFontName', font, ...
               'DefaultUitableFontName', font, ...
               'DefaultAxesFontName', font, ...
               'DefaultTextFontName', font, ...
               'DefaultUipanelFontName', font, ...
               'DefaultLegendFontName', font);
            
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

