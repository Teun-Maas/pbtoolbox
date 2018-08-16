close all

for i = 1:5
   subplot(5,1,i);
   hold on;
   
   plot(pb_cleanSP(D(i).sv,350));
   plot(pb_cleanSP(D(i).pv,350));
   
   if i == 1; title('Servo behaviour'); end
   if i == 5; xlabel('t'); end
   ylabel('x( t )');
   
   legend('Input','Output')
end

pb_nicegraph('def',1)