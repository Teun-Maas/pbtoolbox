function [Dat,profile,dur] = pb_vSignalVC(handles)
% PB_VSIGNALVC(HANDLES)
%
% PB_VSIGNALVC(HANDLES) reads vestibular signal from handles, writes
% profile, and feeds back the signal to the axes in GUI.
%
% See also PB_VPRIME, PB_VPRIMEGUI, PB_VRUNEXP

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   block       = handles.block;
   bnumber     = handles.cfg.blocknumber;
   
   %% READ SIGNAL PARAMETERS
   
   signal(1)   = block(bnumber).signal.ver;
   signal(2)   = block(bnumber).signal.hor;     
   signal      = pb_vSafety(signal); 

   %% CREATE BASIC SIGNAL
   vSignal     = pb_vCreateSignal(1, signal(1).duration, 10, signal(1).frequency, signal(1).type);
   hSignal     = pb_vCreateSignal(1, signal(2).duration, 10, signal(2).frequency, signal(2).type);

   %% FINALIZE SIGNAL
   Dat.v.x     = vSignal.x .* signal(1).amplitude; 
   profile.v   = Dat.v.x;
   Dat.v.t     = (0:1:length(Dat.v.x)-1)/10;
   Dat.h.x     = hSignal.x .* signal(2).amplitude; profile.h = Dat.h.x;
   Dat.h.t     = (0:1:length(Dat.h.x)-1)/10;      
   
   Dat.v.amplitude = signal(1).amplitude;
   Dat.h.amplitude = signal(2).amplitude;
   
   dur        = max([signal(1).duration signal(2).duration])+5;         % add 5 extra seconds for delay of the system

   %% FEEDBACK GUI
   updateBlock(handles,bnumber,signal);
   
   handles = pb_gethandles(handles);
   
   cb = handles.cfg.blocknumber;
   dur = max([handles.block(cb).signal.ver.duration handles.block(cb).signal.hor.duration]);
   
   axes(handles.signals); cla; hold on; 
   handles.signals.YLim = [-50 50];
   handles.signals.XLim = [0 dur];

   plot(Dat.v.t,Dat.v.x,'k');
   plot(Dat.h.t,Dat.h.x,'b');
end

function updateBlock(handles, bnumber, signal)
   % Updates the block information to the GUI
   
   bn = pb_sentenceCase(num2str(bnumber,'%03d'));                           % count block
   set(handles.Bn,'string',bn);
   
   vs = ['V = ' pb_sentenceCase(signal(1).type) ...                        % VC stim
         ', H = ' pb_sentenceCase(signal(2).type)];
   set(handles.Vs,'string',vs);
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

