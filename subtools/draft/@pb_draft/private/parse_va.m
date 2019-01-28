function parse_va(obj,varargin)
% PB_DRAFT>PARSE_VA
%
% OBJ.PARSE_VA(varargin) will parse varargin from the draft-object when 
% it is constructed.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   v = varargin;
   
   pva.x          = pb_keyval('x',v,[]);
   pva.y          = pb_keyval('y',v,[]);
   pva.z          = pb_keyval('z',v,[]);
   pva.ls         = pb_keyval('linespec',v,'o');
   pva.def        = pb_keyval('def',v,2);
   pva.color      = pb_keyval('color',v,ones(length(pva.x),1));
   pva.axis       = pb_keyval('axis',v,'square');
   pva.subtitle   = pb_keyval('subtitle',v);
   
   obj.pva = pva;
   
   obj.labels.xlab = '';
   obj.labels.ylab = '';
end