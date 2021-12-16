function [ses,str,meta] = pb_runLSL(varargin)
% PB_RUNLSL
%
% PB_RUNLSL(varargin) creates a LSL session for VC.
%
% See also PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

% check if all streams are necesary


   pl = pb_keyval('pl', varargin, true);
   ot = pb_keyval('ot', varargin, true);
   sh = pb_keyval('sh', varargin, true);
   di = pb_keyval('di', varargin, true);
   do = pb_keyval('do', varargin, true);
      
   
   tmp      = {};
   meta     = [];
   
   streams  = {'type=''Pupil Gaze @ n140195.science.ru.nl'' and name= ''Pupil Capture LSL Relay v2''', ...
               'type=''OptiTrack Mocap @ DCN-OT01'' and name=''Rigid Bodies''', ...
               'type=''IMU Pose @ raspi-gw'' and name=''IMU Pose''',...
               'type=''Digital Events @ lslder01'' and name=''Digital Events 0''', ...
               'type=''Digital Events @ lslder01'' and name=''Digital Events 7'''};
   
   if pl; tmp(end+1) = streams(1); end 
   if ot; tmp(end+1) = streams(2); end
   if sh; tmp(end+1) = streams(3); end
   if di; tmp(end+1) = streams(4); end
   if do; tmp(end+1) = streams(5); end
   
   streams = tmp;
   clear tmp;
         
   ses      = lsl_session();
   ls       = length(streams);
   str      = lsl_istream.empty(0,ls);
   
   for iStrm = 1:ls
      % Find, select and make streams for LSL.
      tmp = strrep(streams(iStrm),'type=''','');
      tmp = tmp{1}(1:find(tmp{1} == '@',1)-2);
      
      info  = lsl_resolver(streams{iStrm});
      l     = info.list();
      
      if isempty(info.infos); error(['lsl resolver cannot make connection with:  ' tmp]); end   % Pupil labs? check if 'LSL relay' is tickmarked in pupil capture 
      if isempty(l); error('No streams found'); end

      str(iStrm) = lsl_istream(info{1});
      ses.add_stream(str(iStrm));
      
      % Check meta data for pupil labs
      if contains(streams(iStrm),'pupil')
         meta = lsl_metadata_gaze(str(iStrm));
      end
   end
   
   c = 1;
   
   if pl; addlistener(str(c),'DataAvailable', @listener); c = c+1; end
   if ot; addlistener(str(c),'DataAvailable', @listener); c = c+1; end
   if sh; addlistener(str(c),'DataAvailable', @listener); c = c+1; end
   if di; addlistener(str(c),'DataAvailable', @listener); c = c+1; end
   if do; addlistener(str(c),'DataAvailable', @listener); c = c+1; end
end

function listener(~, event)
   %disp(event);
end
