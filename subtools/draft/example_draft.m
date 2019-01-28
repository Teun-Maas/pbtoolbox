%% Example code 'draft'
pb_clean;
load example_data;

% construct
d(1,1) = pb_draft('x',cars.Displacement,'y',cars.Weight,'color',cars.Cylinders,'def',8,'subtitle','Color1');
d(1,1).set_labels('x','Displacement','y','Weight');

% d(1,2) = pb_draft('x',cars.Displacement,'y',cars.Weight,'color',cars.Cylinders,'def',9,'subtitle','Color2');
% d(1,2).set_labels('x','Displacement','y','Weight');
% 
% d(1,3) = pb_draft('x',cars.Displacement,'y',cars.Weight,'color',cars.Cylinders,'def',10,'subtitle','Color3');
% d(1,3).set_labels('x','Displacement','y','Weight');

% d(2,1) = pb_draft('x',cars.Displacement,'y',cars.Weight,'color',cars.Cylinders,'def',4,'subtitle','Color4');
% d(2,1).set_labels('x','Displacement','y','Weight');
% 
% d(2,2) = pb_draft('x',cars.Displacement,'y',cars.Weight,'color',cars.Cylinders,'def',5,'subtitle','Color5');
% d(2,2).set_labels('x','Displacement','y','Weight');
% 
% d(2,3) = pb_draft('x',cars.Displacement,'y',cars.Weight,'color',cars.Cylinders,'def',6,'subtitle','Color6');
% d(2,3).set_labels('x','Displacement','y','Weight');
% 
% d(3,1) = pb_draft('x',cars.Displacement,'y',cars.Weight,'color',cars.Cylinders,'def',7,'subtitle','Color4');
% d(3,1).set_labels('x','Displacement','y','Weight');
% 
% d(3,2) = pb_draft('x',cars.Displacement,'y',cars.Weight,'color',cars.Cylinders,'def',8,'subtitle','Color5');
% d(3,2).set_labels('x','Displacement','y','Weight');
% 
% d(3,3) = pb_draft('x',cars.Displacement,'y',cars.Weight,'color',cars.Cylinders,'def',9,'subtitle','Color6');
% d(3,3).set_labels('x','Displacement','y','Weight');

d.set_title('Car Data');
d.draft;
d.print('disp',true);

% plotting order is wrong?