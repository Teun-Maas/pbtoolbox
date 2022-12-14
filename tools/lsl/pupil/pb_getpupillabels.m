function L = pb_getpupillabels(varargin)
% PB_GETPUPILLABELS()
%
% PB_GETPUPILLABELS()  ...
%
% See also ...

% PBToolbox (2021): JJH: j.heckman@donders.ru.nl

      labels   = {'confidence'; ...
                  'norm_pos_x'; ...
                  'norm_pos_y'; ...
                  'gaze_point_3d_x'; ...
                  'gaze_point_3d_y'; ...
                  'gaze_point_3d_z'; ...
                  'eye_center0_3d_x'; ...
                  'eye_center0_3d_y'; ...
                  'eye_center0_3d_z'; ...
                  'eye_center1_3d_x'; ...
                  'eye_center1_3d_y'; ...
                  'eye_center1_3d_z'; ...
                  'gaze_normal0_x'; ...
                  'gaze_normal0_y'; ...
                  'gaze_normal0_z'; ...
                  'gaze_normal1_x'; ...
                  'gaze_normal1_y'; ...
                  'gaze_normal1_z'; ...
                  'diameter0_2d'; ...
                  'diameter1_2d'; ...
                  'diameter0_3d'; ...
                  'diameter1_3d'};

   if nargin == 0 
      %  Just output the labels
         L = labels;
         
   elseif isa(varargin{1},'lsl_data')
      % convert data structure to new pupil labs struct with according
      % labels as fields
      
      % check start index
      start_idx = 1;
      if nargin == 2
         start_idx = varargin{2};
      end
      
      % make struct
      for iL = 1:length(labels)
         L.(labels{iL})    = varargin{1}.Data(iL,start_idx:end);
         L.timestamps      = varargin{1}.Timestamps(start_idx:end);
      end
   end
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2021)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

