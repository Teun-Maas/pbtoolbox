function [snum,sdenom,str] = pb_splitTF(sys, varargin)
% PB_SPLITTF
%
% PB_SPLITTF(sys) will split your TF model into its NUMERATOR and
% DENOMINATOR component (symbolic equation).
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

   if ~isa(sys,'idtf'); return; end
   
   N_POLES   = length(sys.Denominator)-1;
   N_ZEROES  = length(sys.Numerator)-1;
   
   % build symolic expressions
   syms s;
   sdenom   = 0;
   snum     = 0;
   
   % Extract coefficients
   num      = sys.Numerator;
   denom    = sys.Denominator;
   
   str_num = [];
   % Read Numerator
   for iZ = 1:N_ZEROES+1
      snum = snum + num(iZ)* s^(length(num)-iZ);
      
%       
%       if num(iZ) == 1
%          str_num = [str_num, 's^' num2str((length(num)-iZ))];
%       else
%          if num2str((length(num)-iZ)) > 0
%             str_num = [str_num, num2str(num(iZ),3) 's^' num2str((length(num)-iZ))];
%          else 
%             str_num = [str_num, num2str(num(iZ),3)];
%          end
%       end
   end
   
   str_denom = [];
   % Read Denominator
   for iP = 1:N_POLES+1
      sdenom = sdenom + denom(iP)* s^(length(denom)-iP);
      
%       str_denom = [str_denom, num2str(denom(iP)) 's^' num2str((length(denom)-iP),3)]
   end
   
   str = [];
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

