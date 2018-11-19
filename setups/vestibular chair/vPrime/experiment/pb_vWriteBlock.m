function pb_vWriteBlock()
% PB_VWRITEBLOCK()
%
% PB_VWRITEBLOCK()  ...
%
% See also ...

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

