function ncol = pb_brighten(col,varargin)
% PB_BRIGHTEN()
%
% PB_BRIGHTEN()  ...
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl


   k = pb_keyval('factor',varargin,0.2);
   
   for iC = 1:size(col,1)
      reverse_color     = 1-col(iC,:);
      add_brightness    = (reverse_color * k);
      ncol(iC,:)        = col(iC,:) + add_brightness;
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

