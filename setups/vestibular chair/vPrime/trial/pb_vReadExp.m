function [exp,cfg] = pb_vReadExp(expfile)
% PB_VREADEXP()
%
% PB_VREADEXP()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% INITIALIZE
   
   if ~pb_fexist(expfile); return; end
   fid = fopen(expfile,'r');
   
   %% READ HEADER
   
   cfg = hread(fid);
   exp = eread(fid);
   
   %% CHECK OUT
   fclose(fid);
end

function header = hread(fid)
   tline = fgetl(fid);
   while ~contains(tline,'%% HEADER')        % find header
       tline = fgetl(fid);
   end
   tmp = fgetl(fid);
   
   
   header.ITI = [];
end

function experiment = eread(fid)
   experiment = fid;
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

