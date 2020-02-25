function pb_setlatex
% PB_SETLATEX()
%
% PB_SETLATEX()  ...
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl


   %  Set Interpreters
   set(groot,  'defaulttextinterpreter','latex', ...
               'defaultAxesTickLabelInterpreter','latex', ...
               'defaultLegendInterpreter','latex');
   
   %  Set Font
   font = 'Computer Modern'; 
   set(groot, 'defaultAxesFontSize', 20)
   set(groot,  'defaultUicontrolFontName',font, ...
               'defaultUitableFontName',font, ...
               'defaultAxesFontName',font, ...
               'defaultTextFontName',font, ...
               'defaultUipanelFontName',font, ...
               'defaultLegendFontName', font);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

