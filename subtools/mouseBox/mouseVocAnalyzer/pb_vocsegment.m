function [nsnippets] = pb_vocsegment(fn,varargin)
% PB_VOCSEGMENT()
%
% PB_VOCSEGMENT()  ...
%
% See also ...

% PBToolbox (2019): JJH: j.heckman@donders.ru.nl

   % Varargins
   v           = varargin;
   sniplen     = pb_keyval('length',v,5);      % Snippet length in time (s).
   storedir    = pb_keyval('cdir',v,'snippets');
   
   % Read sound
   [audioT,Fs]  = audioread(fn);
   audiolen    = length(audioT);
   nSamples    = sniplen * Fs;
   
   [rem,rep]   = pb_mod(audiolen,nSamples);
   
   % Storing
   ind      = strfind(fn,filesep);
   p        = fn(1:ind(end));
   fnSnip   = [p  'snippets' filesep 'R_voc_s'];
   
   for iRep = 1:rep+1 
      % Segmentate
      start       = (iRep-1) * nSamples + 1;
      stop        = iRep * nSamples;
      if iRep > rep
         stop     = start + rem;
      end
      
      audio  = audioT(start:stop);
      save([fnSnip num2str(iRep,'%04.f')],'audio','Fs');
   end
   nsnippets = iRep;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

