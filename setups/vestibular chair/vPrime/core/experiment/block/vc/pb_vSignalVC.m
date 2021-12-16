function [profile,dur,bool_mov] = pb_vSignalVC(handles)
% PB_VSIGNALVC
%
% PB_VSIGNALVC(handles) reads vestibular signal from handles, writes
% profile, and feeds back the signal to the axes in GUI.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   
   %  Selects relevant handles
   block       = handles.block;
   bnumber     = handles.cfg.blocknumber;
   
   %  Creates safe vestibular signals.   
   %  Read & create signals
   signal      = pb_vBuildSignal(block(bnumber).signal);  
   signal      = pb_vSafety(signal); 
   
   vSignal     = pb_vCreateSignal(1, signal(1).duration, 10, signal(1).frequency, signal(1).type);
   hSignal     = pb_vCreateSignal(1, signal(2).duration, 10, signal(2).frequency, signal(2).type);

   %  Finalize signals
   sigData.v.x    = vSignal.x .* signal(1).amplitude;    
   sigData.v.t    = (0:1:length(sigData.v.x)-1)/10;
   profile.v      = sigData.v.x;
   
   sigData.h.x    = hSignal.x .* signal(2).amplitude;    
   sigData.h.t    = (0:1:length(sigData.h.x)-1)/10;      
   profile.h      = sigData.h.x;
   
   %  Check signal safety
   [hSafe,~]      = pb_vCheckVelSignal(profile.h);
   [vSafe,~]      = pb_vCheckVelSignal(profile.v);
   
   if ~hSafe || ~vSafe || strcmp(signal(2).type,'vor') || strcmp(signal(2).type,'turn')      % FORBIDDEN WITH HORIZONTAL AXIS
      error('Vestibular signals were not safe!');
   end
   
   % Will chair move?
   bool_mov = any(profile.h) | any(profile.v);
   
   %  interacts with GUI for feedback  
   updateBlock(handles, signal);

   handles  = pb_gethandles(handles);
   dur      = max([handles.block(bnumber).signal.ver.duration handles.block(bnumber).signal.hor.duration]);
   
   %  Set axis
   axes(handles.signals); 
   cla; hold on; 
   handles.signals.YLim    = [-50 50];
   handles.signals.XLim    = [0 dur];
   
   %  Plot signals
   dv    = 10 * diff(profile.v);
   dh    = 10 * diff(profile.h);
   t     = sigData.v.t(2:end);
   
   plot(t,dv,'k');
   plot(t,dh,'b');
end

function updateBlock(handles, signal)
   % Updates the block information to the GUI
   
   bn = num2str(handles.cfg.blocknumber,'%03d');
   set(handles.Bn,'string',bn);
   
   vs = ['V = ' pb_sentenceCase(signal(1).type) ...
         ', H = ' pb_sentenceCase(signal(2).type)];
      
   set(handles.Vs,'string',vs);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

