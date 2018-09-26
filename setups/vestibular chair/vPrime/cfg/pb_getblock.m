function handles = pb_getblock(handles)
% PB_GETBLOCK()
%
% PB_GETBLOCK()  ...
%
% See also ...

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

