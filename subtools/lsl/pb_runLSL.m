function [ses,str] = pb_runLSL()
% PB_RUNLSL()
%
% PB_RUNLSL() creates a LSL session for VC.
%
% See also PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   streams  = {'type=''Digital Events @ lslder01'' and name=''Digital Events 1''', ...
               'type=''Pupil Capture @ pupil-desktop.local'' and name=''Pupil Primitive Data - Eye 0''', ...
               'type=''OptiTrack Mocap @ DCN-VSO3'' and name=''Labeled Markers'''};
         
   ses      = lsl_session();
   str      = lsl_istream.empty(0,3);

   for iStrm = 1:2 %length(streams)
      % Find, select and make streams for LSL.
      tmp = strrep(streams(iStrm),'type=''','');
      tmp = tmp{1}(1:find(tmp{1} == '@',1)-2);
      disp([newline 'Looking for ' tmp ' stream...'])
      
      info  = lsl_resolver(streams{iStrm});
      l     = info.list();
      if isempty(l); error('No streams found'); end

      for iList = 1:size(l ,1)
        fprintf('%d: name: ''%s'' type: ''%s''\n',iList,l(iList).name,l(iList).type);
      end

      str(iStrm) = lsl_istream(info{1});
      ses.add_stream(str(iStrm));
   end
   
   addlistener(str(1),'DataAvailable', @ev_listener);
   addlistener(str(2),'DataAvailable', @pl_listener);
   %addlistener(str(3),'DataAvailable', @ot_listener);
end

function ev_listener(~, event)
   disp('ev_listener called')
   disp(event);
end

function pl_listener(~, event)
   disp('pl_listener called');
   disp(event);
end

function ot_listener(~, event)
   disp('ot_listener called');
   disp(event);
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

