function [ses,str] = pb_runLSL(varargin)
% PB_RUNLSL()
%
% PB_RUNLSL() creates a LSL session for VC.
%
% See also PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   de = pb_keyval('de', varargin, true);
   pl = pb_keyval('pl', varargin, true);
   gz = pb_keyval('gz', varargin, true);
   pd = pb_keyval('pd', varargin, true);
   ot = pb_keyval('ot', varargin, true);
   
   tmp = {};
   
   streams  = {'type=''Digital Events @ lslder01'' and name=''Digital Events 0''', ...
               'type=''Pupil Capture @ pupil-desktop'' and name=''Pupil Python Representation - Eye 0''', ...
               'type=''Pupil Capture @ pupil-desktop'' and name=''Gaze Python Representation''', ...
               'type=''Pupil Capture @ pupil-desktop'' and name=''Pupil Primitive Data - Eye 0''', ...
               'type=''OptiTrack Mocap @ DCN-VSO3'' and name=''Rigid Bodies'''};
            
   
   if de; tmp(end+1) = streams(1); end
   if pl; tmp(end+1) = streams(2); end 
   if gz; tmp(end+1) = streams(3); end
   if pd; tmp(end+1) = streams(4); end
   if ot; tmp(end+1) = streams(5); end
   
   streams = tmp;
         
   ses      = lsl_session();
   ls       = length(streams);
   str      = lsl_istream.empty(0,ls);
   
   clear tmp;
   for iStrm = 1:ls
      % Find, select and make streams for LSL.
      tmp = strrep(streams(iStrm),'type=''','');
      tmp = tmp{1}(1:find(tmp{1} == '@',1)-2);
      %disp([newline 'Looking for ' tmp ' stream...'])
      
      info  = lsl_resolver(streams{iStrm});
      l     = info.list();
      if isempty(l); error('No streams found'); end

      for iList = 1:size(l,1)
        %fprintf('%d: name: ''%s'' type: ''%s''\n',iList,l(iList).name,l(iList).type);
      end

      str(iStrm) = lsl_istream(info{1});
      ses.add_stream(str(iStrm));
   end
   
   c = 1;
   if de; addlistener(str(c),'DataAvailable', @ev_listener); c = c+1; end
   if pl; addlistener(str(c),'DataAvailable', @pl_listener); c = c+1; end
   if gz; addlistener(str(c),'DataAvailable', @gz_listener); c = c+1; end
   if pd; addlistener(str(c),'DataAvailable', @pd_listener); c = c+1; end
   if ot; addlistener(str(c),'DataAvailable', @ot_listener); end
end

function ev_listener(~, event)
   %disp('ev_listener called')
   %disp(event);
end

function pl_listener(~, event)
   %disp('pl_listener called');
   %disp(event);
end

function gz_listener(~, event)
   %disp('gz_listener called');
   %disp(event);
end

function pd_listener(~, event)
   %disp('pd_listener called');
   %disp(event);
end

function ot_listener(~, event)
   %disp('ot_listener called');
   %disp(event);
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

