function pb_edit(varargin)
% PB_EDIT(VARARGIN)
%
% Creates a template function for PBToolbox.
%
% PB_EDIT(VARARGIN) generates default function template for Programmeer
% Beer Toolbox (PBToolbox), and stores it in the PBToolbox. Optional input
% arguments are 'function_name' and 'directory'. Default values are
% 'pb_test' and '~/PBToolbox/tmp/defaultbin'.
%
% See also PB_WRITEFUN, PB_CHECKEXT, PB_SCRIPT, PB_WRITESCRIPT

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   %% Initialization

   pbt_D = '/Users/jjheckman/Documents/Code/Gitlab/pbtoolbox/'; %
   default_D = '/tmp/defaultbin/';
   cd(pbt_D);
   
   %% Body

   switch nargin
      case 0
         [fname,path] = uiputfile({'*.m'},'Save file name');
         if fname == 0; return; end
      case 1
         fname   = varargin{1};
         path    = which(fname);
         if isempty(path)
            path    = [pbt_D default_D];
         else
         edit(path);
         return
         end
      case 2
         fname   = varargin{1};
         if varargin{2}(end) ~= filesep 
            varargin{2} = [varargin{2} filesep]; 
         end
         path    = [pbt_D varargin{2}];
      case 3
         error('Error: Too much input arguments.');
   end

   fname   =   pb_checkext(fname,'.m');
   file    =   [path fname];

   if ~exist(path,'dir')
   mkdir(path);
   addpath(genpath(path));
   end

   cd(path);

   if ~exist(file,'file')
   pb_writefun(path, fname);
   end

   edit(file);
end


    

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

