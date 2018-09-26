function handles = pb_createdir(handles)
% PB_CREATEDIR()
%
% PB_CREATEDIR()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   % Creates directory and sets parameters for data storage
   cfg = handles.cfg;
   
   path = [cfg.dname filesep 'trial'];
   if ~exist(path,'dir'); mkdir(path); end
   
   cd(path);
   
   fname = [cfg.expInitials '-' cfg.subjectid '-' cfg.datestring '-' cfg.recording '-0001.vc' ]; 
   
   while exist(fname,'file')
      % Check for existing recordings
      quest    = 'Recording already exists. Indicate how to proceed?'; 
      answer   = questdlg(quest,'Choices','Overwrite', 'Increment','Stop','Stop');
      switch answer
         case 'Overwrite'
            break;
         case 'Increment'
            cfg.recording = num2str(str2double(cfg.recording)+1,'%04d');
            set(handles.editRec,'string',cfg.recording);   
         case 'Stop'
            error('Run stopped.');
      end
      fname = [cfg.expInitials '-' cfg.subjectid '-' cfg.datestring '-' cfg.recording '-0001.vc' ];
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

