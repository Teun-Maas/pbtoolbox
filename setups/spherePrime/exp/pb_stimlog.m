function stimdur = pb_stimlog(first,last,nstim, varargin)
% PB_STIMLOG(first, last, nstim)
%
%  Returns a logscaled array of stimuli durations.
%
% PB_STILOG(DES_STIMDUR)  takes
 
% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

    setup       =   pb_keyval('setup',varargin,'sphere');
    base        =   pb_keyval('base',varargin,10);
      
    switch contains(setup,'sphere')
        case 1
            first       =   pb_stimdur4sphere(first);
            last        =   pb_stimdur4sphere(last);
            ls          =   pb_logspace(pb_log(first,base),pb_log(last,base),nstim,base); 
            stimdur     =   pb_stimdur4sphere(ls);
        case 0
            stimdur     =   pb_logspace(pb_log(first,base),pb_log(last,base),nstim,base);
    end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

