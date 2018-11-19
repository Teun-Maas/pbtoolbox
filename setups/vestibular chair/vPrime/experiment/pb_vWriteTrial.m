function pb_vWriteTrial(fid,trlIdx)
% PB_VWRITETRIAL(fid, trlIdx)
%
% PB_VWRITETRIAL(fid, trlIdx)  writes trial announcement in expfile.
%
% See also PB_VGENVISEXP, PB_VWRITEBLOCK

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin < 2; trlIdx = 0; end
   
   fprintf(fid,'\n');
   fprintf(fid,'%s\n',['% Trial: ' num2str(trlIdx)]);
   fprintf(fid,'%s\n','==>');
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

