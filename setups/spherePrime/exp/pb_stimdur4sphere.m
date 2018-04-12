function stimdur = pb_stimdur4sphere(des_stimdur)
% PB_STIMDUR4SPHERE()
%
% Returns the most accurate stimulus duration for desired stimulus (sphere setup).
%
% PB_STIMDUR4SPHERE()  ...

 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl
 
    cycle       =   1.3;            % PLC cycle duration (sphere setup)
    onset       =   cycle*3;        % It takes 2 cycles before stimulus is 'on'   
    
    ncycles     =   round((des_stimdur - onset)/cycle);
    if ncycles < 0; ncycles = 0; end
    stimdur     =   (ncycles*cycle)+onset;
    
 
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

