function cout = pb_open(folder, varargin)
% PB_OPEN()
%
% PB_OPEN() opens directory.
%
% See also PB_MOUNTSERVER

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin == 0
      folder = '~/sharename';
   end
   
   if exist(folder,'dir')
      cin = ['open ' folder];
      cout = system(cin);
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

