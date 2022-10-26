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

% DS2
% the poles are
%   -0.2175 + 0.0000i
%   -0.0163 + 0.0129i
%   -0.0163 - 0.0129i

s = stepinfo(y,t);

% settling time = 247.2102s
% overshoot = 21.2206%
% steady-state-error = 0.0003 = 0.03%

numStep = 5;
%denStep = [1 0];
sysStep = tf(numStep);

syscl2 = series(sysStep, syscl2);

t = 0:0.5:500;
y = step(syscl2,t);
plot(t,y), grid;
xlabel('Time (s)');
ylabel('Output Y(t)');
title('Example1: Closed-Loop Step Response.');
zcl = zero(syscl2);
pcl = pole(syscl2);