%% PREPARE VARIABLES
%supindex() %provides column info for [M]
[M] = pa_supersac(Sac,Stim);

M_BB = M(M(:,30)<=199,:);                    % Broadband
M_HP = M(M(:,30)>=200,:); M_HP = M_HP(M_HP(:,30)<=299,:); %Highpass
M_LP = M(M(:,30)>=300,:); % Lowpass

clc; 
supindex;

%% CREATE FIGURE - Response(Target)


% Azimuth
y = M_BB(:,8); x = M_BB(:,23);
subplot(2,3,1); 
[h,b,r] = pb_regplot(x,y); 
title('Azimuth accuracy to BB sounds');

y = M_HP(:,8); x = M_HP(:,23);
subplot(2,3,2); [h,b,r] = pb_regplot(x,y); 
title('Azimuth accuracy to  HP sounds');

y = M_LP(:,8); x = M_LP(:,23);
subplot(2,3,3); [h,b,r] = pb_regplot(x,y); 
title('Azimuth accuracy to LP sounds');

% Elevation
y = M_BB(:,9); x = M_BB(:,24);
subplot(2,3,4); [h,b,r] = pb_regplot(x,y); 
title('Elevation accuracy to BB sounds');

y = M_HP(:,9); x = M_HP(:,24);
subplot(2,3,5); [h,b,r] = pb_regplot(x,y); 
title('Elevation accuracy to HP sounds');

y = M_LP(:,9); x = M_LP(:,24);
subplot(2,3,6); [h,b,r] = pb_regplot(x,y); 
title('Elevation accuracy to LP sounds');

