function handles = pb_createdir(handles)
% PB_CREATEDIR(HANDLES)
%
% PB_CREATEDIR(HANDLES) checks if intended data directory exists, and, 
% if not, makes directory. Furthermore, a quick check is done to see if
% there is already existing data in this folder to prevent loss of data.
%
% See also PB_VPRIME, PB_VPRIME, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg = handles.cfg;
   
   path = [cfg.dname filesep 'trial'];
   if ~exist(path,'dir'); mkdir(path); end
   
   cd(path);
   
   fname = [cfg.expInitials '-' cfg.subjectid '-' cfg.datestring '-' cfg.recording '-0001.vc' ]; 
   
   if exist(fname,'file')
      % Check for existing recordings
      
      quest    = 'Recording already exists. Indicate how to proceed?'; 
      answer   = questdlg(quest,'Choices','Overwrite', 'Append','Stop','Stop');
      
      switch answer
         case 'Append'
            while exist(fname,'file')
               cfg.recording = num2str(str2double(cfg.recording)+1,'%04d');
               fname = [cfg.expInitials '-' cfg.subjectid '-' cfg.datestring '-' cfg.recording '-0001.vc' ];
            end
            set(handles.editRec,'string',cfg.recording);   
         case 'Stop'
            error('Run stopped.');
      end
   end
   handles.cfg = cfg;
   handles     = pb_gethandles(handles);
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

