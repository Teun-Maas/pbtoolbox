function [cfn,f] = pb_newfig(cfn, varargin)
% PB_NEWFIG(cfn)
%
% PB_NEWFIG(cfn) opens a new figure, and increments the figure count.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin == 0 ; cfn = 0; end
   if isempty(cfn); cfn = 0; end
   
   units = pb_keyval('units',varargin,'centimeters');
   ws    = pb_keyval('ws',varargin,'normal');
   rsz   = pb_keyval('resize',varargin,'on');
   sz    = pb_keyval('size',varargin,[0 0 17 11]); 

   cfn = cfn+1; f = figure(cfn); clf;
   
   % set figure
   set(f,'WindowStyle',ws);
   set(f,'Units',units);
   set(f,'Resize',rsz)
   
   if ~strcmp(ws,'Docked'); set(f, 'Position',sz); end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

