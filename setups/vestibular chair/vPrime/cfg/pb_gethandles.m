function handles = pb_gethandles(handles)
% PB_GETHANDLES
%
% PB_GETHANDLES(handles) extracts the set parameters from the GUI and stores
% them into your handles.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   cfg					= handles.cfg;
   
   expIdx				= get(handles.popExperimenter,'Value');
   expInitials			= get(handles.popExperimenter,'String');
   cfg.expInitials	= expInitials{expIdx};
   
   cfg.subjectid		= get(handles.editPart,'String');
   cfg.recording		= get(handles.editRec,'String');
   cfg.fname			= [cfg.expInitials '-' sprintf('%04u',str2double(cfg.subjectid)) '-' cfg.datestring '-' sprintf('%04u',str2double(cfg.recording)) '.vc']; % file name
   cfg.dname			= [cfg.fpath filesep cfg.expInitials filesep 'Recordings' filesep cfg.expInitials '-' sprintf('%04u',str2double(cfg.subjectid)) '-' cfg.datestring]; % directory name
   cfg.expdir			= [cfg.fpath filesep cfg.expInitials filesep 'EXP' filesep]; % exp directory name
   cfg.snddir			= [cfg.fpath filesep cfg.expInitials filesep 'SND' filesep]; % wav directory name

   % get exp and cal files
   str					= [cfg.expdir filesep '*.exp'];
   d                 = dir(str);                                           % default exp folder
   cfg.expfiles		= {d.name};
   cfg.expfname		= get(handles.editLoad,'String');
   
   % vestibular profile
   idc               = 1:max(strfind(cfg.expfname,filesep));
   folder            = cfg.expfname(idc);
   l                 = dir([cfg.expfname(1:end-4) '.mat']);
   
   % profile
   profile           = [];
   if ~isempty(l); profile = [l(1).folder filesep l(1).name]; end
   cfg.fn_profile    = profile; 
   
   handles.cfg			= cfg;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

