function S = pb_sysmergedata(fdir,varargin)
% PB_SYSMERGEDATA
%
% PB_SYSMERGEDATA(fdir) will analyse all input signals and merge them into a
% single dat file
%
% See also ...

% PBToolbox (2020): JJH: j.heckman@donders.ru.nl


   %  Get directory
   if nargin == 0
      fdir = pb_getdir('dir','~/Desktop/');
   end
   cd(fdir);
   
   %  Load data
   l     = dir('vc_sysident_gwn_*hz_*amp.mat');
   fn 	= l(1).name(1:strfind(l(1).name,'hz')+1); 

   for iL = 1:length(l)
      Dat(iL) = load(l(iL).name);
   end
   
   %  Merge data (Rearange structs to: Signal.Amplitude.Repeat)
   NSIGNAL  = length(Dat(1).D);
   NAMP     = length(Dat);
   NREP     = length(Dat(1).D(1).repeat);
   
   S  = struct;
   for iS = 1:NSIGNAL
      for iA = 1:NAMP
         S(iS).Amplitude(iA).Repeat       = Dat(iA).D(iS).repeat;
         S(iS).Amplitude(iA).amp_value    = Dat(iA).D(iS).repeat(1).amp;
         for iR = 1:NREP
            S(iS).Amplitude(iA).Repeat(iR).signal         = Dat(iA).D(iS).true_signal;
            S(iS).Amplitude(iA).Repeat(iR).tukey_signal   = Dat(iA).D(iS).tukey_signal;
         end
      end
   end
   
   %  Save data
   path	= [fdir filesep fn];
   save(path, 'S');
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

