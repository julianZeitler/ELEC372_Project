% Controller#2

numK2= 3*[80 1];
denK2= 20*[4 1];
sysK2= tf(numK2, denK2);

%G 
numG = 1;
denG = [400 0 0];
sysG = tf(numG, denG);

% DS1 is stable

sysfo2 = series(sysK2, sysG);
syscl2 = feedback(sysfo2, 1); 

t = 0:0.5:500;
y = step(syscl2, t);
plot(t,y), grid;
xlabel('Time (s)');
ylabel('Output Y(t)');
title('Example1: Closed-Loop Step Response.');
zcl = zero(syscl2);
pcl = pole(syscl2);
syscl2;
