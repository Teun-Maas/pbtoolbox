function pb_clear(varargin)
% PB_CLEAR(varargin)
%
% PB_CLEAR() clears the base workspace with the exception of variables
% passed along to varargin.
%
% See also PB_CLEAN

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   list     = evalin('base', 'who');
   listsz   = length(list);
   listArr  = 1 : listsz;
   
   keep     = varargin';
   keepsz   = length(keep);

   for iKeep = 1 : keepsz
      var      = keep{iKeep};
      idx      = find(strcmp(list,var));
      if ~isempty(idx)
         list     = list(listArr(listArr~=idx));
         listsz   = length(list);
         listArr  = 1:listsz;
      end
   end
   
   listsz   = length(list);
   if listsz > 0
      baseCommand = 'clear(';
      for iClear = 1 : listsz
         baseCommand    = [baseCommand '''' list{iClear} ''''];
         if iClear < listsz
            baseCommand = [baseCommand ','];
         else
            baseCommand = [baseCommand ')'];
         end
      end
      evalin('base', baseCommand)
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

