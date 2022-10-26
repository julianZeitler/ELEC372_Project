% Controller#1
numK1 = [0.1 0.01];
denK1 = [1 0];
sysK1 = tf(numK1, denK1);

%G 
numG = 1;
denG = [400 0 0];
sysG = tf(numG, denG);

% DS1 is stable

sysfo1 = series(sysK1, sysG);
syscl1 = feedback(sysfo, 1); 

t = 0:0.5:500;
y = step(syscl1, t);
plot(t,y), grid;
xlabel('Time (s)');
ylabel('Output Y(t)');
title('Example1: Closed-Loop Step Response.');
zcl = zero(syscl1);
pcl = pole(syscl1);
syscl1;

% DS2



