classdef Controller3 < satellite
    properties
        
    end

    methods
        function obj = Controller3()
            obj@satellite();
            obj.numK = 35*[40 1];
            obj.denK = 40*[1 2];
            obj.sysK = tf(obj.numK, obj.denK);

            obj.ControllerNum = 3;

            obj.calc_sysctl();
            obj.calc_sysctl_dist();
            obj.calc_sysctl_tc();
            obj.calc_sysctl_td_tc();
        end
    end
end
