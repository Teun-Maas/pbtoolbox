function obj = set_normalisation(obj,varargin)
% SET_NORMALISATION
%
% SET_NORMALISATION(OBJ,METHOD) sets normalisation method for pre and
% postprocessing of network
%
% See also PB_VOLTERRA

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl

   input       = pb_keyval('input',varargin, @(x)x);           % no normalisation
   output      = pb_keyval('output',varargin, @(x)x);
   
   if output(10)<10; output = matlabFunction(finverse(sym(output))); end
   
   obj.process.normalisation.input     = input;
   obj.process.normalisation.output    = output;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

