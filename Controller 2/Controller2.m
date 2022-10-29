classdef Controller2 < satellite
    properties
        
    end

    methods
        function obj = Controller2()
            obj@satellite();
            obj.numK = 3*[80 1];
            obj.denK = 20*[4 1];
            obj.sysK = tf(obj.numK, obj.denK);

            obj.ControllerNum = 2;

            obj.calc_sysctl();
            obj.calc_sysctl_dist();
            obj.calc_sysctl_tc();
            obj.calc_sysctl_td_tc();
        end
    end
end