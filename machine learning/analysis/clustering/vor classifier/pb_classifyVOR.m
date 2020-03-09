%% Initialize
%  Empty, Clear, Clean, Set globals.

cfn            = pb_clean;
[fn,path]      = pb_getfile('dir',[pb_datapath filesep 'e1_vor']);
fullname       = [path fn];

load(fullname);
datl     = length(D);

%% Convert 2 AzEl
%  Take eye x, y, z traces and transform 2 azimuth and elevation

if length(D) ~= datl; D(datl) = struct([]); end

for iD = 1:datl
   % Loop over data
   q        = quaternion(D(iD).Opt.Data.qw,D(iD).Opt.Data.qx,D(iD).Opt.Data.qy,D(iD).Opt.Data.qz);
   vp       = transpose(RotateVector(q,[0 0 1]',1));
   AzEl     = -pb_xyz2azel(vp(:,1),vp(:,2),vp(:,3));

   D(iD).AzEl.Head = AzEl;

   normv = D(iD).Pup.Data.gaze_normal_3d(1:10,:);
   normv = median(normv);
   
   % Estimate rotation matrix
   GG = @(A,B) [ dot(A,B) -norm(cross(A,B)) 0;
       norm(cross(A,B)) dot(A,B)  0;
       0              0           1];

   FFi = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];

   UU    = @(Fi,G) Fi * G * inv(Fi);
   b     = normv'; 
   a     = [0 0 1]';
   Rot   = UU(FFi(a,b), GG(a,b));

   % Rotate
   if isfield(D(iD).Pup.Data,'gaze_normal_3d')
      gaze_normalsrot = D(iD).Pup.Data.gaze_normal_3d*Rot;
   else
     	gaze_normalsrot = D(iD).Pup.Data.base_data.base_data.circle_3d.normal * Rot; % in case 2D gaze
   end
   
   % Convert to angles
   D(iD).AzEl.Eye = - pb_xyz2azel(gaze_normalsrot(:,1),gaze_normalsrot(:,2),gaze_normalsrot(:,3));
end

%% Visualize data

blocknumber    = 8;

eyetraces   = D(blocknumber).AzEl.Eye;
times       = D(blocknumber).Timestamp.Pup - D(blocknumber).Timestamp.Pup(1);

cfn = pb_newfig(cfn);
hold on;
plot(times, eyetraces(:,1),'.');     % Just the azimuth please ;)
% plot(times, eyetraces(:,2)); 
pb_nicegraph('def',2);
xlim([0 120]);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2020)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

