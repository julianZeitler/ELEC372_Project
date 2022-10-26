classdef satellite < handle
    %SATELLITE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %G 
        numG;
        denG;
        sysG;

        numK;
        denK;
        sysK;
        
        sysfo;
        sysctl;

        zcl;
        pcl;

        numStep;
        sysStep;

        settling_time;
        overshoot;
        steady_state_error;

        t;
        y;
    end
    
    methods
        function obj = satellite(~)
            obj.numG = 1;
            obj.denG = [400 0 0];
            obj.sysG = tf(obj.numG, obj.denG);

            obj.numStep = 1;
            obj.sysStep = tf(obj.numStep);
        end
        
        function calc_sysctl(obj)
            obj.sysfo = series(obj.sysK, obj.sysG);
            obj.sysctl = feedback(obj.sysfo, 1);

            % apply Amplitude for step input
            obj.sysctl = series(obj.sysStep, obj.sysctl);
        end

        function obtain_result(obj)
            obj.t = 0:0.5:500;
            obj.y = step(obj.sysctl, obj.t);

            obj.zcl = zero(obj.sysctl);
            obj.pcl = pole(obj.sysctl);

            s = stepinfo(obj.y, obj.t);
            obj.settling_time = s.SettlingTime;
            obj.overshoot = s.Overshoot;
            obj.steady_state_error = (obj.numStep - obj.y(end))*100;
        end

        function plot_result(obj)
            figure;
            plot(obj.t,obj.y), grid;
            xlabel('Time (s)');
            ylabel('Output Y(t)');
            title('Example1: Closed-Loop Step Response.');
        end

        function print_result(obj)
            disp('Transfer function G');
            obj.sysG
            
            disp('Transfer function K');
            obj.sysK

            disp('Transfer function sysctl');
            obj.sysctl

            disp('The poles are');
            obj.pcl

            disp('settling time');
            disp(obj.settling_time);

            disp('overshoot');
            disp(obj.overshoot);

            disp('steady-state-error');
            disp(obj.steady_state_error);
        end
    end
end

