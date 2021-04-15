function cfg = pb_vLSCpositions(cfg,varargin)
% PB_VLOOKUP()
%
% PB_VLOOKUP()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl


   if nargin<1
      cfg = [];
   end

   %% Optional arguments
   dspFlag       = pb_keyval('display',varargin,false);
   if dspFlag; close all; end
   
   %% File
   fname		= which(cfg.lookup_table);
   N			= xlsread(fname,'Values','','basic');
   channel	= N(:,1);
   
   cfg.stimulus_layout.fname = fname;
   
   
   %% Transform to Cartesian
   % To be checked
   % actual spherical azimuth, elevation
   az			= -N(:,4)+99;
   el			= N(:,5);
   az			= pa_deg2rad(az);
   el			= pa_deg2rad(el);
   R			= 1;
   [X,Y,Z]		= sph2cart(az,el,R);
   [X,Y,Z]		= pitch(X,Y,Z,99);

   % desired double-polar azimuth and elevation
   daz			= N(:,2);
   del			= N(:,3);
   % [dX,dY,dZ]	= azel2cart(daz,del,R);

   %% Transform to double-polar coordinate system
   % actual double-polar azimuth, elevation
   [X,Y,Z]		= yaw(X,Y,Z,-99);
   [aazel]		= xyz2azel(X,Y,Z);
   aaz			= aazel(:,1);
   ael			= aazel(:,2);

   sel			= daz>99;
   aaz(sel)	= 99+(99-aaz(sel));

   sel			= daz<-99;
   aaz(sel)	= -99+(-99-aaz(sel));

   sel			= del>99;
   ael(sel)	= 99+(99-ael(sel));

   cfg.lookup	= [aaz ael channel];
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

