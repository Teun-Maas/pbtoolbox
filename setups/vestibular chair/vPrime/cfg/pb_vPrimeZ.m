function block = pb_vPrimeZ(block,cfg)
% PB_VPRIMEZ(BLOCK, CFG)
%
% PB_VPRIMEZ(BLOCK, CFG) adds additional fields to 'block' in order to
% allow for TDT control of correct LSCs during experimentation. 
%
% See also PB_VPRIME, PB_VPRIME, PB_VRUNEXP, PB_GETBLOCK, PB_VREADEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   for iBlck = 1:cfg.Blocks
      
      ntrls = length(block(iBlck).trial);
      for iTrl = 1:ntrls
         
         nstms = length(block(iBlck).trial(iTrl).stim);
         for iStm = 1:nstms
            
            X = block(iBlck).trial(iTrl).stim(iStm); 
            if ~isempty(X)
               
               ZI = cfg.interpolant(block(iBlck).trial(iTrl).stim(iStm).azimuth,block(iBlck).trial(iTrl).stim(iStm).elevation);
               
               block(iBlck).trial(iTrl).stim(iStm).Z           = ZI;
               block(iBlck).trial(iTrl).stim(iStm).azimuth   	= cfg.lookup(ZI+1,4);
               block(iBlck).trial(iTrl).stim(iStm).elevation	= cfg.lookup(ZI+1,5);
               
            end
         end
      end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

