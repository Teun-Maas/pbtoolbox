function [cfn,fig_handle] = pb_openfig(fn,cfn)
% PB_OPENFIG()
%
% PB_OPENFIG()  ...
%
% See also ...

% PBToolbox (2022): JJH: j.heckman@donders.ru.nl

   if nargin < 2; cfn = pb_cfn; end

   % Build figures
   fig_old           = openfig(fn);                                              % open figure
   [cfn,fig_handle]  = pb_newfig(cfn);
   
   copyobj(allchild(fig_old),cfn);                                                   % Copy figure handles
   delete(fig_old);                                                        % Delete old figure
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2022)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

