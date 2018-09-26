function handles = pb_getblock(handles)
% PB_GETBLOCK(HANDLES)
%
% PB_GETBLOCK(HANDLES) retracts block info provided by the exp file. 
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP.

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg            = handles.cfg;
   
   [block, cfg]   = pb_vReadExp(cfg);
   block          = pb_vPrimeZ(block,cfg);
   
   handles.block  = block;
   handles.cfg    = cfg;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

