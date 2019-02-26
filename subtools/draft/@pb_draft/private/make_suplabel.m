function make_suplabel(obj,varargin)
% PB_DRAFT>MAKE_SUPLABEL
%
% OBJ.MAKE_SUPLABEL(varargin) make superlabels handle.
%
% See also PB_DRAFT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   x        = pb_keyval('x',varargin,obj(1).labels.supx);
   y        = pb_keyval('y',varargin,obj(1).labels.supy);
   pos      = pb_keyval('position',varargin,obj(1).labels.pos);
   
   slax     = gobjects(0);
   
   if x || y
      slax  = axes('Units','Normal','Position',pos,'Visible','off','tag','suplabel'); 	 % TODO: HOW TO MAKE THE POSITION ADAPTING ON AXES/FIGURE?
      if x; xlabel(obj(1).labels.xlab,'Visible','on'); end
      if y; ylabel(obj(1).labels.ylab,'Visible','on'); end
      obj(1).h_ax_labels = slax;
   end
end

 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2019)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
