function cfg = pb_fmice(cfg,varargin)
% PB_FMICE(BW)
%
% PB_FMICE(BW) recursively seeks for 'mice-blobs'. If number of 'mice' and 
% 'blobs' match.., something happens
%
% See also ...
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   f     = cfg.CurrentFrame;
   bw    = ~cfg.Frame(f).BW;

   CC    = bwconncomp(bw);
   n     = CC.NumObjects;

   mice  = pb_keyval('mice',varargin,n);
   
   cfg.Frame(f).NumMice  = mice;
   cfg.Frame(f).CC      = CC;
   
   if n == mice
      cfg.Frame(f).MiceBlobMatch = true; 
         for IdxMouse = 1:n
            cfg.Frame(f).Mouse{IdxMouse}  = CC.PixelIdxList{IdxMouse};
            %cfg.Frame(f).Mouse{IdxMouse}   = [];
         end
      return 
   end
   cfg.Frame(f).MiceBlobMatch = false;

   disp([newline 'Note that the number of indicated Mice (' num2str(mice) ') and found Blobs (' num2str(n) ') did not match!' newline]);
end


function D = rec_fun
   % this function recursivly finds 

end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

