function [ID,az,el] = pb_lookup(array, varargin)
% PB_LOOKUP(array,varargin)
%
% PB_LOOKUP() converts array using a lookup table. For instance, when
% working with the VC setup, parrallel PLC transform LED IDs. This lookup
% table allows you to logically select the correct ID.
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   VC    = [pb_userpath 'setups/vestibular chair/vPrime/lookup/vPrime Measurement.xlsx'];
   fn    = pb_keyval('fn',varargin,VC); [~,sheets] = xlsfinfo(fn);
   sheet = pb_keyval('sheet',varargin,sheets{end}); 
   
   if nargin == 0; return; end
   if isempty(fn); return; end
   
   [num,~,~] = xlsread(fn,sheet);
   
   for i = 1:numel(array)
      array(i) = num(num(:,1)==array(i),2);
   end
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

