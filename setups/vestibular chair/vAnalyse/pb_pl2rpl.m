function rpl = pb_pl2rpl(pl,ot,gaze_prim,ot_rigid)
% PB_PL2RPL()
%
% PB_PL2RPL()  ...
%
% See also ...

% PBToolbox (2018): JJH: j.heckman@donders.ru.nl

   rpl = [];
   Pup = pl;
   Opt = ot;

   gaze_prim.Data=[];
   gaze_prim.Data(1,:)=Pup.timestamp;
   gaze_prim.Data(2,:)=Pup.confidence;
   gaze_prim.Data(3,:)=Pup.timestamp;
   gaze_prim.Data(4,:)=Pup.norm_pos(:,1);
   gaze_prim.Data(5,:)=Pup.norm_pos(:,2);

   lsl_tsPup = lsl_correct_pupil_timestamps(gaze_prim);
   lsl_tsOpt = lsl_correct_lsl_timestamps(ot_rigid);

   q = quaternion(Opt.qx,Opt.qy,Opt.qz,Opt.qw);
   q1= quaternion(Opt.qx(1),Opt.qy(1),Opt.qz(1),Opt.qw(1));
   qRot=q*inverse(q1);
   qRotDouble=double(qRot);

   [az el rot] = quaternion2azel(Opt.qx,Opt.qy,Opt.qz,Opt.qw);
   [azRot elRot rotRot] = quaternion2azel(qRotDouble(1,:,:),qRotDouble(2,:,:),qRotDouble(3,:,:),qRotDouble(4,:,:));

   normv = Pup.gaze_normal_3d(1:10,:);
   normv=median(normv);

   % Estimate rotation matrix
   GG = @(A,B) [ dot(A,B) -norm(cross(A,B)) 0;
       norm(cross(A,B)) dot(A,B)  0;
       0              0           1];

   FFi = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];

   UU = @(Fi,G) Fi*G*inv(Fi);
   b=normv'; a=[0 0 1]';
   Rot = UU(FFi(a,b), GG(a,b));

   % Rotate

   gaze_normalsrot=Pup.gaze_normal_3d*Rot;
   % gaze_normalsrot(Pup.confidence<0.6,:)=NaN;

   % Convert to angles
   ax2=real(asind(gaze_normalsrot(:,2)));
   ax1=real(asind(gaze_normalsrot(:,1)./cosd(ax2)));


   % Interpolate in order to create gaze
   azinterp=interp1(lsl_tsOpt,azRot,lsl_tsPup,'spline');
   elinterp=interp1(lsl_tsOpt,elRot,lsl_tsPup,'spline');
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%                                                           %
%       Part of Programmeer Beer Toolbox (PBToolbox)        %
%       Written by: Jesse J. Heckman (2018)                 %
%                                                           %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

