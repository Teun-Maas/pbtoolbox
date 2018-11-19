function pb_vWriteBlock(fid, blckIdx)
% PB_VWRITEBLOCK(fid, blckIdx)
%
% PB_VWRITEBLOCK(fid, blckIdx) writes block announcement in expfile.
%
% See also PB_VGENVISEXP, PB_VWRITETRIAL

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   if nargin < 2; blckIdx = 0; end
   
   fprintf(fid,'\n');
   fprintf(fid,'~~~\n');
   fprintf(fid,'%s\n',['% Block: ' num2str(blckIdx)]);
   fprintf(fid,'%s\n','==>');
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

