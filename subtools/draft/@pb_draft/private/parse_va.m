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
   
   %  Read keyvals
   v = varargin;
   pva.x             = pb_keyval('x',v,[]);
   pva.y             = pb_keyval('y',v,[]);
   pva.z             = pb_keyval('z',v,[]);
   pva.def           = pb_keyval('def',v,1);
   pva.color         = pb_keyval('color',v,ones(length(pva.x),1));
   pva.axis          = pb_keyval('axis',v);
   pva.subtitle      = pb_keyval('subtitle',v);
   pva.linkax        = pb_keyval('link',v,true);
   
   %  Check data limits
   [x,y]             = setlim(pva); 
   pva.limits.x      = x;
   pva.limits.y      = y;
   
   %  Check square axis
   if isempty(pva.axis)
      if abs(max(x)-max(y)) / max([x,y])<.5
         pva.axis = 'square';
      end
   end
   
   %  Set layout
   pva.colscheme     = pb_selectcolor(length(unique(pva.color)),pva.def);
   pva.axcomp        = axcmp(pva.x);
   
   obj.labels.xlab   = pb_keyval('xlab',v,'');
   obj.labels.ylab   = pb_keyval('ylab',v,'');
   obj.grid.bool     = false;
   
   %  Check data continuity for colouring
   pva.continious = false;
   if length(unique(pva.color))>5 && ~prod(floor(pva.color) == pva.color)
      pva.continious = true;
   end
   
   obj.pva = pva;
end

function ac = axcmp(data)
   %  Writes empty axcomp data struct
   ac.prefix      = '';
   ac.feature     = ones(1,length(data));
   ac.n           = length(unique(ac.feature));
end

function [x,y] = setlim(data)
   % Sets the limits for axes
   x = [min(data.x) max(data.x)];
   y = [min(data.y) max(data.y)];
   
   xr = x(2)-x(1);
   yr = y(2)-y(1);
   
   % minimum
   if abs(min(x))/xr < .1; x(1) = 0; end
   if abs(min(y))/yr < .1; y(1) = 0; end
   
   % maximum
   tmp      = max([x,y]);
   order    = 0;
   scale    = .1;
   
   if tmp<1; scale = 10; end
   
   while tmp < .1 || tmp > 1
      tmp = tmp*scale; 
      order = order+1;
   end
   tmp   = round(tmp*100)/100;
   x(2)  = tmp * inv(scale)^order;
   y(2)  = tmp * inv(scale)^order;
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

