function parse_va(obj,varargin)
% PB_DRAFT>PARSE_VA
%
% OBJ.PARSE_VA(varargin) will parse varargin from the draft-object when 
% it is constructed.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% READ DATA
   %  Read Data, and set keyvals
   
   v = varargin;

   pva.x             = pb_keyval('x',v,[]);
   pva.y             = pb_keyval('y',v,[]);
   pva.z             = pb_keyval('z',v,[]);
   pva.def           = pb_keyval('def',v,1);
   pva.color         = pb_keyval('color',v,ones(length(pva.x),1));
   pva.axis          = pb_keyval('axis',v,'square');
   pva.subtitle      = pb_keyval('subtitle',v);
   
   obj.labels.xlab   = pb_keyval('xlab',v,'');
   obj.labels.ylab   = pb_keyval('ylab',v,'');
   
   %  Check data continuity for colouring
   pva.continious = false;
   if length(unique(pva.color))>5 && ~prod(floor(pva.color) == pva.color)
      pva.continious = true;
   end
   
   obj.pva = pva;
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

