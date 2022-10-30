classdef satellite < handle
    %SATELLITE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ControllerNum;
        %G 
        numG;
        denG;
        sysG;

        % K
        numK;
        denK;
        sysK;
        
        sysfo;
        sysctl;

        % Disturbance
        sysctlDist;
        omega;
        numDist;
        denDist;
        sysDist;
        dist_input;

        %calculation for output_Tc
        sysctlTc;

        % Transfer function for Tc/Td
        sysctlTCTD;

        % Zeros and Poles of sysctl
        zcl;
        pcl;

        % Properties for step input
        numStep;
        sysStep;

        % Properties of step response
        settling_time;
        overshoot;
        steady_state_error;
        steady_state_error_dist;

        % Time vectors for plotting
        t_step;
        t_dist;
        t_output_Tc;

        % Output signals of simulations
        output_y_step;
        output_y_dist;
        output_Tc;
        output_Tc_Integrated;
    end
    
    methods
        function obj = satellite(~)
            % Calculate Transfer function for G
            obj.numG = 1;
            obj.denG = [400 0 0];
            obj.sysG = tf(obj.numG, obj.denG);

            % Calculate disturbance input
            obj.omega = 7.28E-5;

            obj.numDist = [10^-4 0];
            obj.denDist = [1 0 (obj.omega)^2];
            obj.sysDist = tf(obj.numDist, obj.denDist);

            % Used to simulate different amplitudes for step inputs
            obj.numStep = 1;
            obj.sysStep = tf(obj.numStep);
        end
        
        function calc_sysctl(obj)
            obj.sysfo = series(obj.sysK, obj.sysG);
            obj.sysctl = feedback(obj.sysfo, 1);

            % apply Amplitude for step input
            obj.sysctl = series(obj.sysStep, obj.sysctl);
        end

        function calc_sysctl_dist(obj)
            obj.sysctlDist = feedback(obj.sysG, -obj.sysK, 1);
            obj.sysctlDist = series(obj.sysStep, obj.sysctlDist);

            %obj.sysctlDist = series(obj.sysDist, obj.sysctlDist);
        end

        function calc_sysctl_tc(obj)
            obj.sysctlTc = feedback(obj.sysK, obj.sysG);
            obj.sysctlTc = series(obj.sysStep, obj.sysctlTc);
        end

        function calc_sysctl_td_tc(obj)
            obj.sysctlTCTD = feedback(series(-obj.sysG, obj.sysK), 1, 1);
        end

        function obtain_result(obj)
            obj.t_step = 0:0.1:500;
            obj.t_output_Tc = 0:0.1:500;
            obj.t_dist = 0:10:2*86400;

            obj.output_y_step = step(obj.sysctl, obj.t_step);

            obj.zcl = zero(obj.sysctl);
            obj.pcl = pole(obj.sysctl);

            s = stepinfo(obj.output_y_step, obj.t_step);
            obj.settling_time = s.SettlingTime;
            obj.overshoot = s.Overshoot;
            obj.steady_state_error = (obj.numStep - obj.output_y_step(end))*100;

            % disturbance input
            obj.output_y_dist = step(obj.sysctlDist, obj.t_step);
            obj.steady_state_error_dist = (obj.numStep - obj.output_y_dist(end))*100;

            obj.output_Tc_Integrated = cumtrapz(obj.t_output_Tc, abs(step(obj.sysctlTc, obj.t_output_Tc)));
            obj.output_Tc = step(obj.sysctlTc, obj.t_output_Tc);

        end

        function plot_result(obj)
            % Closed-Loop step response
            figure;
            plot(obj.t_step,obj.output_y_step), grid;
            xlabel('Time (s)');
            ylabel('Output Y(t) (Degree)');
            title(sprintf("Closed-Loop Step Response of Controller %d",obj.ControllerNum));

            % Disturbance actual input
            figure;
            obj.dist_input = 10^-4*cos(obj.omega*obj.t_dist);
            lsim(obj.sysctlDist, obj.dist_input, obj.t_dist);
            xlabel('Time (s)');
            ylabel('Output Y(t) (Degree)');
            grid on;
            title(sprintf("Disturbance Input of Controller %d",obj.ControllerNum));
            
            % Disturbance Step Input
            figure;
            plot(obj.t_step,obj.output_y_dist), grid;
            xlabel('Time (s)');
            ylabel('Output Y(t) (Degree)');
            grid on;
            title(sprintf("Disturbance Step Input of Controller %d",obj.ControllerNum));

            % Tc for step input
            figure;
            plot(obj.t_output_Tc,obj.output_Tc), grid;
            xlabel('Time (s)');
            ylabel('Signal Tc(t)');
            grid on;
            title(sprintf("Signal Tc of Controller %d for Step Input",obj.ControllerNum));

            % Tc Integrated for step input
            figure;
            plot(obj.t_output_Tc,obj.output_Tc_Integrated), grid;
            xlabel('Time (s)');
            ylabel('Integral of Tc(t)');
            grid on;
            title(sprintf("Integrated Tc for disturbance step Input of Controller %d",obj.ControllerNum));

            % Tc for sinus disturbance input
            figure;
            obj.dist_input = 10^-4*cos(obj.omega*obj.t_dist);
            lsim(obj.sysctlTCTD, obj.dist_input, obj.t_dist);
            xlabel('Time (s)');
            ylabel('Signal Tc(t)');
            grid on;
            title(sprintf("Tc for cosin disturbance input of Controller %d",obj.ControllerNum));
        end
    end
end

