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

zcl = zero(syscl2);
pcl = pole(syscl2);

% the poles are
%   -0.2175 + 0.0000i
%   -0.0163 + 0.0129i
%   -0.0163 - 0.0129i

% the zero is
%    -0.0125

%DS 2
t = 0:0.5:500;
y = step(syscl2, t);
s = stepinfo(y,t);

figure;
plot(t,y), grid;
xlabel('Time (s)');
ylabel('Output Y(t)');
title('DS1: Closed-Loop Step Response of Controller 2');

% settling time = 247.2102s
settling_time = s.SettlingTime;
%DS 3
% overshoot = 21.2206%
overshoot = s.Overshoot;

% DS 4
steady_state_error_step = (1 - y(end))*100;
sysctlDist = feedback(sysG, -sysK2, 1);
y = step(sysctlDist, t);
steady_state_error = (1 - y(end))*100;

% steady-state-error = 0.0003 = 0.03% // normal step input
% steady-state-error = -5.664281911155742e+02 // Disturbance step input

figure;
plot(t,y), grid;
xlabel('Time (s)');
ylabel('Output Y(t) in Degrees');
title('Disturbance Step Input of Controller 2');

% DS 5
sysctlTc = feedback(sysK2, sysG);
output_Tc_Integrated = cumtrapz(t, abs(step(sysctlTc, t)));

% power_consumption = 23.0659
power_consumption = output_Tc_Integrated(end);

figure;
plot(t,output_Tc_Integrated), grid;
xlabel('Time (s)');
ylabel('Integral of Tc(t)');
grid on;
title("Integrated Tc for step Input of Controller 2");

% Questions 1
numStep = 5;
sysStep = tf(numStep);
syscl2_q1 = series(sysStep, syscl2);

y = step(syscl2_q1,t);

figure;
plot(t,y), grid;
xlabel('Time (s)');
ylabel('Output Y(t)');
title('Q1: Closed-Loop Step Response of Controller 2');

% Question 2
sysctlTc_q2 = series(sysStep, sysctlTc);
output_Tc = step(sysctlTc_q2, t);

figure;
plot(t,output_Tc), grid;
xlabel('Time (s)');
ylabel('Signal Tc(t)');
grid on;
title("Q2: Signal Tc of Controller 2 for Step Input");

% Question 3
% actual input
t_dist = 0:10:2*86400;
figure;
dist_input = 10^-4*cos(7.28E-5*t_dist);
lsim(sysctlDist, dist_input, t_dist);
xlabel('Time (s)');
ylabel('Output Y(t) (Degree)');
grid on;
title("Q3: Disturbance Input of Controller 2");

output_y_dist = step(sysctlDist, t);
figure;
plot(t,output_y_dist), grid;
xlabel('Time (s)');
ylabel('Output Y(t) (Degree)');
grid on;
title("Q3: Disturbance Step Input of Controller 2");

% Question 4
sysctlTCTD = feedback(series(-sysG, sysK2), 1, 1);

figure;
dist_input = 10^-4*cos(7.28E-5*t_dist);
lsim(sysctlTCTD, dist_input, t_dist);
xlabel('Time (s)');
ylabel('Signal Tc(t)');
grid on;
title("Q4: Tc for cosin disturbance input of Controller 2");

y_step = step(sysctlTCTD, t);
figure;
plot(t,y_step), grid;
xlabel('Time (s)');
ylabel('Signal Tc(t)');
grid on;
title("Q4: Disturbance Step Input of Controller 2");

