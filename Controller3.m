% Controller#3

numK3= 35*[40 1];
denK3= 40*[1 2];
sysK3= tf(numK3, denK3);

%G 
numG = 1;
denG = [400 0 0];
sysG = tf(numG, denG);

% DS1 is stable

sysfo3 = series(sysK3, sysG);
syscl3 = feedback(sysfo3, 1);

t = 0:0.5:500;
y = step(syscl3, t);
plot(t,y), grid;
xlabel('Time (s)');
ylabel('Output Y(t)');
title('Example1: Closed-Loop Step Response.');
zcl = zero(syscl3);
pcl = pole(syscl3);
syscl3;