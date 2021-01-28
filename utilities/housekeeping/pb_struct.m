function S = pb_struct(fields,data)
% PB_STRUCT()
%
% PB_STRUCT()  ...
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

   if size(fields)~=size(data); return; end % assert
   
   S = struct(fields{1},data{1});
   
   for iL = 2:length(fields)
      S = setfield(S,fields{iL},data{iL});
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

