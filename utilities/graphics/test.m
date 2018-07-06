x1 = normrnd(4.9,1,100,1);
x2 = normrnd(6.4,1,100,1);
x3 = normrnd(4.3,1,100,1);
x4 = normrnd(7,1,100,1);
x5 = normrnd(3.3,1,100,1);
x11 = normrnd(3.9,1,100,1);
x12 = normrnd(6.4,1,100,1);
x13 = normrnd(4.3,1,100,1);
x14 = normrnd(5,1,100,1);
x15 = normrnd(3.3,1,100,1);

subplot(211);
boxplot([x1,x2,x3,x4,x5,x11,x12,x13,x14,x15])
subplot(212);
boxplot([x11,x2,x13,x4,x5,x1,x12,x3,x14,x5])