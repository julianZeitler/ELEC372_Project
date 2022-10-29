classdef Controller1 < satellite
    properties
        
    end

    methods
        function obj = Controller1()
            obj@satellite();
            obj.numK = [0.1 0.01];
            obj.denK = [1 0];
            obj.sysK = tf(obj.numK, obj.denK);

            obj.ControllerNum = 1;

            obj.calc_sysctl();
            obj.calc_sysctl_dist();
            obj.calc_sysctl_tc();
            obj.calc_sysctl_td_tc();
        end
    end
end