function ses = pb_runLSL()
% PB_RUNLSL()
%
% PB_RUNLSL()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   streams  = {'type=''Digital Events @ lslder00'' and name=''Digital Events 1''', ...
               'type=''Pupil Capture @ pupil-desktop'' and name=''Pupil Primitive Data - Eye 0''', ...
               'type=''Optitrack @ MOTIVE'' and name=''Motive Data'''};
         
   ses      = lsl_session();
   str      = lsl_istream.empty(0,3);

   for iStrm = 1:1%length(streams)
      % Find, select and make streams for LSL.
      tmp = strrep(streams(iStrm),'type=''','');
      tmp = tmp{1}(1:find(tmp{1} == '@',1)-2);
      disp([newline 'Looking for ' tmp ' stream...'])
      
      info  = lsl_streaminfos(streams{iStrm})
      l     = info.list()
      if isempty(l); error('No streams found'); end

      for iList = 1:size(l ,1)
        fprintf('%d: name: ''%s'' type: ''%s''\n',iList,l{iList}.name,l{iList}.type);
      end

      str(iStrm) = lsl_istream(info{1})
      ses.add_stream(str(iStrm));
   end
   
   addlistener(str(1),'DataAvailable',@ev_listener);
   %addlistener(str(2),'DataAvailable',@pl_listener);
   % addlistener(str(3),'DataAvailable',@ot_listener);
end

function ev_listener(src, event)
%    disp('ev_listener called')
   event
end

function pl_listener(src, event)
%    disp('pl_listener called');
%    event
end

function ot_listener(src, event)
%    disp('ot_listener called');
%    event
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

