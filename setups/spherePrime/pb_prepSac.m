function pb_prepSac()
% PB_PREPSAC()
%
% PB_PREPSAC()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
   
   cdir        = '/Users/jjheckman/Documents/Data/PhD/Setups/Sphere/introduction/';
   [fn, path]  = pb_getfile('dir',cdir,'ext','*.*','title','Select an experimentfile');
   [ext,~]     = pb_fext(fn); 
   
   cd(path);


   %% Get variables

   experimenter    = pb_delreadstr(fn,'delimiter','-','n',1);
   participant     = pb_delreadstr(fn,'delimiter','-','n',2);
   year            = pb_delreadstr(fn,'delimiter','-','n',3);
   month           = pb_delreadstr(fn,'delimiter','-','n',4);
   day             = pb_delreadstr(fn,'delimiter','-','n',5);

   prefix = [experimenter '-' participant '-' year '-' month '-' day '-'];

   %% 
   
   n = pb_spheretrial2complete();
   
   for iBlock = 1:n
      f_tmp = [prefix num2str(iBlock-1,'%04d') ext];
      disp(f_tmp)
      sphere2hoopdat(f_tmp);
      sphere2hoopcsv(f_tmp);
   end
   pa_calibrate();
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

