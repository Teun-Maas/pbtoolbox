function path = pb_datapath(path)
% PB_DATAPATH()
%
% PB_DATAPATH()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   if nargin == 0; path = []; end
   if isempty(path) || ~exist(path)
      username = char(java.lang.System.getProperty('user.name'));
      if ismac                                                             % MAC       (personal   //    NO VC, NO TDT)
         path = ['/Users/' username '/Documents/Data/PhD/Experiment'];
      elseif isunix && ~ismac                                            	% LINUX     (public     //    VC, NO TDT)
         path = ['/home/' username '/Documents/Data'];
      elseif ispc                                                        	% WINDOWS   (public     //    VC, TDT)
         path = ['C:\Users\' username '\Documents\Data'];
      end  
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

