function [cfn,f] = pb_newfig(cfn, varargin)
% PB_NEWFIG(cfn)
%
% PB_NEWFIG(cfn) opens a new figure, and increments the figure count.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin == 0 ; cfn = 0; end
   if isempty(cfn); cfn = 0; end
   
   ws = pb_keyval('ws',varargin,'Docked');

   cfn = cfn+1; f = figure(cfn); clf;
   set(f, 'WindowStyle', ws);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

