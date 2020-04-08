function nfn = pb_nextfigurenumber
% PB_NEXTFIGURENUMBER
%
% PB_NEXTFIGURENUMBER will find the highest figure number among your
% current figures, and returns it +1.
%
% See also PB_NEWFIG, PB_SELECTFIG

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   %  Get figure handles
   g  = groot;
   f  = g.Children;
   
   flen     = length(f);
   numbers  = zeros(flen,1);  % Preallocate
   
   %  Loop over figure handles
   for iF = 1:flen
      numbers(iF) = f(iF).Number;
   end
   %  Return
   nfn = max(iF)+1;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

