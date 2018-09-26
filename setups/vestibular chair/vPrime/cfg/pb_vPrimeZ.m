function block = pb_vPrimeZ(block,cfg)
% PB_VPRIMEZ()
%
% PB_VPRIMEZ()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg;
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

