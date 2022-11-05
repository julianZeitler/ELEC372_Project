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

zcl = zero(syscl3);
pcl = pole(syscl3);

% the poles are
%     -1.9558 + 0.0000i
%     -0.0221 + 0.0251i
%     -0.0221 - 0.0251i

% the zero is
%    -0.0250

%DS 2
t = 0:0.5:500;
y = step(syscl3, t);
s = stepinfo(y,t);

figure;
plot(t,y), grid;
xlabel('Time (s)');
ylabel('Output Y(t)');
title('DS1: Closed-Loop Step Response of Controller 3');

% settling time = 144.4260s
settling_time = s.SettlingTime;
%DS 3
% overshoot = 22.9565%
overshoot = s.Overshoot;

% DS 4
steady_state_error_step = (1 - y(end))*100;
sysctlDist = feedback(sysG, -sysK3, 1);
y = step(sysctlDist, t);
steady_state_error_dist = (1 - y(end))*100;

% steady-state-error = 0.0017% // normal step input
% steady-state-error = -128.5678 // Disturbance step input

figure;
plot(t,y), grid;
xlabel('Time (s)');
ylabel('Output Y(t) in Degrees');
title('DS2-4: Disturbance Step Input of Controller 3');

% DS 5
sysctlTc = feedback(sysK3, sysG);
output_Tc_Integrated = cumtrapz(t, abs(step(sysctlTc, t)));

% power_consumption = 38.6800
power_consumption = output_Tc_Integrated(end);

figure;
plot(t,output_Tc_Integrated), grid;
xlabel('Time (s)');
ylabel('Integral of Tc(t)');
grid on;
title("DS5: Integrated Tc for step Input of Controller 3");

% Questions 1
numStep = 5;
sysStep = tf(numStep);
syscl3_q1 = series(sysStep, syscl3);

y = step(syscl3_q1,t);

figure;
plot(t,y), grid;
xlabel('Time (s)');
ylabel('Output Y(t)');
title('Q1: Closed-Loop Step Response of Controller 3');

% Question 2
sysctlTc_q2 = series(sysStep, sysctlTc);
output_Tc = step(sysctlTc_q2, t);

figure;
plot(t,output_Tc), grid;
xlabel('Time (s)');
ylabel('Signal Tc(t)');
grid on;
title("Q2: Signal Tc of Controller 3 for Step Input");

% Question 3
% actual input
t_dist = 0:10:2*86400;
figure;
dist_input = 10^-4*cos(7.28E-5*t_dist);
lsim(sysctlDist, dist_input, t_dist);
xlabel('Time (s)');
ylabel('Output Y(t) (Degree)');
grid on;
title("Q3: Disturbance Input of Controller 3");

output_y_dist = step(sysctlDist, t);
figure;
plot(t,output_y_dist), grid;
xlabel('Time (s)');
ylabel('Output Y(t) (Degree)');
grid on;
title("Q3: Disturbance Step Input of Controller 3");

% Question 4
sysctlTCTD = feedback(series(-sysG, sysK3), 1, 1);

figure;
dist_input = 10^-4*cos(7.28E-5*t_dist);
lsim(sysctlTCTD, dist_input, t_dist);
xlabel('Time (s)');
ylabel('Signal Tc(t)');
grid on;
title("Q4: Tc for cosin disturbance input of Controller 3");

y_step = step(sysctlTCTD, t);
figure;
plot(t,y_step), grid;
xlabel('Time (s)');
ylabel('Signal Tc(t)');
grid on;
title("Q4: Disturbance Step Input of Controller 3");